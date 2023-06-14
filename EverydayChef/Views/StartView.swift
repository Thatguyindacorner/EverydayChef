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
    
    let authHelper: AuthController = AuthController()
    
    @EnvironmentObject var session: SessionData
    
    var body: some View {
        
//        let _ = Binding<Bool> {
//            return authHelper.user != nil
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
                        
                        Button(action:{
                            
                        }){
                            Text("Sign In")
                                .font(.title2)
                                .bold()
                                .padding(10)
                                .frame(width: 200).border(.blue)
                        }
                        Button(action:{
                            
                        }){
                            Text("Sign Up")
                                .font(.title2)
                                .bold()
                                .padding(10)
                                .frame(width: 200).border(.blue)
                        }
                    }.frame(width: widthScreen, height: heightScreen / 5)
                        .border(.black)
                    NavigationLink(destination: ContentView().environmentObject(session), isActive: $authenticated){}
                        
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
                VStack{
                    NavigationLink(destination: ContentView().environmentObject(session), isActive: $authenticated){}
                }
                .navigationBarHidden(true)
            }
            
            
        }
        
        //Spacer()
    }
}

//struct StartView_Previews: PreviewProvider {
//    static var previews: some View {
//        StartView()
//    }
//}
