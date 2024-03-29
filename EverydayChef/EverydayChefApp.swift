//
//  EverydayChefApp.swift
//  EverydayChef
//
//  Created by Alex Olechnowicz on 2023-05-22.
//

import SwiftUI
import FirebaseCore
//import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

    FirebaseApp.configure()
    return true
  }
}


@main
struct EverydayChefApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var session: SessionData = SessionData.shared
    
    @State var splashTimeOver: Bool = false
    
    var body: some Scene {
        
        
        WindowGroup{
            Group {
                if splashTimeOver {
                    StartView(authenticated: session.loggedInUser != nil).environmentObject(session)
                } else {
                    SplashView()
                }
            }.onAppear{
                //3.5 seconds of splash then goto login (if account saved, skip login and go straigt to account)
                Task{
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(5.0)){
                        self.splashTimeOver = true
                    }
                    
                    //debug data transfer
                    
                    
//                    var y:[Int] = []
//                    let x = try await Firestore.firestore().collection("users").document("zmpzBB3QYYVDc0Ce68JoNDasPE92").collection("Ingredients").getDocuments().documents
//                    for i in x{
//                        let q = i.data()["id"] as? Int
//                        if y.contains(q ?? -404){
//                            try await Firestore.firestore().collection("users").document("zmpzBB3QYYVDc0Ce68JoNDasPE92").collection("Ingredients").document(i.documentID).delete()
//                        }
//                        else{
//                            y.append(q ?? -404)
//                        }
                    
                    
//                        try await Firestore.firestore().collection("users").document("zmpzBB3QYYVDc0Ce68JoNDasPE92").collection("Ingredients").addDocument(data: i.data())
                    //}
                    //print("done")
                }
                
                
                
                //1 check if connected to the internet
                //2 check if account is stored on phone
                //3 redirect
                
                //redirect to account
                if true{
                    
                }
                //redirect to StartView
                else{
                    
                }
            }
        }
        
        //        WindowGroup(id: "StartView", for: Bool.self){ $skipLogin in
        //            if skipLogin == nil{
        //                StartView(authenticated: false).environmentObject(session)
        //            }
        //            else{
        //                StartView(authenticated: skipLogin!).environmentObject(session)
        //            }
        //        }
        
    }
    
}

struct SplashView: View{
    
    let widthScreen = UIScreen.main.bounds.size.width - 25
    let heightScreen = UIScreen.main.bounds.size.height
    
    //var splashTimeOver: Bool = false
    
    //var session: SessionData = SessionData.shared
    
    //@Environment(\.openWindow) private var openWindow
    
    var body: some View{
        
//        Group{
//            if splashTimeOver{
//                StartView(authenticated: AuthController().authentication.currentUser != nil).environmentObject(session)
//            }
//        }
        
        VStack{
            //Image("HomeImage").resizable().frame(width: widthScreen / 1.5, height: heightScreen / 3.5)
            

            GifImageView("foodimgtransparent2").scaledToFit()
                
            HStack{
                Text("Preping the Kitchen ") //text will change periodically
                ProgressView()
                .tint(.blue)
            }
        }.frame(width: widthScreen / 1.5, height: heightScreen / 3.5)
        .onAppear{
            let _ = AuthController()
        }
        
    }
}
