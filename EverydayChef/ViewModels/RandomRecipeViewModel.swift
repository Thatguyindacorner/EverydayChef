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
    
    @Published var favoriteRecipesList:[Recipe] = []
    
    let recipeURL:String = "https://api.spoonacular.com/recipes/random?number=2&apiKey=9947b019d7f343a3aea18080c939d70e"//d01c0f4e6a324d2c861e9b967a6e5d87"
    
    let searchRecipeURL:String = "https://api.spoonacular.com/recipes/random?"
    
    let recipeByIdURL:String = "https://api.spoonacular.com/recipes/"
    
    
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
    
    
    func searchRecipes(searchTerm:String) async{
        
        let search = searchTerm.trimmingCharacters(in: .whitespaces).lowercased()
        
        let completeURLStr = searchRecipeURL + "tags=\(search)&number=5&apiKey=9947b019d7f343a3aea18080c939d70e"//d01c0f4e6a324d2c861e9b967a6e5d87"
        
        guard let searchURL = URL(string: completeURLStr) else{
            print("Cannot convert to URL")
            
            return
        }
        
        do{
            let (data,urlResponse) = try await URLSession.shared.data(from: searchURL)
            
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
            print("Error")
            return
        }
        
    } //searchRecipes
    
    
    func getRecipeById(_ forID:Int) async{
        
//        let buildURLString:String = "\(recipeByIdURL)\(forID)/information?apiKey=9947b019d7f343a3aea18080c939d70e"//d01c0f4e6a324d2c861e9b967a6e5d87"
        
        let buildURLString:String = "\(recipeByIdURL)\(forID)/information?apiKey=9947b019d7f343a3aea18080c939d70e"//d01c0f4e6a324d2c861e9b967a6e5d87"
        
        guard let recipeByIDURL = URL(string: buildURLString) else{
            print("Error converting String to URL")
            return
        }
        
        do{
            
            print("Trying to get a response")
            
            let (data,urlResponse) = try await URLSession.shared.data(from: recipeByIDURL)
            
            guard let httpURLResponse = urlResponse as? HTTPURLResponse else{
                
                print("Cannot cast to HTTPURLResponse")
                
                return
                
            }//guard httpURLResponse
            
            if httpURLResponse.statusCode == 200{
                
                //TODO: Decode JSON
                guard let returnedRecipe = try? JSONDecoder().decode(Recipe.self, from: data) else{
                    print("ERROR:: Trouble decoding data into Swift Structs")
                    
                    return
                }
                
                print("Recipe Data Successfully Returned \(returnedRecipe.id)")
                
                print("Recipe Name: \(returnedRecipe.title ?? "Unknown")")
                
                self.favoriteRecipesList.append(returnedRecipe)
                
            }else{
                print("BAD Response CODE: \(httpURLResponse.statusCode)")
                return
            }
        }catch{
            print("Error processing request \(error.localizedDescription)")
        }
        
    }//getReciopesByID
    
}
