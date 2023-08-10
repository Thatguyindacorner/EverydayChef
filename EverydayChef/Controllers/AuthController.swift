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

import CryptoKit

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
    
    static func storeAccount() async -> Bool{
        do{
            let account = try await SessionData.shared.document!.getDocument(as: Account.self)
            
            DispatchQueue.main.sync {
                SessionData.shared.userAccount = account
            }
            print("got account details")
            return true
        }
        
        
        catch{
            print("problem getting acocunt")
            return false
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
    
    func loadFridge() async{
        let reference = Firestore.firestore().collection("users").document(user!.uid)
        let standardInventory = "GZfKUDF5KWf4K9VHs0V95icyFUy1"
        
        do{
            let preset = try await Firestore.firestore().collection("users").document(standardInventory).collection("Ingredients").getDocuments().documents
            for document in preset{
                try await reference.collection("Ingredients").addDocument(data: document.data())
            }
            print("added all ingredients from temp")
        }
        catch{
            print("something went wrong copying base ingredients")
        }

    }
    
    static func isActivated() async -> Bool{
        do{
            let data = try await SessionData.shared.document!.getDocument().data()
            print(data)
            return data?["isActivated"] as? Bool ?? false
            
        }
        catch{
            print("could not convert data")
            return false
        }
    }
    
    static func signInAfterVerification(email: String) async -> Bool {

        //let link = "https://everydaychef.page.link/email-verification"
        let link = "https://everyday-chef.firebaseapp.com"
        
        if Auth.auth().isSignIn(withEmailLink: link) {
            print("isSignIn true")
            do{
                try await Auth.auth().signIn(withEmail: email, link: link)
                print("success")
                
                
                return true
            }
            catch{
                print("error with signin")
                return false
            }

        }
        else{
            print("isSignIn false")
            return false
        }

        
    }
    
    static func isEmailInAvailable(email: String) async -> Bool {
        do{
            return try await Auth.auth().fetchSignInMethods(forEmail: email).isEmpty
        }
        
        catch{
            print("error something went wrong")
            return false
        }
       
    }
    
    func signUpWithEmailPassword(email: String, password: String) async -> Bool {
        
        do{
            try await authentication.createUser(withEmail: email, password: password)
            
            makeAccountDB()
            
            //await loadFridge()
            
            print("signed up with email and password")
            DispatchQueue.main.sync {
                SessionData.shared.loggedInUser = user
                SessionData.shared.tempararyAccount = false
            }
            return true
        }
        catch{
            print("something went wrong")
            print(error.localizedDescription)
            return false
        }
        
    }
    
    func signInWithEmailPassword(email: String, password: String) async -> Bool {
        do{
            try await authentication.signIn(withEmail: email, password: password)
            
            print("signed in with email and password")
            
            
            
            DispatchQueue.main.sync {
                SessionData.shared.loggedInUser = user
                SessionData.shared.tempararyAccount = false
            
            }
            
            await AuthController.storeAccount()
            
            return true
        }
        catch{
            print("something went wrong")
            return false
        }
    }
    
    func emailSignUp(email: String) async -> Bool{
        
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url =
        //URL(string: "https://everyday-chef.firebaseapp.com")
        URL(string: "https://everydaychef.page.link/email-verification")
        
        //actionCodeSettings.url = URL(string: "https://everydaychef.page.link")
        // The sign-in operation has to always be completed in the app.
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)

        
        do{
            try await authentication.sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings)
            
            // The link was successfully sent. Inform the user.
                // Save the email locally so you don't need to ask the user for it again
                // if they open the link on the same device.
                UserDefaults.standard.set(email, forKey: "Email")
                print("Check your email for link")
            return true

        }
        catch{
            print("something went wrong")
            print(error.localizedDescription)
            //self.showMessagePrompt(error.localizedDescription)
            return false

        }
    }
    
    func anonymousAuth() async -> Bool{
        do{
            try await authentication.signInAnonymously()
            
            makeAccountDB()
            //await loadFridge()
            
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
    
    static func convertToPermanentAccount(email: String, password: String) async -> Bool{
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)

        do{
            try await SessionData.shared.loggedInUser!.link(with: credential)
            print("account now permanent")
            
//            DispatchQueue.main.sync {
//                let _ = AuthController()
//            }
    
            return true
        }
        
        catch{
            print(error.localizedDescription)
            return false
        }
    }
    
    enum SpoonAccountCallType: String{
        case register = "register"
        case login = "login"
    }
    
    static func resetSpoonPassword(email: String) async -> Bool{
        
        let base = "https://spoonacular.com/api/resetPassword?email="
        
        let uriEncoded = email.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        print(uriEncoded)
        
        let url = "\(base)\(uriEncoded ?? email)"
        
        print(url)
        
        guard let api = URL(string: url)
        else{
            print("Error converting to a valid URL")
            return false
        }
        
        do{
            print("doing")
            let (data, response) = try await URLSession.shared.data(from: api)
            print("past 1")
            guard let httpResponse = response as? HTTPURLResponse
            else{
                //error getting / converting code
                print("could not convert response")
                return false
            }
            
            guard httpResponse.statusCode == 200
            else{
                //error code
                print("error code: \(httpResponse.statusCode)")
                return false
            }
            
            print("past 2")
           
            //print(data.encode(to: Quote))
            print(response)
            print("reset password")
            
            return true
//            let jsonData = try JSONDecoder().decode(SpoonResponse.self, from: data)
//            print("past 3")
//
//            guard jsonData.status != nil
//            else{
//                print("error: status is nil")
//                return false
//            }
//
//            if jsonData.status == "success"{
//                print("created account and email sent")
//                return true
//            }
//            else{
//                print("account already exists")
//                return false
//            }
            
        }
        catch{
            print("something went wrong")
            return false
        }
        
    }
    
    static func spoonacularAccountCall(email: String, type: SpoonAccountCallType) async -> SpoonResponse?{
        
        let base = "https://spoonacular.com/api/"
        //email=101427239%40georgebrown.ca&password=123456
        
        let uriEncoded = email.lowercased().addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        print(uriEncoded)
        
        
        print(CryptoKit.SHA256.hash(data: uriEncoded!.data(using: .utf8)!).description)
        print(CryptoKit.SHA256.hash(data: uriEncoded!.data(using: .utf8)!).description.replacingOccurrences(of: "SHA256 digest: ", with: ""))
        
        let pw = CryptoKit.SHA256.hash(data: uriEncoded!.data(using: .utf8)!).description.replacingOccurrences(of: "SHA256 digest: ", with: "")
        
        let url = "\(base)\(type.rawValue)?email=\(uriEncoded!)&password=\(pw)"
        
        print(url)
        
        guard let api = URL(string: url)
        else{
            print("Error converting to a valid URL")
            return nil
        }
        
        do{
            print("doing")
            let (data, response) = try await URLSession.shared.data(from: api)
            print("past 1")
            guard let httpResponse = response as? HTTPURLResponse
            else{
                //error getting / converting code
                print("could not convert response")
                return nil
            }
            
            guard httpResponse.statusCode == 200
            else{
                //error code
                print("error code: \(httpResponse.statusCode)")
                return nil
            }
            
            print("past 2")
        
            //print(data.encode(to: Quote))
            print(response)
            let jsonData = try JSONDecoder().decode(SpoonResponse.self, from: data)
            print("past 3")
            
            guard jsonData.status != nil
            else{
                print("error: status is nil")
                return nil
            }
            
            if jsonData.status == "success"{
                print("created account and email sent")
                return jsonData
            }
            else{
                print("account already exists")
                return jsonData
            }
            
        }
        catch{
            print("something went wrong")
            return nil
        }
        
    }
    
    static func tryApiKey(key: String) async -> Bool{
        
        let base = "https://api.spoonacular.com/food/ingredients/autocomplete?query=apple&number=1&apiKey="
        
        let url = "\(base)\(key)"
        
        guard let api = URL(string: url)
        else{
            print("Error converting to a valid URL")
            return false
        }
        
        do{
            print("doing")
            let (_, response) = try await URLSession.shared.data(from: api)
            print("past 1")
            guard let httpResponse = response as? HTTPURLResponse
            else{
                //error getting / converting code
                print("could not convert response")
                return false
            }
            
            guard httpResponse.statusCode == 200
            else{
                //error code
                print("error code: \(httpResponse.statusCode)")
                return false
            }
            
            print("vaild key")
            
            return true
            
        }
        catch{
            print(error.localizedDescription)
            return false
        }
        
    }
    
}
