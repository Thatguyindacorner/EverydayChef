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
    
    var imageURLString:String = ""
    
    var recipeName:String = ""
    
    var recipeInstructions:String = ""
    
    var recipeCuisine:String = ""
    
    var recipeIngredients:String = ""
    
    var serves:Int = 0
    
    var prepTime:Int = 0
    
    var dictionary:[String:Any]{
        return ["imageURLString" : imageURLString,
                "recipeName" : recipeName,
                "recipeInstructions": recipeInstructions,
                "recipeCuisine": recipeCuisine,
                "recipeIngredients":recipeIngredients,
                "serves" : serves,
                "prepTime" : prepTime
                
        ]
    }
    
}
