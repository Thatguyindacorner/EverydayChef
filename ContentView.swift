//
//  ContentView.swift
//  EverydayChef
//
//  Created by Alex Olechnowicz on 2023-05-22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        TabView {
            
            InventoryTab().tabItem {
                Image(systemName: "cabinet")
                Text("Inventory")
            }
            
            HistoryTab().tabItem {
                Image(systemName: "calendar")
                Text("History")
            }
            
            RecipeBookTab().tabItem {
                Image(systemName: "book")
                Text("Recipe Book")
            }
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
