//
//  ContentView.swift
//  EverydayChef
//
//  Created by Alex Olechnowicz on 2023-05-22.
//

import SwiftUI

struct ContentView: View {
    
    //inventory tab toolbar variables
    @State var showingSettings: Bool = false
    @State var currentStorageType: StorageLocation = .fridge
    @State var inShoppingList: Bool = false
    
    @State var hideToolbar: Bool = false
    
    
    @EnvironmentObject var session: SessionData
    
    var body: some View {
        
        ZStack{
            NavigationView{
                
                TabView {
    
                    InventoryTab(inShoppingList: $inShoppingList).tabItem {
                        
                        Image(systemName: "cabinet")
                        Text("Inventory")
                    }
                    //.navigationBarHidden(self.inShoppingList || self.hideToolbar)
                    .animation(.default, value: hideToolbar)
                    //.opacity(!showingSettings ? 1 : 0)
                    //}
                    
                    HistoryTab().tabItem {
                        Image(systemName: "calendar")
                        Text("History")
                    }
                    
                    RecipeBookTab().tabItem {
                        Image(systemName: "book")
                        Text("Recipe Book")
                    }
                }
                //modular toolbar
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading){
                        Button(action:{
                            //profile, settings, loggout, etc.
                            //custom sidebar sliding from left
                            
                            //delay for sidebar to appear and toolbar to disappear
                            hideToolbar = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + Double(0.3)){
                                showingSettings.toggle()
                            }
                            
                            
                        }){
                            Image(systemName: "person.circle")
                        }
                    }
                    
                    ToolbarItem(placement: .principal){
                        Menu {
                            //function won't render option if it's already choosen
                            StorageOption(.fridge)
                            StorageOption(.pantry)
                            StorageOption(.bar)
                            
                        } label: {
                            HStack{
                                Text(currentStorageType.rawValue)
                                Image(systemName: "chevron.down")
                            }
                        }
                        
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button(action:{
                            //shopping list
                            inShoppingList = true
                        }){
                            Image(systemName: "cart")
                        }
                    }
                }
            }
                SidebarProfileView(isSidebarVisable: $showingSettings, sidebarHidden: $hideToolbar)
            }//}
        
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    @ViewBuilder
    func StorageOption(_ loc: StorageLocation) -> some View{
        if loc != currentStorageType{
            Button(action:{
                currentStorageType = loc
            }){
                Text(loc.rawValue)
            }
        }
    }

    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
