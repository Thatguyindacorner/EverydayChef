//
//  RecipeCardView.swift
//  CatchEmAllApp
//
//  Created by Ameya Joshi on 2023-06-13.
//

import SwiftUI

struct RecipeCardView: View {
    
    var recipe:Recipe?
    
    var body: some View {
        VStack{
            
            AsyncImage(url: URL(string: recipe?.image ?? "")) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(12)
            } placeholder: {
                Image("norecipe")
                    .resizable()
                    .scaledToFit()
                
            }

            
//            Image(recipe?.image ?? "norecipe")
//                .resizable()
//                .scaledToFit()
            
            VStack(alignment:.leading, spacing: 12){
                
                Text(recipe?.title ?? "Strawberry Ice Cream")
                    .font(.title.weight(.bold))
                    .foregroundColor(.green)
                    .lineLimit(1)
                
                HStack(spacing:30){
                    VStack{
                        HStack{
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                            Text("Likes")
                        }
                        Text("\(recipe?.aggregateLikes ?? 4)")
                    }//Rating
                    
                    VStack{
                        HStack{
                            Image(systemName: "person.2.fill")
                                .foregroundColor(.blue)
                            Text("Serves")
                        }
                        
                        Text("\(recipe?.servings ?? 2)")
                    }
                    
                    VStack{
                        HStack{
                            Image(systemName: "clock.fill")
                                .foregroundColor(.brown)
                            Text("Prep")
                        }
                        
                        Text("\(recipe?.readyInMinutes ?? 45) minutes")
                    }
                    
                    
                    
                }//Main HStack
                
            }//Recipe data Vstack
            .padding()
            
        }//VStack
        .background(.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.5), radius: 8, x: 0, y: 5)
    }//body
}

struct RecipeCardView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCardView()
    }
}
