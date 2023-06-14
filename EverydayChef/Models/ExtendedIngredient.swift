//
//  ExtendedIngredient.swift
//  CatchEmAllApp
//
//  Created by Ameya Joshi on 2023-06-13.
//

import Foundation

struct ExtendedIngredient:Codable, Hashable{
    
    var aisle:String?
    
    var image:String?
    
    var name:String?
    
    var amount:Double?
    
    var unit:String?
}
