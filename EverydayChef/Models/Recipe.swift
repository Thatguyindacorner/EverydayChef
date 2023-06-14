//
//  Recipe.swift
//  CatchEmAllApp
//
//  Created by Ameya Joshi on 2023-06-13.
//

import Foundation

struct Recipe:Codable, Hashable{
    
    var vegetarian:Bool?
    
    var aggregateLikes:Int?
    
    var pricePerServing:Double?
    
    var id:Int
    
    var title:String?
    
    var readyInMinutes:Int?
    
    var servings:Int?
    
    var image:String?
    
    var summary:String?
    
    var instructions:String
    
    var extendedIngredients:[ExtendedIngredient]
    
    var analyzedInstructions:[AnalyzedInstruction]
}
