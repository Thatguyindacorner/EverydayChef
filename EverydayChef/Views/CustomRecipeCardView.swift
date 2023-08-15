//
//  CustomRecipeCardView.swift
//  CatchEmAllApp
//
//  Created by Ameya Joshi on 2023-07-25.
//

import SwiftUI

struct CustomRecipeCardView: View {
    
    var customRecipe:CustomRecipe?
    
    var body: some View {
        VStack{
            AsyncImage(url: URL(string: customRecipe?.imageURLString ?? "")) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(12)
            } placeholder: {
                ProgressView()
            }//AsyncImage

            VStack(spacing: 12){
                Text(customRecipe?.recipeName ?? "Unknown")
                    .font(.title.weight(.bold))
                    .foregroundColor(.green)
                    .lineLimit(1)
                    //.frame(minWidth: 0, maxWidth: .infinity, alignment:.center)
                
                HStack(spacing:30){
                    
                    VStack{
                        HStack{
                            Image(systemName: "person.2.fill")
                                .foregroundColor(.blue)
                            Text("Serves")
                        }
                        
                        Text("\(customRecipe?.serves ?? 0)")
                    }
                    
                    VStack{
                        HStack{
                            Image(systemName: "clock.fill")
                                .foregroundColor(.brown)
                            Text("Prep")
                        }
                        
                        Text("\(customRecipe?.prepTime ?? 0) minutes")
                    }
                    
                    
                    
                }//Main HStack
            }//Custom Recipe Data VStack
            .padding()
            
        }//VStack
        .background(.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.5), radius: 8, x: 0, y: 5)
        
    }//body
}//struct CustomRecipeCardView

struct CustomRecipeCardView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        CustomRecipeCardView(customRecipe: CustomRecipe(imageURLString: "https://firebasestorage.googleapis.com:443/v0/b/everyday-chef.appspot.com/o/8jIa3CjjcKPXW4bQ4PP3RQY51zP2%2FPhotos%2F61D976AB-90B7-4F0E-9FFF-75027408D098.jpeg?alt=media&token=0fcb5f6a-9da8-4e3e-bb7a-5e64ec7415d8", recipeName: "TestRecipe", recipeInstructions: "Mix and Eat",   recipeCuisine: "British", recipeIngredients: "Salt, Pepper", serves: 4, prepTime: 20))
    }
}
