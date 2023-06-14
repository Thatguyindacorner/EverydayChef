//
//  AuthController.swift
//  EverydayChef
//
//  Created by Alex Olechnowicz on 2023-06-12.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct AuthController{
    
    let authentication = Auth.auth()
    
    var user: User? {
        get{
            return authentication.currentUser
        }
    }
    
    init(){
        //auto signin
        if user != nil{
            SessionData.shared.loggedInUser = user
        }
    }
    
    func signOut() async{
        
    }
    
    func anonymousAuth() async -> Bool{
        do{
            try await authentication.signInAnonymously()
            print("signed in anonoumously")
            DispatchQueue.main.sync {
                SessionData.shared.loggedInUser = user
            }
            return true
        }
        catch{
            print("error signing in anonoumously")
            return false
        }
        
    }
    
    func convertToPermanentAccount() async{
        
    }
}
