//
//  WineProduct.swift
//  CatchEmAllApp
//
//  Created by Ameya Joshi on 2023-06-29.
//

import Foundation

struct WineProduct:Hashable, Codable{
    
    var id:Int?
    
    var title:String?
    
    var averageRating:Double?
    
    var description:String?
    
    var imageUrl:String?
    
    var link:String?
    
    var price:String?
    
    var score:Double?
    
}
