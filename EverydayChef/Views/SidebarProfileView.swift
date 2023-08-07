//
//  SidebarProfileView.swift
//  EverydayChef
//
//  Created by Alex Olechnowicz on 2023-05-31.
//

import SwiftUI


struct SidebarProfileView: View {
    
    let sidebarWidth = UIScreen.main.bounds.size.width * 0.6
    let contentHight = UIScreen.main.bounds.size.height * 0.5
    
    @Binding var isSidebarVisable: Bool
    @Binding var sidebarHidden: Bool
    
    @State var deleteAccountConfirmation: Bool = false
    @Binding var upgrade: Bool
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var key: String = ""
    @State var acceptTerms: Bool = false
    @State var spoonError: Bool = false
    
    @EnvironmentObject var session: SessionData
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
            ZStack{
                GeometryReader{ _ in
                    //NavigationLink(destination: SignUpView().environmentObject(session), isActive: $upgrade){}
                }
                .background(.black.opacity(0.3))
                .opacity(isSidebarVisable ? 1 : 0)
                .animation(.easeInOut, value: isSidebarVisable)
                .onTapGesture {
                    closeSidebar()
                }
                
                HStack(alignment: .top, spacing: 0){
                    ZStack(alignment: .top){
                        GeometryReader{ space in
                            
                            VStack(alignment: .center, spacing: 25){
                                VStack{
                                    Text("\(session.loggedInUser?.email ?? "Temperary Account")").font(.title2).foregroundColor(Color.black)
                                    //Text("Logged@In.Email").font(.subheadline).foregroundColor(Color.white)
                                }.padding(.bottom, 25).padding(.top, 25)
                                
                                //Spacer()
                                
                                if session.loggedInUser?.isAnonymous ?? false{
                                    Toggle("Migrate to Full Account", isOn: $upgrade)
                                }
                                
                                
                                
                                
                                
                                Button(action:{
                                    
                                }){
                                    Text("Settings")
                                }
                                .foregroundColor(Color.black)
                                .padding(10)
                                .border(.black)
                                .cornerRadius(2)
                                
                                //if anonoumous account, signout and delete account (delete on backend)
                                //else, signout
                                Button(action:{
                                    
                                    if session.loggedInUser?.isAnonymous ?? false{
                                        
                                        //trigger alert to confirm action
                                        self.deleteAccountConfirmation = true
                                    }
                                    else{
                                        signout()
                                    }
                                    
                                }){
                                    if session.loggedInUser?.isAnonymous ?? false{
                                        Text("Delete Account")
                                        //trigger alert to confirm action
                                    }
                                    else{
                                        Text("Logout")
                                    }
                                }
                                .foregroundColor(Color.black)
                                .padding(10)
                                .border(.black)
                                .cornerRadius(2)
                                
                                
                                if upgrade{
                                    ScrollView{
                                        VStack{
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
                                                    Link("Sign in to Spoonacular and copy apikey", destination: URL(string: "https://spoonacular.com/food-api/console#Profile")!).foregroundColor(.white)
                                                    Button(action: {
                                                        Task{
                                                            //try a call with the key to see if it is real
                                                            if await AuthController.tryApiKey(key: key){
                                                                //if true
                                                                if await AuthController.convertToPermanentAccount(email: email, password: password){
                                                                    do{
                                                                        try await SessionData.shared.document?.updateData(["isActivated" : true, "apiKey" : key])
                                                                        
                                                                        //self.awaitingSpoonVerification = true
                                                                        print("account migrated")
                                                                        self.upgrade = false
                                                                        closeSidebar()
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
                                                            .foregroundColor(.white)
                                                            .padding(10)
                                                            .border(.white)
                                                            .cornerRadius(2)
                                                    }.disabled(!acceptTerms)
                                                }
                                                
                                            }
                                            
                                            Toggle(isOn: $acceptTerms) {
                                                Text("I have read and accept the terms and conditions of both Everyday Chef and Spoonacular API").font(.footnote)
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
                                                            
                                                            if await AuthController.convertToPermanentAccount(email: email, password: password){
                                                                print("account migrated")
                                                                self.upgrade = false
                                                                closeSidebar()
                                                            }
                                                            
                                                            
                                                            
                                                            
                                                            
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
                                                    .foregroundColor(.white)
                                                    .padding(10)
                                                    .border(.white)
                                                    .cornerRadius(2)
                                            }.disabled(!acceptTerms || spoonError)
                                            
                                            VStack(alignment: .center, spacing: 10){
                                                
                                                
                                                Text("Terms and Conditions\n\nBy creating an account with Everyday Chef you are giving Everyday Chef premission to act on your behave to create your Spoonacular account. You also are giving Everyday Chef presmission to use your personally generated API key to preform all the operations provided to you in the Everyday Chef app. *We will not use the password you provide to us for your Spoonacular Account.\n\nEveryday Chef is not endorsed by Spoonacular API.").font(.footnote)
                                                
                                                
                                                
                                                
                                                Link("Spoonacular API Terms", destination: URL(string: "https://spoonacular.com/food-api/terms")!).font(.footnote).foregroundColor(.white)
                                            }
                                            
                                            
                                            
                                        }
                                    }//.frame(height: space.size.height/1.75)
                                    
                                }
                                
                                Spacer()
                            }.padding(25).frame(width: sidebarWidth, height: space.size.height)
                                //.border(.black)
                                //.padding(.leading, 15)
                           
                        }
                    }
                    .background(.cyan)
                    .opacity(isSidebarVisable ? 1 : 0)
                    .frame(width: sidebarWidth)
                    .offset(x: isSidebarVisable ? 0 : -sidebarWidth)
                    .animation(.default, value: isSidebarVisable)
                    //.edgesIgnoringSafeArea(.all)
                    
                    Spacer()
                }
               
            }//.edgesIgnoringSafeArea(.all)
            .alert(isPresented: $deleteAccountConfirmation){
                Alert(title: Text("Confirmation Required"),
                      message: Text("Are you sure you want to delete your temporary account?"),
                      primaryButton: .cancel(
                        Text("Cancel"),
                        action: {
                            print("canceled signout")
                        }),
                      secondaryButton: .destructive(
                        Text("Yes"),
                        action: {
                            session.document!.delete()
                            signout()
                        })
                      )
            }
        
        
        
        
    }
    
    func closeSidebar(){
        isSidebarVisable.toggle()
        //delay for toolbar to reappear
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(0.3)){
            self.sidebarHidden = false
        }
    }
    
    func signout(){
        Task{
            if await AuthController.signOut(){
                self.presentationMode.wrappedValue.dismiss()
            }
            else{
                print("error signing out")
            }
        }
    }
    
    
}

//struct SidebarProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        SidebarProfileView()
//    }
//}
