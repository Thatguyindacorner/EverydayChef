//
//  FavoriteRecipes.swift
//  EverydayChef
//
//  Created by Ameya Joshi on 2023-06-28.
//

import Foundation
import FirebaseFirestoreSwift

struct FavoriteRecipes:Codable, Identifiable, Hashable{
    
    var id:String?
    
    var recipeId:Int = 0
    
    var dictionary:[String : Any]{
        return ["recipeId" : recipeId]
    }
    
}
