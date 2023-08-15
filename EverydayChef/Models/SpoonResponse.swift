//
//  SpoonResponse.swift
//  EverydayChef
//
//  Created by Alex Olechnowicz on 2023-08-02.
//

import Foundation

struct SpoonResponse: Codable{
    
    var status: String?
    var apiKey: String?
    var activated: Int?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SpoonKeys.self)
        
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        
        let user = try container.nestedContainer(keyedBy: SpoonKeys.UserKeys.self, forKey: .user)
        
        self.apiKey = try user.decodeIfPresent(String.self, forKey: .apiKey)
        self.activated = try user.decodeIfPresent(Int.self, forKey: .activated)
    }
    
    enum SpoonKeys: CodingKey{
        case status
        case user
        
        enum UserKeys: CodingKey{
            case apiKey
            case activated
        }
    }
    
}
