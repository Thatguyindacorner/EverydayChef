//
//  WhatToMakeView.swift
//  EverydayChef
//
//  Created by Alex Olechnowicz on 2023-08-09.
//

import SwiftUI

struct WhatToMakeView: View {
    
    @StateObject var randomRecipeViewModel:RandomRecipeViewModel = RandomRecipeViewModel()
    
    @State private var recipeSearch:String = ""
    
    @State var done: Bool = false
    @State var results: [FoundRecipesByIngredients] = []
    @State var goToRecipe = false
    @State var recipeData:Recipe? = nil
    @State var imagesBaseURL: String = "https://spoonacular.com/cdn/ingredients_100x100/"
    
    var body: some View {
        
        GeometryReader {space in
            ScrollView{
                
                if !done{
                    VStack{
                        
                        Text("Figuring out what you can make right now...")//.font(.title3)
                            //.frame(width: .infinity, alignment: .center)
                        
                        ProgressView().tint(.red)//.fixedSize()
                        
                    }.frame(width: space.size.width, height: space.size.height)//.padding()
                    
                }
                else{
                    if results.isEmpty{
                        VStack{
                            Text("Cannot find any results").font(.title)
                            Text("More ingreidents required").font(.title2)
                        }
                        .frame(width: space.size.width, height: space.size.height)//.padding()
                    }
                    NavigationLink(destination: RecipeDetailView(randomRecipeViewModel: randomRecipeViewModel, recipe: recipeData), isActive: $goToRecipe) {
                    }
                }
                
                ForEach (results, id: \.id){ recipe in
                    
                    Button(action:{

                        Task{
                            self.recipeData = await SearchRecipeByIngredientViewModel().getRecipeById(id: recipe.id ?? 404)
                            self.goToRecipe = true
                        }
                        
                    }){
                        VStack{
                            
                            AsyncImage(url: URL(string: recipe.image ?? "\(imagesBaseURL) apple.jpg")) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                ProgressView()
                                    .tint(.gray)
                            }

                            Text(recipe.title ?? "Strawberry Ice Cream")
                                .font(.title).bold()
                                .foregroundColor(.blue)
                                .lineLimit(1)



                        }.background(.white)
                            .cornerRadius(12)
                            .shadow(color: .gray.opacity(0.5), radius: 8, x: 0, y: 5)
                            .padding()
                    }
                    
                }
            }
        }
        
        .navigationTitle("What Can I Make Right Now?")
        
        .onAppear{
            if !done{
                Task{
                    self.results = await SearchRecipeByIngredientViewModel.readyToMakeRecipes()
                    self.done = true
                }
            }
        }
    }
}

struct WhatToMakeView_Previews: PreviewProvider {
    static var previews: some View {
        WhatToMakeView()
    }
}
