//
//  AwaitingVerificationView.swift
//  EverydayChef
//
//  Created by Alex Olechnowicz on 2023-08-02.
//

import SwiftUI

struct AwaitingVerificationView: View {
    
    @State var spoonVerified = false
    
    var body: some View {
        ScrollView{
            VStack{
                
                if spoonVerified{
                    Label("Spoonacular Account Verified", image: "checkmark.circle")
                }
                else{
                    HStack{
                        Text("Awaiting Verification of Spoonacular Account")
                        ProgressView().tint(.gray)
                    }
                }
                
                Link("Check Mail App", destination: URL(string: "message://")!)
                
                HStack{
                    Button(action:{
                        //check both
                        Task{
                            let spoonAccount = await AuthController.spoonacularAccountCall(email: SessionData.shared.loggedInUser!.email!, type: .login)
                            
                            guard spoonAccount != nil
                            else{
                                print("error with spoon login")
                                return
                            }
                            
                            if spoonAccount!.activated == 1
                            {
                                print("account is activated")
                                //reset password & update db & store apiKey
                                
                                do{
                                    try await SessionData.shared.document?.updateData(["isActivated" : true, "apiKey" : spoonAccount!.apiKey!])
                                }
                                catch{
                                    print("couldn't update document")
                                }
                                
                                
                                if await AuthController.resetSpoonPassword(email: SessionData.shared.loggedInUser!.email!){
                                    DispatchQueue.main.async {
                                        self.spoonVerified = true
                                    }
                                }
                                else{
                                    print("could not reset password")
                                }
                                
                                
                            }
                            else{
                                print("fail")
                            }
                            
                        }
                    }){
                        Text("I have verified my account")
                    }.disabled(spoonVerified)
                    NavigationLink {
                        ContentView().environmentObject(SessionData.shared)
                    } label: {
                        Text("Get Started with Everyday Chef")
                    }.disabled(!spoonVerified)

                    
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
}

struct AwaitingVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        AwaitingVerificationView()
    }
}
