//
//  WineRecipesView.swift
//  CatchEmAllApp
//
//  Created by Ameya Joshi on 2023-07-03.
//

import SwiftUI

struct WineRecipesView: View {
    
    @StateObject var randomRecipesViewModel:RandomRecipeViewModel = RandomRecipeViewModel()
   
    var dishName:String?
    
    @State private var errorMessage:String = ""
    
    @State private var displayErrorAlert:Bool = false
    
    var body: some View {
        VStack{
            Text("Recipes Found for \(dishName ?? "Unknown")")
            
            ZStack{
                
                if randomRecipesViewModel.recipeList.count <= 0{
                    NoDataView()
                }else{
                    
                    List{
                        
                        ForEach(randomRecipesViewModel.recipeList, id: \.self){ recipe in
                            NavigationLink {
                                RecipeDetailView(randomRecipeViewModel: randomRecipesViewModel, recipe: recipe)
                            } label: {
                                RecipeCardView(recipe: recipe)
                            }
                        }
                        
                    }//List
                    .listStyle(.plain)
                    
                    
                }
                
                if randomRecipesViewModel.showProgressView{
                    ProgressView()
                        .tint(.red)
                        .scaleEffect(4)
                }
            }//ZStack
        }//VStack
        .onAppear{
//            Task(priority:.background){
//                await randomRecipesViewModel.searchRecipes(searchTerm:dishName?.trimmingCharacters(in: .whitespaces).lowercased() ?? "")
//            }
            
            randomRecipesViewModel.recipeList.removeAll()
            
            Task(priority:.background){
                
                let result = await searchRecipe2()
                
                if result{
                    print("Successfully found Search Results")
                }else{
                    
                    print("Error while getting Search Results or unable to search for Recipes")
                    
                    self.displayErrorAlert = true
                    
                }//if result false
                
            }//Task
            
        }
    }//body
    
    func searchRecipe2() async -> Bool{
        
        let returnedSRTaskResult = Task(priority:.background){ () -> Bool in
            
            do{
                let result = try await randomRecipesViewModel.searchRecipes2(searchTerm:dishName?.trimmingCharacters(in: .whitespaces).lowercased() ?? "")
                
                return result
            }catch{
                print("Error while getting results for Recipes \(error.localizedDescription)")
                
                self.errorMessage = error.localizedDescription
                
                return false
                
            }//catch
            
        }//returnedSRTaskResult
        
        let result = await returnedSRTaskResult.value
        
        return result
    }//searchRecipes2
    
}//struct WineRecipesView

//struct WineRecipesView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack{
//            WineRecipesView()
//        }
//    }
//}
