//
//  RandomRecipeViewModel.swift
//  CatchEmAllApp
//
//  Created by Ameya Joshi on 2023-06-13.
//

import Foundation

@MainActor
class RandomRecipeViewModel:ObservableObject{
    
    @Published var recipeList:[Recipe] = []
    
    @Published var recipeImage:String = ""
    
    @Published var recipeTitle:String = ""
    
    let recipeURL:String = "https://api.spoonacular.com/recipes/random?number=2&apiKey=d01c0f4e6a324d2c861e9b967a6e5d87"
    
    func getRandomRecipes() async{
        
        guard let randomRecipeURL = URL(string: recipeURL) else{
            print("Error converting to a valid URL")
            return
        }
        
        do{
            
            let (data,urlResponse) = try await URLSession.shared.data(from: randomRecipeURL)
            
            guard let httpURLResponse = urlResponse as? HTTPURLResponse else{
                
                print("Cannot cast to HTTPURLResponse")
                
                return
                
            }//guard httpURLResponse
            
            if httpURLResponse.statusCode == 200{
                
                //TODO: Decode JSON
                guard let returnedRecipes = try? JSONDecoder().decode(ReturnedRecipeData.self, from: data) else{
                    print("ERROR:: Trouble decoding data into Swift Structs")
                    
                    return
                }
                
                self.recipeList = returnedRecipes.recipes
                
                for recipe in recipeList{
                    print("Recipe title: \(recipe.title ?? "Unknown")")
                    print("Recipe Image: \(recipe.image ?? "Unknown")")
                    
                    print(recipe)
                    
                    self.recipeImage = recipe.image ?? ""
                    
                    self.recipeTitle = recipe.title ?? ""
                    
                    for extendedIngredient in recipe.extendedIngredients{
                        print("Ingredient Name: \(extendedIngredient.name ?? "Unknown")")
                        
                        print("Ingredient Image: \(extendedIngredient.image ?? "Unknown")")
                    }
                    
                    for analyzedInstruction in recipe.analyzedInstructions{
                        
                        for step in analyzedInstruction.steps{
                            print("Step Number: \(step.number ?? 0)")
                            
                            print("Step \(step.number ?? 0)---- \(step.step ?? "Unknown")")
                            
                            if step.ingredients.count > 0{
                                for ingredient in step.ingredients{
                                    print("Ingredient Name: \(ingredient.name ?? "Unknown Ingredient")")
                                }
                            }//if ingredient.count > 0
                            
                            if step.equipment.count > 0{
                                for equiment in step.equipment{
                                    print("Equipment Name: \(equiment.name ?? "Unknown Equipment")")
                                }
                            }
                            
                        }//step
                        
                    }//analyzedInstruction
                }//for recipe in recupeList
                
            }else{
                print("ERROR: BAD STATUS CODE.. Status code is \(httpURLResponse.statusCode)")
                return
            }//check if status code valid
            
        }catch{
            
        }//catch
    }//getRandomRecipes()
}
