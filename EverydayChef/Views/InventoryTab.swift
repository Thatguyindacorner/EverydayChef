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
    
    @Binding var inShoppingList: Bool
    
    @Binding var currentStorageType: StorageLocation
    
    
    
    let widthScreen = UIScreen.main.bounds.size.width
    let heightScreen = UIScreen.main.bounds.size.height
    
    @State var isOpen: Bool = false
    @State var openClose: Bool = false
    
    
    var body: some View {
        
            ZStack{
                
                //doors
                ForegroundDisplay()

                //inventory
                VStack{
                    NavigationLink(destination: ShoppingListView(), isActive: $inShoppingList){}
                    //fridge* content
                    //5 shelves
                        
                }
            
            }
            
        }
        
    
    @ViewBuilder
    func ForegroundDisplay() -> some View{
        
        switch currentStorageType{
        case .fridge:
            GeometryReader{ space in
                HStack(spacing: 0){

                    VStack{
                        Spacer()
                        HStack{
                            Spacer()
                            VStack(alignment: .trailing){
                                Button(action:{
                                    //open door(s)
                                    isOpen.toggle()
                                }){
                                    RoundedRectangle(cornerSize: CGSize(width: 20, height: 50)).frame(width: space.size.width / 15, height: space.size.width / 3).foregroundColor(.black)
                                }
                            }.padding(.trailing, space.size.width / 35)
                        }
                        Spacer()
                    }.frame(width: space.size.width/2)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color.black), alignment: .top)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color.black), alignment: .bottom)
                        .overlay(Rectangle().frame(width: 1, height: nil, alignment: .trailing).foregroundColor(Color.black), alignment: .trailing)
                        .background(Color.gray, ignoresSafeAreaEdges: .horizontal)
                        .offset(x: !isOpen ? 0 : -space.size.width/2.6)
                        .animation(.default, value: isOpen)

                    VStack{
                        Spacer()
                        HStack{
                            VStack(alignment: .leading){
                                Button(action:{
                                    //open door(s)
                                    isOpen.toggle()
                                }){
                                    RoundedRectangle(cornerSize: CGSize(width: 20, height: 50)).frame(width: space.size.width / 15, height: space.size.width / 3).foregroundColor(.black)
                                }
                            }.padding(.leading, space.size.width / 35)
                            Spacer()
                        }
                        Spacer()
                    }.frame(width: space.size.width/2)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color.black), alignment: .top)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color.black), alignment: .bottom)
                        .overlay(Rectangle().frame(width: 1, height: nil, alignment: .leading).foregroundColor(Color.black), alignment: .leading)
                        .background(Color.gray, ignoresSafeAreaEdges: .horizontal)
                        .offset(x: !isOpen ? 0 : space.size.width/2.6)
                        .animation(.default, value: isOpen)

                }
            }
        case .pantry:
            Text("PANTRY")
        case .bar:
            Text("BAR")
        }
    }
        
    //}
    
        
}

//struct InventoryTab_Previews: PreviewProvider {
//    static var previews: some View {
//        InventoryTab()
//    }
//}
