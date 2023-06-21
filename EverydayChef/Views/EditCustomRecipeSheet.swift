//
//  EditCustomRecipeSheet.swift
//  EverydayChef
//
//  Created by Ameya Joshi on 2023-06-20.
//

import SwiftUI

struct EditCustomRecipeSheet: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var fireDBController:FireDbController
    
    @State private var recipeName:String = ""
    
    @State private var recipeCuisine:String = ""
    
    @State private var recipeIngredients:String = ""
    
    @State private var recipeDirections:String = ""
    
    var customRecipe:CustomRecipe?
    
    var body: some View {
        ScrollView{
            VStack{
                Group{
                    Text("Edit Recipes")
                        .padding(.vertical, 20)
                        .font(.system(size: 23).bold())
                    
                    TextField("Edit Recipe Name", text: $recipeName)
                    //.textFieldStyle(.roundedBorder)
                        .textFieldStyle(CustomTextFieldStyle(setPadding: 20))
                    
                    TextField("Recipe Cuisine", text: $recipeCuisine)
                        .textFieldStyle(CustomTextFieldStyle(setPadding: 20))
                    
                    TextField("Recipe Ingredients", text: $recipeIngredients)
                        .textFieldStyle(CustomTextFieldStyle(setPadding: 20))
                    
                    TextField("Directions", text: $recipeDirections)
                        .textFieldStyle(CustomTextFieldStyle(setPadding: 20))
                }//group
                .padding(.bottom, 20)
                
                Button(action:{
                    print("Edit Recipe")
                    
                    saveEdits()
                    
                    dismiss()
                }){
                    Text("Edit")
                        .padding()
                        .padding(.horizontal, 20)
                        .background(.yellow)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }//VStack
            .padding()
            .onAppear{
                recipeName = customRecipe?.recipeName ?? "Edit Recipe Name"
                
                recipeCuisine = customRecipe?.recipeCuisine ?? "Edit Cuisine"
                
                recipeIngredients = customRecipe?.recipeIngredients ?? "Edit Ingredients"
                
                recipeDirections = customRecipe?.recipeInstructions ?? "Edit Instructions"
            }//onAppear
        }//ScrollView
    }
    
    func saveEdits(){
        
        let name = recipeName.trimmingCharacters(in: .whitespaces)
        
        let cuisine = recipeCuisine.trimmingCharacters(in: .whitespaces)
        
        let ingredients = recipeIngredients.trimmingCharacters(in: .whitespaces)
        
        let directions = recipeDirections.trimmingCharacters(in: .whitespaces)
        
        if let index = fireDBController.userRecipeList.firstIndex(where: {
            $0.id == customRecipe?.id
        }){
            let newCustomRecipe = CustomRecipe(id: customRecipe?.id! ,recipeName: name, recipeInstructions: directions, recipeCuisine: cuisine, recipeIngredients: ingredients)
            
            Task{
                let result = await fireDBController.updateRecipe(editedRecipe: newCustomRecipe)
                print("Recipe Edited \(result)")
            }
        }
        
    }
}

struct EditCustomRecipeSheet_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 16.0, *) {
            NavigationStack{
                EditCustomRecipeSheet().environmentObject(FireDbController.sharedFireDBController)
            }
        }
    }
}
