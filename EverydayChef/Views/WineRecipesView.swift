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
    
    var body: some View {
        VStack{
            Text("Recipes Found for \(dishName ?? "Unknown")")
            
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
            
        }//VStack
        .onAppear{
            Task(priority:.background){
                await randomRecipesViewModel.searchRecipes(searchTerm:dishName?.trimmingCharacters(in: .whitespaces).lowercased() ?? "")
            }
        }
    }//body
}//struct WineRecipesView

struct WineRecipesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            WineRecipesView()
        }
    }
}
