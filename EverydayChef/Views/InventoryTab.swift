//
//  InventoryTab.swift
//  EverydayChef
//
//  Created by Alex Olechnowicz on 2023-05-26.
//

import SwiftUI

extension String: Identifiable { public var id: String { self } }

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
    
    let doorGap = UIScreen.main.bounds.size.width / 2.6
    
    @State var isOpenFridge: Bool = false
    @State var isOpenPantry: Bool = false
    @State var isOpenBar: Bool = false
    
    @State var openClose: Bool = false
    
    
    var body: some View {
        
            ZStack{
                
                

                //inventory
                InternalDisplay()
                
                //doors
                ForegroundDisplay()
                
                NavigationLink(destination: ShoppingListView(), isActive: $inShoppingList){}

            
            }
            
        }
    
    @ViewBuilder
    func InternalDisplay() -> some View{
        
        let tempList: [String] = ["Ingredient 1", "Ingredient 2", "Ingredient 3", "Ingredient 4", "Ingredient 5", "Ingredient 6", "Ingredient 7"]
        
        
        switch currentStorageType {
        case .fridge:
            GeometryReader{ space in
                
                VStack(alignment: .center, spacing: 0){
                    ScrollView(.horizontal){
                        //FRUITS AND VEGGIES
                        LazyHStack{
                            ForEach(tempList){ ingredient in
                                Button(action:{
                                    //goto ingredient detail
                                }){
                                    VStack(spacing: 0){
                                        Image("HomeImage").resizable()
                                        Text(ingredient).padding(.bottom, 10)
                                    }.frame(width: space.size.height/5, height: space.size.height/5)
                                }.padding(5)
                            }
                        }
                    }.frame(width: space.size.width - doorGap/2, height: space.size.height/5)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color.black), alignment: .top)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color.gray), alignment: .bottom)
                        .offset(x: doorGap/4)
                    
                    
                    
                    ScrollView(.horizontal){
                        //MEAT
                        LazyHStack{
                            ForEach(tempList){ ingredient in
                                Button(action:{
                                    //goto ingredient detail
                                }){
                                    VStack(spacing: 0){
                                        Image("HomeImage").resizable()
                                        Text(ingredient).padding(.bottom, 10)
                                    }.frame(width: space.size.height/5, height: space.size.height/5)
                                }.padding(5)
                            }
                        }
                    }.frame(width: space.size.width - doorGap/2, height: space.size.height/5)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color.gray), alignment: .bottom)
                        .offset(x: doorGap/4)
                    
                    
                    
                    ScrollView(.horizontal){
                        //MADE FOOD
                        LazyHStack{
                            Button(action:{
                                //goto make new food
                            }){
                                Text("+").font(.largeTitle).frame(width: space.size.height/5, height: space.size.height/5).background(.gray).opacity(0.35)
                            }
                            
                            ForEach(tempList){ ingredient in
                                Button(action:{
                                    //goto ingredient detail
                                }){
                                    VStack(spacing: 0){
                                        Image("HomeImage").resizable()
                                        Text(ingredient).padding(.bottom, 10)
                                    }.frame(width: space.size.height/5, height: space.size.height/5)
                                }.padding(5)
                            }
                        }
                    }.frame(width: space.size.width - doorGap/2, height: space.size.height/5)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color.gray), alignment: .bottom)
                        .offset(x: doorGap/4)
                    
                    
                    
                    ScrollView(.horizontal){
                        //DARIY
                        LazyHStack{
                            ForEach(tempList){ ingredient in
                                Button(action:{
                                    //goto ingredient detail
                                }){
                                    VStack(spacing: 0){
                                        Image("HomeImage").resizable()
                                        Text(ingredient).padding(.bottom, 10)
                                    }.frame(width: space.size.height/5, height: space.size.height/5)
                                }.padding(5)
                            }
                        }
                    }.frame(width: space.size.width - doorGap/2, height: space.size.height/5)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color.gray), alignment: .bottom)
                        .offset(x: doorGap/4)
                    
                    
                    
                    ScrollView(.horizontal){
                        //FREEZER
                        LazyHStack{
                            ForEach(tempList){ ingredient in
                                Button(action:{
                                    //goto ingredient detail
                                }){
                                    VStack(spacing: 0){
                                        Image("HomeImage").resizable()
                                        Text(ingredient).padding(.bottom, 10)
                                    }.frame(width: space.size.height/5, height: space.size.height/5)
                                }.padding(5)
                            }
                        }
                    }.frame(width: space.size.width - doorGap/2, height: space.size.height/5)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color.black), alignment: .bottom)
                        .offset(x: doorGap/4)
                }
            }
            
            
        case .pantry:
            //STILL FRIDGE
            GeometryReader{ space in
                
                VStack(alignment: .center, spacing: 0){
                    ScrollView(.horizontal){
                        //FRUITS AND VEGGIES
                        LazyHStack{
                            ForEach(tempList){ ingredient in
                                Button(action:{
                                    //goto ingredient detail
                                }){
                                    VStack(spacing: 0){
                                        Image("HomeImage").resizable()
                                        Text(ingredient).padding(.bottom, 10)
                                    }.frame(width: space.size.height/5, height: space.size.height/5)
                                }.padding(5)
                            }
                        }
                    }.frame(width: space.size.width - doorGap/2, height: space.size.height/5)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color.black), alignment: .top)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color.gray), alignment: .bottom)
                        .offset(x: doorGap/4)
                    
                    
                    
                    ScrollView(.horizontal){
                        //MEAT
                        LazyHStack{
                            ForEach(tempList){ ingredient in
                                Button(action:{
                                    //goto ingredient detail
                                }){
                                    VStack(spacing: 0){
                                        Image("HomeImage").resizable()
                                        Text(ingredient).padding(.bottom, 10)
                                    }.frame(width: space.size.height/5, height: space.size.height/5)
                                }.padding(5)
                            }
                        }
                    }.frame(width: space.size.width - doorGap/2, height: space.size.height/5)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color.gray), alignment: .bottom)
                        .offset(x: doorGap/4)
                    
                    
                    
                    ScrollView(.horizontal){
                        //MADE FOOD
                        LazyHStack{
                            ForEach(tempList){ ingredient in
                                Button(action:{
                                    //goto ingredient detail
                                }){
                                    VStack(spacing: 0){
                                        Image("HomeImage").resizable()
                                        Text(ingredient).padding(.bottom, 10)
                                    }.frame(width: space.size.height/5, height: space.size.height/5)
                                }.padding(5)
                            }
                        }
                    }.frame(width: space.size.width - doorGap/2, height: space.size.height/5)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color.gray), alignment: .bottom)
                        .offset(x: doorGap/4)
                    
                    
                    
                    ScrollView(.horizontal){
                        //DARIY
                        LazyHStack{
                            ForEach(tempList){ ingredient in
                                Button(action:{
                                    //goto ingredient detail
                                }){
                                    VStack(spacing: 0){
                                        Image("HomeImage").resizable()
                                        Text(ingredient).padding(.bottom, 10)
                                    }.frame(width: space.size.height/5, height: space.size.height/5)
                                }.padding(5)
                            }
                        }
                    }.frame(width: space.size.width - doorGap/2, height: space.size.height/5)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color.gray), alignment: .bottom)
                        .offset(x: doorGap/4)
                    
                    
                    
                    ScrollView(.horizontal){
                        //FREEZER
                        LazyHStack{
                            ForEach(tempList){ ingredient in
                                Button(action:{
                                    //goto ingredient detail
                                }){
                                    VStack(spacing: 0){
                                        Image("HomeImage").resizable()
                                        Text(ingredient).padding(.bottom, 10)
                                    }.frame(width: space.size.height/5, height: space.size.height/5)
                                }.padding(5)
                            }
                        }
                    }.frame(width: space.size.width - doorGap/2, height: space.size.height/5)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color.black), alignment: .bottom)
                        .offset(x: doorGap/4)
                }
            }
        case .bar:
            GeometryReader{ space in
                VStack(alignment: .center, spacing: 0){
                    ScrollView(.horizontal){
                        //White Wine
                        LazyHStack{
                            ForEach(tempList){ ingredient in
                                Button(action:{
                                    //goto ingredient detail
                                }){
                                    VStack(spacing: 0){
                                        Image("HomeImage").resizable()
                                        Text(ingredient).padding(.bottom, 10)
                                    }.frame(width: space.size.height/5, height: space.size.height/5)
                                }.padding(5)
                            }
                        }
                    }.frame(width: space.size.width, height: space.size.height/6)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color.black), alignment: .bottom)
                    
                    ScrollView(.horizontal){
                        //Red Wine
                        LazyHStack{
                            ForEach(tempList){ ingredient in
                                Button(action:{
                                    //goto ingredient detail
                                }){
                                    VStack(spacing: 0){
                                        Image("HomeImage").resizable()
                                        Text(ingredient).padding(.bottom, 10)
                                    }.frame(width: space.size.height/5, height: space.size.height/5)
                                }.padding(5)
                            }
                        }
                    }.frame(width: space.size.width, height: space.size.height/6)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color.black), alignment: .bottom)
                    
                    ScrollView(.horizontal){
                        //Liqour
                        LazyHStack{
                            ForEach(tempList){ ingredient in
                                Button(action:{
                                    //goto ingredient detail
                                }){
                                    VStack(spacing: 0){
                                        Image("HomeImage").resizable()
                                        Text(ingredient).padding(.bottom, 10)
                                    }.frame(width: space.size.height/5, height: space.size.height/5)
                                }.padding(5)
                            }
                        }
                    }.frame(width: space.size.width, height: space.size.height/3)
                        .overlay(Rectangle().frame(width: nil, height: 30, alignment: .bottom).foregroundColor(Color.black), alignment: .bottom)
                    
                    ScrollView(.horizontal){
                        //Red Wine
                        LazyHStack{
                            ForEach(tempList){ ingredient in
                                Button(action:{
                                    //goto ingredient detail
                                }){
                                    VStack(spacing: 0){
                                        Image("HomeImage").resizable()
                                        Text(ingredient).padding(.bottom, 10)
                                    }.frame(width: space.size.height/5, height: space.size.height/5)
                                }.padding(5)
                            }
                        }
                    }.frame(width: space.size.width, height: space.size.height/6)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color.black), alignment: .bottom)
                    
                    ScrollView(.horizontal){
                        //Red Wine
                        LazyHStack{
                            ForEach(tempList){ ingredient in
                                Button(action:{
                                    //goto ingredient detail
                                }){
                                    VStack(spacing: 0){
                                        Image("HomeImage").resizable()
                                        Text(ingredient).padding(.bottom, 10)
                                    }.frame(width: space.size.height/5, height: space.size.height/5)
                                }.padding(5)
                            }
                        }
                    }.frame(width: space.size.width, height: space.size.height/6)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color.black), alignment: .bottom)
                    
                }
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
                                    isOpenFridge.toggle()
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
                        .offset(x: !isOpenFridge ? 0 : -space.size.width/2.6)
                        .animation(.default, value: isOpenFridge)

                    VStack{
                        Spacer()
                        HStack{
                            VStack(alignment: .leading){
                                Button(action:{
                                    //open door(s)
                                    isOpenFridge.toggle()
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
                        .offset(x: !isOpenFridge ? 0 : space.size.width/2.6)
                        .animation(.default, value: isOpenFridge)

                }
            }
        case .pantry:
            GeometryReader{ space in
                HStack(spacing: 0){

                    VStack{
                        Spacer()
                        ZStack{
                            VStack{
                                Rectangle().frame(width: space.size.width / 3.75, height: space.size.height / 1.15).foregroundColor(.clear).border(.black, width: 2)
                            }
                            HStack{
                                Spacer()
                                VStack(alignment: .trailing){
                                    Button(action:{
                                        //open door(s)
                                        isOpenPantry.toggle()
                                    }){
                                        Circle().frame(width: space.size.width / 15, height: space.size.width / 3).foregroundColor(.black).padding(.top, space.size.height / 5)
                                    }
                                }.padding(.trailing, space.size.width / 35)
                            }
                            
                        }
                        Spacer()
                    }.frame(width: space.size.width/2)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color.black), alignment: .top)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color.black), alignment: .bottom)
                        .overlay(Rectangle().frame(width: 1, height: nil, alignment: .trailing).foregroundColor(Color.black), alignment: .trailing)
                        .background(Color.brown, ignoresSafeAreaEdges: .horizontal)
                        .offset(x: !isOpenPantry ? 0 : -space.size.width/2.6)
                        .animation(.default, value: isOpenPantry)

                    VStack{
                        Spacer()
                        ZStack{
                            VStack{
                                Rectangle().frame(width: space.size.width / 3.75, height: space.size.height / 1.15).foregroundColor(.clear).border(.black, width: 2)
                            }
                            HStack{
                                
                                VStack(alignment: .leading){
                                    Button(action:{
                                        //open door(s)
                                        isOpenPantry.toggle()
                                    }){
                                        Circle().frame(width: space.size.width / 15, height: space.size.width / 3).foregroundColor(.black).padding(.top, space.size.height / 5)
                                    }
                                }.padding(.leading, space.size.width / 35)
                                Spacer()
                            }
                            
                        }
                        Spacer()
                    }.frame(width: space.size.width/2)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color.black), alignment: .top)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color.black), alignment: .bottom)
                        .overlay(Rectangle().frame(width: 1, height: nil, alignment: .leading).foregroundColor(Color.black), alignment: .leading)
                        .background(Color.brown, ignoresSafeAreaEdges: .horizontal)
                        .offset(x: !isOpenPantry ? 0 : space.size.width/2.6)
                        .animation(.default, value: isOpenPantry)

                }
            }
        case .bar:
            GeometryReader{ space in
                VStack(spacing: 0){
//                    HStack{
//                        ZStack{
//                            Rectangle().frame(width: space.size.width, height: (space.size.height / 6)).foregroundColor(Color.yellow)
//                                .overlay(Rectangle().frame(width: nil, height: 10, alignment: .bottom).foregroundColor(Color.black), alignment: .bottom)
//                        }
//                    }
//                    //Spacer()
//                    HStack{
//                        ZStack{
//                            Rectangle().frame(width: space.size.width, height: (space.size.height / 6)).foregroundColor(Color.yellow)
//                                .overlay(Rectangle().frame(width: nil, height: 10, alignment: .bottom).foregroundColor(Color.black), alignment: .bottom)
//                        }
//                    }
//                    VStack{
//                        ZStack{
//                            Rectangle().frame(width: space.size.width, height: (space.size.height / 5)).foregroundColor(Color.orange)
//                                .overlay(Rectangle().frame(width: nil, height: 50, alignment: .bottom).foregroundColor(Color.black), alignment: .bottom)
//                        }
//
//                    }
                    Spacer()
                    HStack(alignment: .bottom, spacing: 0){
                        VStack(spacing:0){
                            Spacer()
                            HStack{
                                Spacer()
                                VStack(alignment: .trailing){
                                    Button(action:{
                                        //open door(s)
                                        isOpenBar.toggle()
                                    }){
                                        RoundedRectangle(cornerSize: CGSize(width: 20, height: 50)).frame(width: space.size.width / 15, height: space.size.width / 3).foregroundColor(.black)
                                    }
                                }.padding(.trailing, space.size.width / 35)
                            }
                            Spacer()
                        }.frame(width: space.size.width/2, height: space.size.height/3)
                            .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color.black), alignment: .top)
                            .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color.black), alignment: .bottom)
                            .overlay(Rectangle().frame(width: 1, height: nil, alignment: .trailing).foregroundColor(Color.black), alignment: .trailing)
                            .background(Color.gray, ignoresSafeAreaEdges: .horizontal)
                            .offset(x: !isOpenBar ? 0 : -space.size.width/2.6)
                            .animation(.default, value: isOpenBar)

                        VStack{
                            Spacer()
                            HStack{
                                VStack(alignment: .leading){
                                    Button(action:{
                                        //open door(s)
                                        isOpenBar.toggle()
                                    }){
                                        RoundedRectangle(cornerSize: CGSize(width: 20, height: 50)).frame(width: space.size.width / 15, height: space.size.width / 3).foregroundColor(.black)
                                    }
                                }.padding(.leading, space.size.width / 35)
                                Spacer()
                            }
                            Spacer()
                        }.frame(width: space.size.width/2, height: space.size.height/3)
                            .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color.black), alignment: .top)
                            .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color.black), alignment: .bottom)
                            .overlay(Rectangle().frame(width: 1, height: nil, alignment: .leading).foregroundColor(Color.black), alignment: .leading)
                            .background(Color.gray, ignoresSafeAreaEdges: .horizontal)
                            .offset(x: !isOpenBar ? 0 : space.size.width/2.6)
                            .animation(.default, value: isOpenBar)

                    }
                }
                
            }
        }
    }
        
    //}
    
        
}

//struct InventoryTab_Previews: PreviewProvider {
//    static var previews: some View {
//        InventoryTab()
//    }
//}
