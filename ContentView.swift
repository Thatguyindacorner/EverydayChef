//
//  ContentView.swift
//  EverydayChef
//
//  Created by Alex Olechnowicz on 2023-05-22.
//

import SwiftUI

struct ContentView: View {
    
    @State var showingSettings: Bool = false
    
    var body: some View {

        ZStack{
            TabView {
                
                InventoryTab(showSettings: $showingSettings).tabItem {
                    Image(systemName: "cabinet")
                    Text("Inventory")
                }
                
                HistoryTab().tabItem {
                    Image(systemName: "calendar")
                    Text("History")
                }
                
                RecipeBookTab().tabItem {
                    Image(systemName: "book")
                    Text("Recipe Book").opacity(showingSettings ? 1 : 0)
                }
            }
            SidebarProfileView(isSidebarVisable: $showingSettings)
        }
        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
