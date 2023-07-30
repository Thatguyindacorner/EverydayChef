//
//  CustomRecipeDetailView.swift
//  CatchEmAllApp
//
//  Created by Ameya Joshi on 2023-07-25.
//

import SwiftUI

struct CustomRecipeDetailView: View {
    
    var customRecipe:CustomRecipe?
    
    var body: some View {
        ScrollView{
            
            VStack{
                
                Group{
                    
                    AsyncImage(url: URL(string: customRecipe?.imageURLString ?? "")) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .cornerRadius(12)
                    } placeholder: {
                        ProgressView()
                    }
                    .padding(.bottom, 20)
                    
                    HStack{
                        Text("\(customRecipe?.recipeName ?? "")")
                            .lineLimit(2)
                        
                        Text("|")
                        
                        Text("Prep Time: \(customRecipe?.prepTime ?? 0) mins")
                        
                    }//PrepTime and Serves HStack
                    .font(.caption)
                    //.bold()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.bottom, 5)
                    .padding()
                    .background(.yellow)
                    .cornerRadius(12)
                    
                }//Image and Recipe Title/preptime Group
                
                Group{
                    
                    VStack(alignment:.center, spacing: 2){
                        Text("Cuisine Type: \(customRecipe?.recipeCuisine ?? "Unknown")")
                        
                        Text("Serves: \(customRecipe?.serves ?? 0)")
                    }
                    
                    Text("Ingredients")
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                        //.fontWeight(.bold)
                    
                    Text(customRecipe?.recipeIngredients ?? "Unknown Ingredients")
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    
                    
                    Text("Instructions")
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                        //.fontWeight(.bold)
                    
                    Text(customRecipe?.recipeInstructions ?? "Unknown Directions")
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    
                    
                    
                    
                }//Recipe Details Group
                
                
            }//Main VStack
        }//ScrollView
    }//body
}//CustomRecipeDetailView

struct CustomRecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CustomRecipeDetailView(customRecipe: CustomRecipe(imageURLString: "https://firebasestorage.googleapis.com:443/v0/b/everyday-chef.appspot.com/o/8jIa3CjjcKPXW4bQ4PP3RQY51zP2%2FPhotos%2F61D976AB-90B7-4F0E-9FFF-75027408D098.jpeg?alt=media&token=0fcb5f6a-9da8-4e3e-bb7a-5e64ec7415d8", recipeName: "TestRecipe", recipeInstructions: "Mix and Eat",   recipeCuisine: "British", recipeIngredients: "Salt, Pepper", serves: 4, prepTime: 20))
    }
}
