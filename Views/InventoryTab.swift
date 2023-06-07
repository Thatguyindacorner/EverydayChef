//
//  InventoryTab.swift
//  EverydayChef
//
//  Created by Alex Olechnowicz on 2023-05-26.
//

import SwiftUI

enum StorageLocation: String{
    case fridge = "Fridge"
    case pantry = "Pantry"
    case bar = "Bar"
}

struct InventoryTab: View {
    
    @State var currentStorageType: StorageLocation = .fridge
    
    @Binding var showSettings: Bool
    @State var inShoppingList: Bool = false
    
    var body: some View {
        NavigationView{
            
            ZStack{
                //inventory
                VStack{
                    NavigationLink(destination: ShoppingListView(), isActive: $inShoppingList){}
                    //fridge content
                    //5 shelves
                    Text("Hello World")
                }//.opacity(!showSettings ? 1 : 0)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading){
                        Button(action:{
                            //profile, settings, loggout, etc.
                            //custom sidebar sliding from left
                            print(UITabBar.appearance().frame.height)
                            showSettings.toggle()
                            print()
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
                //.navigationBarHidden(showSettings).animation(.easeInOut.delay(0.25), value: showSettings)
                
                //sidebar
                //SidebarProfileView(isSidebarVisable: $showSettings)
            }
            
            
        }
    
        
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

//struct InventoryTab_Previews: PreviewProvider {
//    static var previews: some View {
//        InventoryTab()
//    }
//}
