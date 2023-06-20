//
//  FireDBController.swift
//  EverydayChef
//
//  Created by Ameya Joshi on 2023-06-19.
//

import Foundation
import FirebaseFirestore

class FireDbController:ObservableObject{
    
    private let store = Firestore.firestore()
    
    
    static let sharedFireDBController = FireDbController()
    
    private init(){}
    
    
    func insertUser(newUserData:UserData) async throws{
        
        try await store.collection(MyConstants.COLLECTION_USERS).document(newUserData.uid).setData(newUserData.dictionary)
        
        
    }//insertNewUser
    
    
    
}
