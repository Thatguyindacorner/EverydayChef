//
//  ContentView.swift
//  EverydayChef
//
//  Created by Alex Olechnowicz on 2023-05-22.
//

import SwiftUI

enum Tabs{
    case inventory
    case history
    case recipes
}

struct ContentView: View {
    
    @State var currentTab: Tabs = .inventory
    
    //inventory tab toolbar variables
    @State var showingSettings: Bool = false
    @State var currentStorageType: StorageLocation = .fridge
    @State var inShoppingList: Bool = false
    
    @State var hideToolbar: Bool = false
    
    
    @EnvironmentObject var session: SessionData
    
    var body: some View {
        
        ZStack{
            NavigationView{
                
                TabView(selection: $currentTab) {
                    
                    InventoryTab(inShoppingList: $inShoppingList,
                                 currentStorageType: $currentStorageType).tabItem {
                        
                        Image(systemName: "cabinet")
                        Text("Inventory")
                    }.tag(Tabs.inventory)
                    
                    HistoryTab().tabItem {
                        Image(systemName: "calendar")
                        Text("History")
                    }.tag(Tabs.history)
                    
                    RecipeBookTab().tabItem {
                        Image(systemName: "book")
                        Text("Recipe Book")
                    }.tag(Tabs.recipes)

                }
                //modular toolbar
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading){
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



                    ToolbarItemGroup(placement: .principal){
                        switch currentTab {
                        case .inventory:
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
                        case .history:
                            Text("HISTORY")
                        case .recipes:
                            Text("RECIPES")
                        }
                        

                    }

                    ToolbarItemGroup(placement: .navigationBarTrailing){
                        switch currentTab {
                        case .inventory:
                            Button(action:{
                                //shopping list
                                inShoppingList = true
                            }){
                                Image(systemName: "cart")
                            }
                        case .history:
                            Text("")
                        
                        case .recipes:
                            Text("")
                        }
                        


                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                
                //.navigationBarHidden(true)
                //.navigationBarBackButtonHidden(true)
            }//.navigationViewStyle(.stack)
                SidebarProfileView(isSidebarVisable: $showingSettings, sidebarHidden: $hideToolbar)
            }//}
        
        //.navigationBarTitleDisplayMode(.inline)
        
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
