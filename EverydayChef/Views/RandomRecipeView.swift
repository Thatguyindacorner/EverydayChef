//
//  RandomRecipeView.swift
//  CatchEmAllApp
//
//  Created by Ameya Joshi on 2023-06-13.
//

import SwiftUI

struct RandomRecipeView: View {
    
    @StateObject var randomRecipeViewModel:RandomRecipeViewModel = RandomRecipeViewModel()
    
    @State private var recipeSearch:String = ""
    
    var body: some View {
       // NavigationStack{
            VStack{
                
                VStack {
                    TextField("Search Recipes", text: $recipeSearch)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .textFieldStyle(.roundedBorder)
                    
                    Button(action:{
                        print("Perform Recipe Search Action")
                        searchRecipe()
                    }){
                        Text("Search")
                            .padding()
                            .padding(.horizontal, 15)
                            .background(.brown)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                }
                
                ScrollView(){
                    
                    LazyVStack{
                        
                        ForEach(randomRecipeViewModel.recipeList, id: \.self){ recipe in
                            
                            NavigationLink {
                                RecipeDetailView(randomRecipeViewModel: randomRecipeViewModel, recipe: recipe)
                            } label: {
                                RecipeCardView(recipe: recipe)
                                    .padding(.vertical, 10)
                            }
                        }//ForEach
                        
                    }//LazyVStack
                    
                    
                }//ScrollView
                
//                List{
//
//                    ForEach(randomRecipeViewModel.recipeList, id: \.self){ recipe in
//                        VStack(alignment:.leading){
//                            Text(recipe.title ?? "Unknown")
//
//                            AsyncImage(url: URL(string: recipe.image!), content: {image in
//                                image
//                                    .resizable()
//                                    .scaledToFill()
//                                    .frame(maxWidth:100, maxHeight: 100)
//                                    .cornerRadius(16)
//                                    .shadow(radius: 8, x: 5, y:5)
//
//                            }) {
//                                RoundedRectangle(cornerRadius: 10)
//                                    .foregroundColor(.clear)
//                                    .frame(maxWidth: 100, maxHeight: 100)
//                            }
//
////                            Image(recipe.image!)
////                                .resizable()
////                                .scaledToFit()
////                                .frame(width: 100, height: 100)
//                        }
//                    }
//
//                }//List
//                .listStyle(.plain)
                
            }//VStack
            .padding(.horizontal, 10)
            .onAppear{
                Task{
                    await randomRecipeViewModel.getRandomRecipes()
                }
            }
            .navigationTitle(Text("Random Recipes"))
      //  }//NavStack
        
    }//body
    
    func searchRecipe(){
        Task(priority:.background){
           await randomRecipeViewModel.searchRecipes(searchTerm:recipeSearch)
        }
    }
}

struct RandomRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            RandomRecipeView()
        }
    }
}
