//
//  StartView.swift
//  EverydayChef
//
//  Created by Alex Olechnowicz on 2023-06-09.
//

import SwiftUI

struct StartView: View {
    
    let widthScreen = UIScreen.main.bounds.size.width - 25
    let heightScreen = UIScreen.main.bounds.size.height
    
    @State var authenticated: Bool
    @State var needsAuthentication: Bool = false
    
    let authHelper: AuthController = AuthController()
    
    @EnvironmentObject var session: SessionData
    
    var body: some View {
        
//        let _ = Binding<Bool> {
//            return self.authenticated
//        } set: {
//            self.authenticated = $0
//        }

            
NavigationView{
            
            if !authenticated{
                VStack{
                    
                    HStack{
                        Image("HomeImage").resizable()
                    }.frame(width: widthScreen, height: heightScreen / 3.5)
                        .border(.black)
                    HStack(alignment: .bottom, spacing: 1){
                        Text("Everyday Chef").font(.largeTitle).bold()
                        Text("©").bold()
                    }.frame(width: widthScreen, height: heightScreen / 8)
                        .border(.black)
                    HStack{
                        Button(action:{
                            Task{
                                
                                if await authHelper.anonymousAuth(){
                                    self.authenticated = true
                            
                                }
                                else{
                                    //error
                                }
                            }
                            
                        }){
                            Text("Get Started")
                                .font(.title)
                                .bold()
                                .padding(10)
                                .frame(width: 200).border(.blue)
                                .background()
                        }
                    }.frame(width: widthScreen, height: heightScreen / 8)
                        .border(.black)
                    VStack{
                        
                        

                        
                        NavigationLink {
                            SignUpView(isNewAccountSignIn: false, authHelper: authHelper)
                        } label: {
                            Text("Sign In")
                                .font(.title2)
                                .bold()
                                .padding(10)
                                .frame(width: 200).border(.blue)
                        }
                        NavigationLink {
                            SignUpView(isNewAccountSignIn: true, authHelper: authHelper)
                        } label: {
                            Text("Sign Up")
                                .font(.title2)
                                .bold()
                                .padding(10)
                                .frame(width: 200).border(.blue)
                        }
                        
                    }.frame(width: widthScreen, height: heightScreen / 5)
                        .border(.black)
                    NavigationLink(destination: ContentView(spoonVerified: true).environmentObject(session), isActive: $authenticated){}
                        
                }
//                .onAppear{
//                    //stored user
//                    if session.loggedInUser != nil {
//                        self.authenticated = true
//
//                    }
//                }
                .navigationBarHidden(true)
            }
            else{
                if session.loggedInUser?.isAnonymous ?? false{
                    VStack{
                        NavigationLink(destination: ContentView(spoonVerified: true).environmentObject(session), isActive: $authenticated){}
                    }
                    .navigationBarHidden(true)
                }
                else{
                    VStack{
                        NavigationLink(destination: ContentView(inApp: false).environmentObject(session), isActive: $authenticated){}
                        //NavigationLink(destination: AwaitingVerificationView(), isActive: $needsAuthentication){}
                    }
//                    .onAppear{
//                        self.authenticated = false
//                        Task{
//                            if await AuthController.isActivated(){
//                                //continue
//                                self.authenticated = true
//                            }
//                            else{
//                                self.needsAuthentication = true
//                            }
//                        }
//                    }
                    .navigationBarHidden(true)
                }
                
            }
            
            
        }.navigationBarHidden(true)
        
        //Spacer()
    }
}

//struct StartView_Previews: PreviewProvider {
//    static var previews: some View {
//        StartView()
//    }
//}
