//
//  SessionData.swift
//  EverydayChef
//
//  Created by Alex Olechnowicz on 2023-06-12.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class SessionData: ObservableObject{
    
    static var shared = SessionData()
    
    var document: DocumentReference? {
        get{
            if loggedInUser != nil {
                return Firestore.firestore().collection("users").document(loggedInUser!.uid)
            }
            else{
                return nil
            }
        }
    }
    
    @Published var loggedInUser: User? = nil
    @Published var tempararyAccount: Bool = true
    @Published var userAccount: Account? = nil
    
    
}
