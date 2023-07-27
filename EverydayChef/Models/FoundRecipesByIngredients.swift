//
//  FoundRecipesByIngredients.swift
//  EverydayChef
//
//  Created by Alex Olechnowicz on 2023-07-04.
//

import Foundation

struct FoundRecipeByIngredientResults: Codable{
    
    var results: [FoundRecipesByIngredients]?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let list = try container.decode([FoundRecipesByIngredients].self)

//        var counter = 0
//        for item in list{
//            if item.aisle == nil{
//                list.remove(at: counter)
//                counter -= 1
//            }
//            counter += 1
//        }
        self.results = list
        print("past results")
    }
}

struct FoundRecipesByIngredients: Codable{
    
    var id: Int?
    
    var name: String?
    
    var title: String?
    
    var image: String?
    
    var missedIngredients: [AutocompleteIngredient]
    var usedIngredients: [AutocompleteIngredient]
    var unusedIngredients: [AutocompleteIngredient]
    
//    enum CodingKeys: CodingKey {
//        case id
//        case name
//        case title
//        case image
//        case missedIngredients
//        case usedIngredients
//    }
    
    
}


