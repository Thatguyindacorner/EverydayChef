//
//  SignUpView.swift
//  EverydayChef
//
//  Created by Ameya Joshi on 2023-06-19.
//

import SwiftUI
import CryptoKit

enum SignType: Int{
    case signup = 1
    case signin = 2
}

struct SignUpView: View {
    
    @Environment(\.openURL) private var openURL
    @Environment(\.presentationMode) var presentation
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var key: String = ""
    @State var acceptTerms: Bool = false
    
    //var webView: WKWebView!
    
    @State private var userFName:String = ""
    
    @State private var userLName:String = ""
    
    @State var awaitingAppVerification = false
    @State var awaitingSpoonVerification = false
    
    @State var spoonError = false
    @State var spoonVerified = false
    
    @State var isNewAccountSignIn: Bool
    
    @Environment(\.presentationMode) var presentationMode
    
    var authHelper: AuthController = AuthController()
    
    var body: some View {
        ScrollView{
            
            //NavigationLink(destination: AwaitingVerificationView(), isActive: $awaitingSpoonVerification) {}
            NavigationLink(destination: ContentView().environmentObject(SessionData.shared), isActive: $awaitingSpoonVerification) {}
//
//            if awaitingAppVerification {//&& awaitingSpoonVerification{
//                VStack{
//
//                    if spoonVerified{
//                        Label("Spoonacular Account Verified", image: "checkmark.circle")
//                    }
//                    else{
//                        HStack{
//                            Text("Awaiting Verification of Spoonacular Account")
//                            ProgressView().tint(.gray)
//                        }
//                    }
//
//                    if appVerified{
//                        Label("Everyday Chef Account Verified", image: "checkmark.circle")
//                    }
//                    else{
//                        HStack{
//                            Text("Awaiting Verification of Spoonacular Account")
//                            ProgressView().tint(.gray)
//                        }
//                    }
//
//                    Link("Check Mail App", destination: URL(string: "message://")!)
//
//                    HStack{
//                        Button(action:{
//                            //check both
//                            Task{
//                                if await AuthController.signInAfterVerification(email: email){
//                                    print("success")
//                                }
//                                else{
//                                    print("fail")
//                                }
//
//                            }
//                        }){
//                            Text("I have verified both accounts from my email")
//                        }.disabled(appVerified && spoonVerified)
//                        Button(action:{
//                            //goto app
//                        }){
//                            Text("Get Started with Everyday Chef")
//                        }.disabled(!appVerified && !spoonVerified)
//                    }
//
//                }//VStack
//                .padding()
//            }
            
            //else{
                VStack{
                    
                    //Text("Please enter your email to create an account")
                    
                    TextField("Email Address", text: $email)
                        .padding(12)
                        .background(.white)
                        .keyboardType(.emailAddress)
                        .overlay{
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray.opacity(0.2), lineWidth: 1)

                        }.onChange(of: email) { newValue in
                            self.spoonError = false
                        }
                    
                    SecureField("Password", text: $password)
                        .padding(12)
                        .background(.white)
                        .keyboardType(.alphabet)
                        .overlay{
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray.opacity(0.2), lineWidth: 1)

                        }.onChange(of: password) { newValue in
                            self.spoonError = false
                        }
                    
                    Picker("", selection: $isNewAccountSignIn) {
                        Text("Sign Up").tag(true)
                        Text("Log In").tag(false)
                    }.pickerStyle(.segmented)
                    
                    switch isNewAccountSignIn
                    {
                    case true:
                        if spoonError{
                            VStack{
                                SecureField("apiKey", text: $key)
                                    .padding(12)
                                    .background(.white)
                                    .keyboardType(.alphabet)
                                    .overlay{
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(.gray.opacity(0.2), lineWidth: 1)
                                        
                                    }
                                Link("Sign in to Spoonacular and copy apikey", destination: URL(string: "https://spoonacular.com/food-api/console#Profile")!)
                                Button(action: {
                                    Task{
                                        //try a call with the key to see if it is real
                                        if await AuthController.tryApiKey(key: key){
                                            //if true
                                            if await authHelper.signUpWithEmailPassword(email: email, password: password){
                                                do{
                                                    try await SessionData.shared.document?.updateData(["isActivated" : true, "apiKey" : key])
                                                    
                                                    self.awaitingSpoonVerification = true
                                                    
                                                    await authHelper.loadFridge()
                                                }
                                                catch{
                                                    print("couldn't update document")
                                                }
                                            }
                                            else{
                                                print("could not make account")
                                            }
                                        }
                                        
                                        else{
                                            print("not a valid key")
                                            self.key = ""
                                        }
                                        
                                    }
                                }){
                                    Text("Make Account")
                                }.disabled(!acceptTerms)
                            }
                            
                        }
                        
                        Toggle(isOn: $acceptTerms) {
                            Text("I have read and accept the terms and conditions of both Everyday Chef and Spoonacular API")
                        }
                        
                        Button(action: {
                            
                            if SignUpView.textFieldValidatorEmail(for: email){
                                //check to see if email is in use firebase
                                
                                Task{
                                    
                                    if await AuthController.isEmailInAvailable(email: email){
                                        
                                        //continure
                                        let spoonAccountData = await AuthController.spoonacularAccountCall(email: email, type: .register)
                                        
                                        guard spoonAccountData != nil
                                        else{
                                            print("something went wrong")
                                            self.spoonError = true
                                            return
                                        }
                                        
                                        guard spoonAccountData!.status != nil || spoonAccountData!.status != "failure"
                                        else{
                                            print("account not created: probably in use")
                                            return
                                        }
                                        
                                        print("email has been sent and account created")
                                        
                                        
                                        self.awaitingSpoonVerification = await authHelper.signUpWithEmailPassword(email: email, password: password)
                                        
                                        password = ""
                                        
                                        
                                        
                                        
                                        //should return true
                                        //                                    if await AuthController().emailSignUp(email: email){
                                        //                                        print("email sent t0 \(email)")
                                        //
                                        
                                        //
                                        //                                    }
                                        //                                    else{
                                        //                                        print("firebase account could not be made")
                                        //                                    }
                                        
                                    }
                                    else{
                                        print("email is in use")
                                    }
                                    
                                    
                                    
                                }
                                
                                //if in use propt use to choose new email or send email to login under submitted email
                                //else check if email is available in spoonacular by attepting to make account
                                //if fails, propt user to login to spoonacular (we will not be saving passwords) or choose a new email
                                //else accounts are created, and wait for user to click verification links sent to email
                                //then login, save api key, and reset password
                            }
                            
                            else{
                                print("email not valid")
                                email = ""
                            }
                            
                            
                        }){
                            Text("Create Account")
                        }.disabled(!acceptTerms || spoonError || email == "" || password.count < 6)
                        
                        //Spacer()
                        
                        Text("Terms and Conditions\n\nBy creating an account with Everyday Chef you are giving Everyday Chef premission to act on your behave to create your Spoonacular account. You also are giving Everyday Chef presmission to use your personally generated API key to preform all the operations provided to you in the Everyday Chef app. *We will not use the password you provide to us for your Spoonacular Account.\n\nEveryday Chef is not endorsed by Spoonacular API.").font(.footnote)
                        
                        Link("Spoonacular API Terms", destination: URL(string: "https://spoonacular.com/food-api/terms")!)
                    
                    case false:
                        Button(action:{
                            if SignUpView.textFieldValidatorEmail(for: email){
                                Task{
                                    if await authHelper.signInWithEmailPassword(email: email, password: password){
                                        print("welcome \(authHelper.authentication.currentUser?.email)")
                                        password = ""
                                        self.awaitingSpoonVerification = true
                                    }
                                    else{
                                        print("credentials do not match")
                                        password = ""
                                    }
                                }
                                
                            }
                            else{
                                print("email not valid")
                            }
                        }){
                            Text("Sign In")
                        }.disabled(email == "" || password.count < 6)
                        
                    }
                
                    
                }//VStack
                .padding()
      
            
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
        }//ScrollView
        .onAppear{
            if email != ""{
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }//body
    
    //Function to validate Email Address
    static func textFieldValidatorEmail(for emailAdd: String) -> Bool {
        if emailAdd.count > 100 {
            return false
        }
        let emailRegex = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
    
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        
        return emailPredicate.evaluate(with: emailAdd)
    }//textFieldValidatorEmail
    
}

//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//    }
//}
