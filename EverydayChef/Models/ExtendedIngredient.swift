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
    
    var original:String?
    
    var name:String?
    
    var amount:Double?
    
    var unit:String?
}

//struct InventoryIngredient: Codable, Hashable{
//    var id: Int?
//
//    var name: String?
//
//    var image: String?
//
//    var aisle: String?
//
//    var isStock: tr
//}

struct AutocompleteResults: Codable{
    
    var results: [AutocompleteIngredient]?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        var list = try container.decode([AutocompleteIngredient].self)

        var counter = 0
        for item in list{
            if item.aisle == nil{
                list.remove(at: counter)
                counter -= 1
            }
            counter += 1
        }
        self.results = list
        print("past results")
    }
}

struct AutocompleteIngredient: Codable{
    var id: Int?
    
    var name: String?
    
    var image: String?
    
    var aisle: String?
    
    var inStock: Bool
    
    var inFreezer: Bool
    
    //init(){}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
        self.aisle = try container.decodeIfPresent(String.self, forKey: .aisle)
    
        self.inStock = true
        self.inFreezer = false
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.id, forKey: .id)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.image, forKey: .image)
        try container.encodeIfPresent(self.aisle, forKey: .aisle)
        try container.encodeIfPresent(self.inStock, forKey: .inStock)
        try container.encodeIfPresent(self.inFreezer, forKey: .inFreezer)
    }
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case image
        case aisle
        
        case inStock
        case inFreezer
    }
}
