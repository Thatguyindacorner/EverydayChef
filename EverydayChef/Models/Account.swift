//
//  Account.swift
//  EverydayChef
//
//  Created by Alex Olechnowicz on 2023-06-19.
//

import Foundation
import FirebaseFirestoreSwift

struct Account:Codable, Hashable{
    
    //var myRecipes: [Recipe] = []
    
    //var myInventory: [ExtendedIngredient] = []
    
    var isActivated: Bool = false
    
    var apiKey: String?
    
}
