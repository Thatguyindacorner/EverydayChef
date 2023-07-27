//
//  WineAndFoodViewModel.swift
//  CatchEmAllApp
//
//  Created by Ameya Joshi on 2023-06-29.
//

import Foundation

@MainActor
class WineAndFoodViewModel:ObservableObject{
    
    let apiKey:String = "d01c0f4e6a324d2c861e9b967a6e5d87"
    
    //Wine
    let findWineURL:String = "https://api.spoonacular.com/food/wine/pairing?apiKey="
    
    @Published var winesList:[String] = []
    
    @Published var wineProducts:[WineProduct] = []
    
    @Published var wineInfo:String = ""
    
    @Published var winePairingText:String = ""
    
    
    //FOOD
    let findFoodURL:String = "https://api.spoonacular.com/food/wine/dishes?apiKey="
    @Published var foodList:[String] = []
    
    @Published var foodText:String = ""
    
    
    
    func findWine(for foodName:String) async ->Bool{
        
        guard let searchURL:URL = URL(string: "\(findWineURL)\(apiKey)&food=\(foodName)") else{
            print("Cannot convert String to URL")
            return false
        }
        do{
            let (data,urlResponse) = try await URLSession.shared.data(from: searchURL)
            
            guard let httpURLResponse = urlResponse as? HTTPURLResponse else{
                print("Cannot convert response to HttpURLResponse")
                return false
            }
            
            guard httpURLResponse.statusCode == 200 else{
                print("BAD Status Code: \(httpURLResponse.statusCode)")
                
                return false
            }
            
            let returned = try JSONDecoder().decode(ReturnedPairedWines.self, from: data)
            
            print(returned.pairingText ?? "Unknown")
            
            self.winePairingText = returned.pairingText ?? "No Wine Innformation found for a wine that would go with this dish"
            
            self.winesList = returned.pairedWines
            
            self.wineProducts = returned.productMatches
            
            self.wineInfo = returned.pairingText ?? "No Information Found"
            
            if returned.productMatches.count > 0{
                print(returned.productMatches[0].imageUrl ?? "Unknown")
            }
            
            return true
        } catch{
            print("Error Processing Request")
            return false
        }//catch
    }//func foodWine()
    
    
    func findFood(for wineName:String) async ->Bool{
        
        //let searchWineStr = processString(process: wineName)
        
       // print(searchWineStr)
        
        var wineTerm = wineName.replacingOccurrences(of: " ", with: "_")
    
        print(wineTerm)
        
        do{
            
            guard let searchURL = URL(string: "\(findFoodURL)\(apiKey)&wine=\(wineTerm)") else{
                print("Error creating URL from String")
                
                return false
                
            }
            
            let (data, urlResponse) = try await URLSession.shared.data(from: searchURL)
            
            
            guard let httpURLResponse = urlResponse as? HTTPURLResponse else{
                print("Cannot cast to HttpURLResponse")
                return false
            }
            
            guard httpURLResponse.statusCode == 200 else{
                print("BAD Status code: \(httpURLResponse.statusCode)")
                
                return false
            }
            
            guard let returned = try? JSONDecoder().decode(ReturnedFood.self, from: data) else{
                print("Error Decoding into Swift Structs")
                return false
            }
            
            print(returned)
            
            print(returned.text ?? "Unknown")
            
            self.foodList = returned.pairings ?? []
            
            self.foodText = returned.text ?? "No Food Found for this type of Wine. Please make sure your search is correct"
            
            return true
        }catch{
            print("Error finding a dish \(error.localizedDescription)")
            return false
        }//catch
        
    }//func findFood
}
