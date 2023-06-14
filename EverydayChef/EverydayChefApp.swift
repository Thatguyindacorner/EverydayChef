//
//  EverydayChefApp.swift
//  EverydayChef
//
//  Created by Alex Olechnowicz on 2023-05-22.
//

import SwiftUI
import FirebaseCore

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
    
    var body: some Scene {
        WindowGroup {
            //ContentView()
            StartView().environmentObject(session)
                //.navigationBarHidden(true)
        }
    }
}
