//
//  AuthController.swift
//  EverydayChef
//
//  Created by Alex Olechnowicz on 2023-06-12.
//

import Foundation

struct AuthController{
    
    var uid: String? {
        get{
            UserDefaults.standard.string(forKey: "uid")
        }
    }
    
    init(){
        //auto signin
        if uid != nil{
            
        }
    }
    
    func anonymousAuth(){
        
    }
}
