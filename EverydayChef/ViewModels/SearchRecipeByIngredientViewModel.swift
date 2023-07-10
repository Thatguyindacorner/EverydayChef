//
//  SearchRecipeByIngredientViewModel.swift
//  EverydayChef
//
//  Created by Alex Olechnowicz on 2023-07-03.
//

import Foundation

class SearchRecipeByIngredientViewModel: ObservableObject{
    
    @Published var results: [FoundRecipesByIngredients] = []
    @Published var allRecipes: [FoundRecipesByIngredients] = []
    var filteredRecipes: [FoundRecipesByIngredients] = []
    
    @Published var recipeData: Recipe? = nil
    @Published var goToRecipe = false
    
    @Published var numResults: Int = 100
    @Published var includeRecipesWithMissingIngredients: Bool = false

    let base = "https://api.spoonacular.com/recipes/findByIngredients"
    let ingredients = "?ingredients="
    let limitPeram = "&ignorePantry=false&number="
    let ranking = "&ranking="
    let apiKey = "&apiKey=9947b019d7f343a3aea18080c939d70e" //&apiKey=d01c0f4e6a324d2c861e9b967a6e5d87"
    
    
    func getRecipeById(id: Int) async -> Recipe?{
        
        let buildURLString:String = "https://api.spoonacular.com/recipes/\(id)/information?apiKey=9947b019d7f343a3aea18080c939d70e" //d01c0f4e6a324d2c861e9b967a6e5d87"
        
        //var returnedRecipe: Recipe? = nil
        
        guard let recipeByIDURL = URL(string: buildURLString) else{
            print("Error converting String to URL")
            return nil
        }
        
        do{
            
            print("Trying to get a response")
            
            let (data,urlResponse) = try await URLSession.shared.data(from: recipeByIDURL)
            
            guard let httpURLResponse = urlResponse as? HTTPURLResponse else{
                
                print("Cannot cast to HTTPURLResponse")
                
                return nil
                
            }//guard httpURLResponse
            
            if httpURLResponse.statusCode == 200{
                
                //TODO: Decode JSON
                guard let returnedRecipe = try? JSONDecoder().decode(Recipe.self, from: data) else{
                    print("ERROR:: Trouble decoding data into Swift Structs")
                    
                    return nil
                }
                
                print("Recipe Data Successfully Returned \(returnedRecipe.id)")
                
                print("Recipe Name: \(returnedRecipe.title ?? "Unknown")")
                
                return returnedRecipe
                //self.favoriteRecipesList.append(returnedRecipe)
                
                
                
            }else{
                print("BAD Response CODE: \(httpURLResponse.statusCode)")
                return nil
            }
        }catch{
            print("Error processing request \(error.localizedDescription)")
            return nil
        }
    
    }//getReciopesByID
    
    func isInStock(result: FoundRecipesByIngredients, ingredientState: Bool, inventory: [AutocompleteIngredient]) -> Bool{

        if !ingredientState{
            return false
        }
        
        var recipeIngredients: [AutocompleteIngredient] = []
        
            for ingredient in result.missedIngredients{
                if inventory.contains(where: { ownedIngredient in
                    if ownedIngredient.id == ingredient.id{
                        recipeIngredients.append(ownedIngredient)
                        
                    }
                    
                    return ownedIngredient.id == ingredient.id
                    
                }){}
            }
            
            for missedIngredent in recipeIngredients {
                if !missedIngredent.inStock {
                    return false
                }
            }
        
            return true
        
        
    }
    
    func filterRecipes(newValue: Bool) async{
        
        if newValue{
            DispatchQueue.main.async {
                self.results = self.allRecipes
            }
        }
        
        else{
            //let inventory = await FireDbController.getInventory()
            DispatchQueue.main.async {
                self.results = self.filteredRecipes
//
//                    if self.filteredRecipes.isEmpty{
//                    //var filteredResults: [FoundRecipesByIngredients] = []
//
//
//                        for result in self.allRecipes {
//
//                            for ingredient in result.missedIngredients{
//                                if inventory.contains(where: { ownedIngredient in
//                                    return ownedIngredient.id == ingredient.id
//                                }){
//
//                                    if result.missedIngredients.last?.id == ingredient.id{
//                                        //filteredResults.append(result)
//                                        self.results.append(result)
//
//                                    }
//                                }
//                                else{
//                                    break
//                                }
//                            }
//                        }
//                    }
                
               // self.results = self.filteredRecipes
            }
            
        }
        
        
        
        
    }
    
    func searchRecipesWith(ingredient: AutocompleteIngredient) async{
        
        guard ingredient.name != nil
        else{
            return
        }
        
        //2 in minimize missing ingredients
        var url = "\(base)\(ingredients)\(ingredient.name!)\(limitPeram)\(numResults)\(ranking)\(2)\(apiKey)"
        
        let api = URL(string: url)
        
        if api == nil{
            url = "\(base)\(ingredients)\(ingredient.name!.replacingOccurrences(of: " ", with: "+"))\(limitPeram)\(numResults)\(ranking)\(2)\(apiKey)"
        }
        
        //print(url)
        
        guard let api = URL(string: url)
        else{
            print("Error converting to a valid URL")
            return
        }
        
        do{
            print("doing")
            let (data, response) = try await URLSession.shared.data(from: api)
            print("past 1")
            guard let httpResponse = response as? HTTPURLResponse
            else{
                //error getting / converting code
                print("could not convert response")
                return
            }
            
            guard httpResponse.statusCode == 200
            else{
                //error code
                print("error code: \(httpResponse.statusCode)")
                return
            }
            
            print("past 2")
        
            //print(data.encode(to: Quote))
            print(response)
            let jsonData = try JSONDecoder().decode(FoundRecipeByIngredientResults.self, from: data)
            print("past 3")
            
            let inventory = await FireDbController.getInventory()
            
            DispatchQueue.main.async {
                
                self.allRecipes = jsonData.results ?? []
                self.filteredRecipes = []
                //self.recipes = []
                
                
                    
                    for result in self.allRecipes {
                        
                        for ingredient in result.missedIngredients{
                            if inventory.contains(where: { ownedIngredient in
                                return ownedIngredient.id == ingredient.id
                            }){
                                if result.missedIngredients.last?.id == ingredient.id{
                                    self.filteredRecipes.append(result)
//                                    Task{
//                                        guard let recipe = await self.getRecipeById(id: result.id!)
//                                        else{
//                                            print("error geting recipe by id")
//                                            //remove result?
//                                            return
//                                        }
//                                        self.recipes.append(recipe)
//                                    }

                                }
                            }
                            else{
                                break
                            }
                        }
                    }
                
                if !self.includeRecipesWithMissingIngredients{
                    self.results = self.filteredRecipes
                }
                else{
                    self.results = self.allRecipes
                }
                
//                for result in self.results {
//                    self.recipes = []
//                    Task{
//                        let recipe = await self.getRecipeById(id: result.id!)
//                        self.recipes.append(recipe ?? Recipe(vegetarian: nil, id: result.id!, instructions: "N/A", extendedIngredients: [], analyzedInstructions: []))
//                    }
//                }
                
            }
            
            print(jsonData.results!)
            print("successfully got results")
        }
        
        catch{
            print("something went wrong")
            return
        }
        
        
    }
    
}
