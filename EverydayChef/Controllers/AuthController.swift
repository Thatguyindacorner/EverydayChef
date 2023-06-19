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

import FirebaseFirestoreSwift

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
            
            let reference = Firestore.firestore().collection("users").document(user!.uid)

            Task{
                do{
                    let account = try await reference.getDocument(as: Account.self)
                    
                    DispatchQueue.main.sync {
                        SessionData.shared.userAccount = account
                    }
                    print("got account details")
                }
                
                
                catch{
                    
                    print("error with account, sign in again")
                    if await !AuthController.signOut(){
                        DispatchQueue.main.sync {
                            SessionData.shared.loggedInUser = nil
                        }
                    }
                }
            }
            
        }
    }
    
    static func signOut() async -> Bool{
        do{
            try Auth.auth().signOut()
            print("signed out succesfully")
            DispatchQueue.main.sync {
                SessionData.shared.loggedInUser = nil
            }
            return true
        }
        catch{
            print("error signing out")
            return false
        }
    }
    
    private func makeAccountDB(){
        //make the empty db account with usermodel
        
        let reference = Firestore.firestore().collection("users").document(user!.uid)
        do{
            try reference.setData(from: Account())
            print("account instance made")
        }
        catch{
            print("could not convert data")
        }
    }
    
    func anonymousAuth() async -> Bool{
        do{
            try await authentication.signInAnonymously()
            
            makeAccountDB()
            
            print("signed in anonoumously")
            DispatchQueue.main.sync {
                SessionData.shared.loggedInUser = user
                SessionData.shared.tempararyAccount = true
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
