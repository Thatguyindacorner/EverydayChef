//
//  IngredientSearchViewModel.swift
//  EverydayChef
//
//  Created by Alex Olechnowicz on 2023-06-21.
//

import Foundation

struct WineDescription: Codable{
    var wineDescription:String?
}

enum WineType{
    case red
    case white
    case not
}

class IngredientSearchViewModel: ObservableObject{
    
    @Published var query: String = ""
    @Published var results: [AutocompleteIngredient] = []
    
    @Published var description: String? = nil
    
    let base = "https://api.spoonacular.com/food/ingredients/autocomplete?query="
    let params = "&metaInformation=true"
    let apiKey = "&apiKey=\(SessionData.shared.userAccount?.apiKey ?? MyConstants.spoonacularAPIKey)" //&apiKey=d01c0f4e6a324d2c861e9b967a6e5d87"
    
    func searchFor() async{
        guard query != ""
        else{
            return
        }
        
        let url = "\(base)\(query.replacingOccurrences(of: " ", with: "+").lowercased())\(params)\(apiKey)"
        
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
    
    static func isWine(drinkName: String) async -> WineType{
        
        let endpoint = "https://api.spoonacular.com/food/wine/description?wine="
        let apiKey = "&apiKey=\(SessionData.shared.userAccount?.apiKey ?? MyConstants.spoonacularAPIKey)"
        
        let url = "\(endpoint)\(drinkName.replacingOccurrences(of: " ", with: "+").lowercased())\(apiKey)"
        
        print(url)
        
        guard let api = URL(string: url)
        else{
            print("Error converting to a valid URL")
            return .not
        }
        
        do{
            print("doing")
            let (data, response) = try await URLSession.shared.data(from: api)
            print("past 1")
            guard let httpResponse = response as? HTTPURLResponse
            else{
                //error getting / converting code
                print("could not convert response")
                return .not
            }
            
            guard httpResponse.statusCode == 200
            else{
                //error code
                print("error code: \(httpResponse.statusCode)")
                return .not
            }
            
            print("past 2")
        
            //print(data.encode(to: Quote))
            print(response)
            let jsonData = try JSONDecoder().decode(WineDescription.self, from: data)
            print("past 3")
            
            print(jsonData.wineDescription?.lowercased() ?? "No description")
            
            if jsonData.wineDescription == nil{
                print("not wine")
                return .not
            }
            else{
                if jsonData.wineDescription!.contains("red wine"){
                    print("red wine")
                    return.red
                }
                else{
                    print("other wine")
                    return .white
                }
            }
            
        }
        
        catch{
            print("something went wrong")
            return .not
        }
    }
    
}
