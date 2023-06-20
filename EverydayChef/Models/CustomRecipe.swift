//
//  CustomRecipe.swift
//  EverydayChef
//
//  Created by Ameya Joshi on 2023-06-19.
//

import Foundation
import FirebaseFirestoreSwift

struct CustomRecipe:Codable, Identifiable, Hashable{
    
    @DocumentID var id:String?
    
    var recipeName:String = ""
    
    var recipeInstructions:String = ""
    
    var recipeCuisine:String = ""
    
    var recipeIngredients:String = ""
    
    var dictionary:[String:Any]{
        return ["recipeName" : recipeName,
                "recipeInstructions": recipeInstructions,
                "recipeCuisine": recipeCuisine,
                "recipeIngredients":recipeIngredients
        
        ]
    }
    
}
