//
//  Step.swift
//  CatchEmAllApp
//
//  Created by Ameya Joshi on 2023-06-13.
//

import Foundation

struct Step:Codable, Hashable{

    var number:Int?
    
    var step:String?
    
    var ingredients:[Ingredient]
    
    var equipment:[Equipment]
}
