//
//  UserData.swift
//  EverydayChef
//
//  Created by Ameya Joshi on 2023-06-19.
//

import Foundation
import FirebaseFirestoreSwift

struct UserData:Codable{
   
    var uid:String = ""
    
    var profilePic:String = ""
    
    var firstName:String = ""
    
    var lastName:String = ""
    
    var email:String = ""
    
    var dictionary:[String : Any]{
        return ["uid" : uid,
                "profilePic" : profilePic,
                "firstName" : firstName,
                "lastName" : lastName,
                "email": email]
    }
    
}
