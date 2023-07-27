//
//  IngredientSearchViewModel.swift
//  EverydayChef
//
//  Created by Alex Olechnowicz on 2023-06-21.
//

import Foundation

class IngredientSearchViewModel: ObservableObject{
    
    @Published var query: String = ""
    @Published var results: [AutocompleteIngredient] = []
    
    let base = "https://api.spoonacular.com/food/ingredients/autocomplete?query="
    let params = "&metaInformation=true"
    let apiKey = "&apiKey=9947b019d7f343a3aea18080c939d70e" //&apiKey=d01c0f4e6a324d2c861e9b967a6e5d87"
    
    func searchFor() async{
        guard query != ""
        else{
            return
        }
        
        let url = "\(base)\(query)\(params)\(apiKey)"
        
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
            let jsonData = try JSONDecoder().decode(AutocompleteResults.self, from: data)
            print("past 3")
            
            DispatchQueue.main.async {
                self.results = jsonData.results ?? []
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
