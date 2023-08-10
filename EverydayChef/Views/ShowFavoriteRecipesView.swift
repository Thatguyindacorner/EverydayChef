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
    
    var body: some View {
        
        VStack{
            
            ZStack{
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
                                
                            }
                        }

                    }//ForEach
                    .onDelete(perform: { indexSet in
                        print("Delete Favorite Recipe from the Firestore and the Array")
                        
                        deleteFavRecipe(indexSet: indexSet)
                    })
                    .listRowSeparator(.hidden)
                
                    
                }//List
                .listStyle(.plain)
                .listRowBackground(Color.clear)
                
                
                if showProgress{
                    ProgressView()
                        .tint(.red)
                        .scaleEffect(4)
                }
                
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
                    self.showProgress = true
                    favRecipesList = await fireDbController.getAllFavoriteRecipes()
                    
                    for recipe in favRecipesList{
                       await randomRecipesViewModel.getRecipeById(recipe.recipeId)
                    }
                    
                    self.showProgress = false
                    
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
    
}//body

struct ShowFavoriteRecipesView_Previews: PreviewProvider {
    static var previews: some View {
        ShowFavoriteRecipesView().environmentObject(FireDbController.sharedFireDBController)
            .environmentObject(RandomRecipeViewModel())
    }
}
