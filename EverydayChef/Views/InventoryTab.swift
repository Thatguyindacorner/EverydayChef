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
    
    var body: some View {
        //NavigationView{
            
            ZStack{
                //inventory
                VStack{
                    
                    //fridge content
                    //5 shelves
                    Text("Hello World")
                    
            
                        
                }//.opacity(!showSettings ? 1 : 0)
                
                //.navigationBarHidden(showSettings).animation(.easeInOut.delay(0.25), value: showSettings)
                
                //sidebar
                //SidebarProfileView(isSidebarVisable: $showSettings)
                
            }
            
            
            
        }
        
    
    
        
    //}
    
        
}

//struct InventoryTab_Previews: PreviewProvider {
//    static var previews: some View {
//        InventoryTab()
//    }
//}
