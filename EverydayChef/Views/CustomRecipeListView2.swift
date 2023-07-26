//
//  CustomRecipeListView2.swift
//  EverydayChef
//
//  Created by Ameya Joshi on 2023-07-24.
//

import SwiftUI

struct CustomRecipeListView2: View {
    
    @EnvironmentObject var fireDBController:FireDbController
    
    @State private var customRecipeList:[CustomRecipe] = []
    
    var body: some View{
        VStack{
            Text("Custom Recipes")
            
            List{
                ForEach(customRecipeList){ customRecipe in
                    
                    NavigationLink {
                        CustomRecipeDetailView(customRecipe: customRecipe)
                    } label: {
                        CustomRecipeCardView(customRecipe: customRecipe)
                    }//NavigationLink

//                    VStack{
//                        AsyncImage(url: URL(string: customRecipe.imageURLString)) { image in
//                            image
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width:96, height: 96)
//                                .clipped()
//                        } placeholder: {
//                            ProgressView()
//                        }
//
//                        Text(customRecipe.recipeCuisine)
//
//                    }//VStack
                    //CustomRecipeCardView(customRecipe: customRecipe)
                }//ForEach
            }//List
            .listStyle(.plain)
            
        }//VStack
        .onAppear{
            Task(priority:.background){
                customRecipeList = await fireDBController.getCustomRecipes()
                
                if customRecipeList.count > 0{
                    print("Custom Recipes Fetched from the Database")
                }//if count > 0
            }//Task
        }//onAppear
    }//body
    
}//struct CustomRecipeListView2

struct CustomRecipeListView2_Previews: PreviewProvider {
    static var previews: some View {
        CustomRecipeListView2().environmentObject(FireDbController.sharedFireDBController)
    }
}
