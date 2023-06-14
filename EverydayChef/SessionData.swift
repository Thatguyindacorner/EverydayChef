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
    
    @Published var loggedInUser: User? = nil
    @Published var tempararyAccount: Bool = true
}
