//
//  ShowFavoriteRecipesView.swift
//  EverydayChef
//
//  Created by Ameya Joshi on 2023-06-28.
//

import SwiftUI

struct ShowFavoriteRecipesView: View {
    
    @StateObject var fireDbController:FireDbController = FireDbController.sharedFireDBController
    
    @StateObject var randomRecipesViewModel:RandomRecipeViewModel = RandomRecipeViewModel()
    
    @State private var favRecipesList:[FavoriteRecipes] = []
    
    @State private var showProgress:Bool = false
    
    @State private var errorMessage:String = ""
    
    @State private var displayErrorAlert:Bool = false
    
    
    var body: some View {
        
        VStack{
            
            ZStack{
                
                if favRecipesList.count <= 0{
                    NoFavoriteRecipeData()
                }else{
                    
                    List{
                        ForEach(randomRecipesViewModel.favoriteRecipesList, id: \.self){ favRecipe in
                            NavigationLink {
                                RecipeDetailView(randomRecipeViewModel: randomRecipesViewModel, recipe: favRecipe, isFav: true)
                            } label: {
                                //RecipeCardView(recipe: favRecipe)
                                ZStack{
                                    RecipeCardView(recipe: favRecipe)
                                    
                                    if showProgress{
                                        ProgressView()
                                            .tint(.blue)
                                            .scaleEffect(4)
                                    }
                                    
                                }//Inner ZStack
                            }//Label
                            
                        }//ForEach
                        .onDelete(perform: { indexSet in
                            print("Delete Favorite Recipe from the Firestore and the Array")
                            
                            deleteFavRecipe(indexSet: indexSet)
                        })
                        .listRowSeparator(.hidden)
                        
                        
                    }//List
                    .listStyle(.plain)
                    .listRowBackground(Color.clear)
                    
                    .alert("Error", isPresented: self.$displayErrorAlert) {
                        Button("OK", role: .cancel){
                            self.displayErrorAlert = false
                        }
                    } message: {
                        Text("\(self.errorMessage)")
                    }
                    
                }// if favoriteRecipeList is empty check
                    
                if showProgress{
                    ProgressView()
                        .tint(.red)
                        .scaleEffect(4)
                }//if showProgress
                
            }//ZStack
        }
        .navigationTitle("Favourited Recipes")
        .onAppear{

            if randomRecipesViewModel.favoriteRecipesList.isEmpty{
                Task(priority:.background){
                    //await getFavoriteRecipes()
                    
    //                fireDbController.favoriteRecipesList = []
    //
    //                await fireDbController.getAllFavoriteRecipes()
    //
                     let fireBResults = await processFavoriteRecipes()
                
                if fireBResults{
                    print("Get Recipes by Ids")
                    
                    for recipe in favRecipesList{
                       
                        
                        //await randomRecipesViewModel.getRecipeById(recipe.recipeId)
                        
                        let recipeByIdResult = await retrieveRecipeById(recipe.recipeId)
                        
                        if recipeByIdResult{
                            print("Recipe retrieved successfully from Spoonacular")
                        }else{
                            
                            displayErrorAlert = true
                            
                        }//else
                        
                    }//for
                    
                    self.showProgress = false
                    
                }else{
                    print("Couldn't get Results for Favorite Recipes from Firestore")
                    showProgress = false
                }
                    
                }//Task
            }
            

        }
        
    }//body
    
    func deleteFavRecipe(indexSet:IndexSet){
        
        for index in indexSet{
            Task(priority:.background){
                let element = favRecipesList[index]
                
                let deleteResult = await fireDbController.deleteFavoriteRecipe(favoriteRecipes: element)
                
                if deleteResult{
                 let deleted = await MainActor.run {
                        favRecipesList.remove(at: index)
                    }//MainActor.run
                   print("Favorite Recipe deleted from the Database and The Array")
                }
                
            }//Task
        }//for loop
        
        
    }//deleteFavRecipe
    
    
    func processFavoriteRecipes() async -> Bool{
        
        let taskFavRecipeResult = Task(priority:.background){ () -> Bool in
            
            do{
                await MainActor.run(body: {
                    self.favRecipesList = []
                })
                    self.favRecipesList = try await fireDbController.getAllFavoriteRecipes2()
                return true
                
            }catch{
                print("Error while getting Favorite Recipes from Firestore \(error.localizedDescription)")
                
                self.errorMessage = error.localizedDescription
                
                return false
            }//catch
            
        }//taskFavRecipeResult
        
        let result = await taskFavRecipeResult.value
        
        return result
        
    }//processFavoriteRecipes
    
    
    func retrieveRecipeById(_ recpID:Int) async -> Bool{
        
        let retrieveRecipeResult = Task(priority:.background){ () -> Bool in
            
            do{
             
                let result = try await randomRecipesViewModel.getRecipeById2(recpID)
                
                return result
            }catch{
                print("Problem fetching Recipe by ID \(error.localizedDescription)")
                
                self.errorMessage = "Error Getting Recipe. Please try again"
                
                return false
            }//catch
        }//retrieveRecipeResult
        
        let result = await retrieveRecipeResult.value
        
        return result
        
    }//searchRecipe
    
    
}//body

struct NoFavoriteRecipeData:View{
    
    var body: some View{
        
        Text("Cannot Load Favorite Recipe Data or Favorite Recipes Unavailable")
        
    }//body
    
}//NoFavoriteRecipeData

struct ShowFavoriteRecipesView_Previews: PreviewProvider {
    static var previews: some View {
        ShowFavoriteRecipesView().environmentObject(FireDbController.sharedFireDBController)
            .environmentObject(RandomRecipeViewModel())
    }
}
