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
    
    @State var showSettings: Bool = false
    @State var inShoppingList: Bool = false
    
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(destination: ShoppingListView(), isActive: $inShoppingList){}
                //fridge content
                //5 shelves
                Text("Hello World")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action:{
                        //profile, settings, loggout, etc.
                        //custom sidebar sliding from left
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

struct InventoryTab_Previews: PreviewProvider {
    static var previews: some View {
        InventoryTab()
    }
}
