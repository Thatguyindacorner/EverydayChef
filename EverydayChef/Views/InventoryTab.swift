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

enum FridgeCatagories: Int{
    case produce = 1
    case meat = 2
    case dairy = 3
    case other = 0
}

struct InventoryTab: View {
    
    @Binding var inShoppingList: Bool
    
    @Binding var addIngredient: Bool
    
    @Binding var currentStorageType: StorageLocation
    
    @State var inventory: [AutocompleteIngredient] = []
    
    @State var meatShelf: [AutocompleteIngredient] = []
    @State var produceShelf: [AutocompleteIngredient] = []
    @State var dairyShelf: [AutocompleteIngredient] = []
    @State var freezerShelf: [AutocompleteIngredient] = []
    @State var otherShelf: [AutocompleteIngredient] = []
    
    @State var fridgeShelf: [AutocompleteIngredient] = []
    
    @State var healthShelf: [AutocompleteIngredient] = []
    @State var fillerShelf: [AutocompleteIngredient] = []
    @State var basesShelf: [AutocompleteIngredient] = []
    @State var breadShelf: [AutocompleteIngredient] = []
    @State var snackShelf: [AutocompleteIngredient] = []
    
    @State var redWineShelf: [AutocompleteIngredient] = []
    @State var otherWineShelf: [AutocompleteIngredient] = []
    @State var liqourShelf: [AutocompleteIngredient] = []
    @State var beerShelf: [AutocompleteIngredient] = []
    @State var drinkShelf: [AutocompleteIngredient] = []
    
    let widthScreen = UIScreen.main.bounds.size.width
    let heightScreen = UIScreen.main.bounds.size.height
    
    let doorGap = UIScreen.main.bounds.size.width / 2.6
    
    @State var isOpenFridge: Bool = false
    @State var isOpenPantry: Bool = false
    @State var isOpenBar: Bool = false
    
    @State var openClose: Bool = false
    
    @State var imagesBaseURL: String = "https://spoonacular.com/cdn/ingredients_100x100/"
    
    
    var body: some View {
        
            ZStack{
                
                

                //inventory
                InternalDisplay()
                
                //doors
                ForegroundDisplay()
                
                NavigationLink(destination: ShoppingListView(), isActive: $inShoppingList){}
                NavigationLink(destination: AddIngredientView(), isActive: $addIngredient){}
                
                
            }.onAppear{
                //get inventory update
                print("onAppear")
                self.freezerShelf = []
                self.meatShelf = []
                self.produceShelf = []
                self.dairyShelf = []
                self.fridgeShelf = []
                
                self.healthShelf = []
                self.fillerShelf = []
                self.basesShelf = []
                self.breadShelf = []
                self.snackShelf = []
                
                self.redWineShelf = []
                self.otherWineShelf = []
                self.liqourShelf = []
                self.beerShelf = []
                self.drinkShelf = []
                
                self.otherShelf = []
                
                Task(priority: .high){
                    self.inventory = await FireDbController.getInventory()
                    
                    for ingredient in inventory{
                        
                        var catagory = ""
                        
                        if (ingredient.aisle ?? "").contains(";"){
                            let split = (ingredient.aisle ?? "").split(separator: ";")
                            if String(split.first ?? "") == "Frozen"{
                                catagory = String(split[1])
                            }
                            else{
                                catagory = String(split[0])
                            }
                        }
                        else{
                            catagory = ingredient.aisle ?? ""
                        }
                        
                        if ingredient.inFreezer{
                            self.freezerShelf.append(ingredient)
                        }
                        
                        else{
                            switch catagory{
                            case "Meat":
                                self.meatShelf.append(ingredient)
                            case "Seafood":
                                self.meatShelf.append(ingredient)
                            case "Gourmet":
                                self.meatShelf.append(ingredient)
                                
                            case "Produce":
                                self.produceShelf.append(ingredient)
                            case "Dried Fruits":
                                self.produceShelf.append(ingredient)
                                
                            case "Milk, Eggs, Other Dairy":
                                self.dairyShelf.append(ingredient)
                            case "Cheese":
                                self.dairyShelf.append(ingredient)
                                
                            case "Refrigerated":
                                self.fridgeShelf .append(ingredient)
                            case "Canned and Jarred":
                                self.fridgeShelf.append(ingredient)
                            case "Condiments":
                                self.fridgeShelf.append(ingredient)
                                
                            case "Frozen":
                                self.freezerShelf.append(ingredient)
                                
                                
                            case "Health Foods":
                                self.healthShelf.append(ingredient)
                            case "Tea and Coffee":
                                self.healthShelf.append(ingredient)
                            case "Nut butters, Jams, and Honey":
                                self.healthShelf.append(ingredient)
                                
                            case "Pasta and Rice":
                                self.fillerShelf.append(ingredient)
                            case "Gluten Free":
                                self.fillerShelf.append(ingredient)
                            case "Ethnic Foods":
                                self.fillerShelf.append(ingredient)
                                
                            case "Baking":
                                self.basesShelf.append(ingredient)
                            case "Spices and Seasonings":
                                self.basesShelf.append(ingredient)
                            case "Oil, Vinegar, Salad Dressing":
                                self.basesShelf.append(ingredient)
                                
                            case "Bread":
                                self.breadShelf.append(ingredient)
                            case "Bakery/Bread":
                                self.breadShelf.append(ingredient)
                            case "Cereal":
                                self.breadShelf.append(ingredient)
                                
                            case "Nuts":
                                self.snackShelf.append(ingredient)
                            case "Sweet Snacks":
                                self.snackShelf.append(ingredient)
                            case "Savory Snacks":
                                self.snackShelf.append(ingredient)
                                
                                
                            case "Beverages":
                                self.drinkShelf.append(ingredient)
                            case "Alcoholic Beverages":
                                if (ingredient.name ?? "").lowercased().contains("beer"){
                                    self.beerShelf.append(ingredient)
                                }
                                else if (ingredient.name ?? "").lowercased().contains("red wine"){
                                    self.redWineShelf.append(ingredient)
                                }
                                else if (ingredient.name ?? "").lowercased().contains("white wine"){
                                    self.otherWineShelf.append(ingredient)
                                }
                                else{
                                    self.liqourShelf.append(ingredient)
//                                    //api call for wine
//                                    //https://api.spoonacular.com/food/wine/description?wine=\(ingredient.name)
//                                    if true{
//                                        //wine
//                                        if true{
//                                        //if description.contains("red wine"){
//
//                                            //red wine
//                                            self.redWineShelf.append(ingredient)
//                                        }
//                                        else{
//                                            //wine / other wine
//                                            self.otherWineShelf.append(ingredient)
//                                        }
//                                    }
//                                    else{
//                                        //liqour
//                                        self.liqourShelf.append(ingredient)
//                                    }
                                }
                                
                            default:
                                self.otherShelf.append(ingredient)
                            }
                        }
                    }
                }
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
                            ForEach(dairyShelf, id: \.id){ ingredient in
                                
                                NavigationLink{
                                    IngredientView(ingredient: ingredient, inventory: inventory)
                                    
                                }
                                label: {
                                    VStack(spacing: 0){
                                        AsyncImage(url: URL(string: "\(imagesBaseURL)\(ingredient.image ?? "apple.jpg")")) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                            //.frame(width:100, height: 100)
                                        } placeholder: {
                                            ProgressView()
                                                .tint(.gray)
                                        }
                                        Text(ingredient.name!).padding(.bottom, 10)
                                    }.frame(width: space.size.height/7, height: space.size.height/7)
                                }.padding(5).grayscale(!ingredient.inStock ? 1 : 0)
                                
                            }
                        }
                    }.frame(width: space.size.width - doorGap/2, height: space.size.height/5)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color.black), alignment: .top)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color.gray), alignment: .bottom)
                        .offset(x: doorGap/4)
                    
                    
                    
                    ScrollView(.horizontal){
                        //MEAT
                        LazyHStack{
                            ForEach(meatShelf, id: \.id){ ingredient in
                                NavigationLink{
                                    IngredientView(ingredient: ingredient, inventory: inventory)
                                    
                                }
                                label: {
                                    VStack(spacing: 0){
                                        AsyncImage(url: URL(string: "\(imagesBaseURL)\(ingredient.image ?? "apple.jpg")")) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                            //.frame(width:100, height: 100)
                                        } placeholder: {
                                            ProgressView()
                                                .tint(.gray)
                                        }
                                        Text(ingredient.name!).padding(.bottom, 10)
                                    }.frame(width: space.size.height/7, height: space.size.height/7)
                                }.padding(5).grayscale(!ingredient.inStock ? 1 : 0)
                            }
                        }
                    }.frame(width: space.size.width - doorGap/2, height: space.size.height/5)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color.gray), alignment: .bottom)
                        .offset(x: doorGap/4)
                    
                    
                    
                    ScrollView(.horizontal){
                        //MADE FOOD
                        LazyHStack{
//                            Button(action:{
//                                //goto make new food
//                            }){
//                                Text("+").font(.largeTitle).frame(width: space.size.height/5, height: space.size.height/5).background(.gray).opacity(0.35)
//                            }
                            
                            ForEach(fridgeShelf, id: \.id){ ingredient in
                                NavigationLink{
                                    IngredientView(ingredient: ingredient, inventory: inventory)
                                    
                                }
                                label: {
                                    VStack(spacing: 0){
                                        AsyncImage(url: URL(string: "\(imagesBaseURL)\(ingredient.image ?? "apple.jpg")")) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                            //.frame(width:100, height: 100)
                                        } placeholder: {
                                            ProgressView()
                                                .tint(.gray)
                                        }
                                        Text(ingredient.name!).padding(.bottom, 10)
                                    }.frame(width: space.size.height/7, height: space.size.height/7)
                                }.padding(5).grayscale(!ingredient.inStock ? 1 : 0)
                            }
                        }
                    }.frame(width: space.size.width - doorGap/2, height: space.size.height/5)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color.gray), alignment: .bottom)
                        .offset(x: doorGap/4)
                    
                    
                    
                    ScrollView(.horizontal){
                        //DARIY
                        LazyHStack{
                            ForEach(produceShelf, id: \.id){ ingredient in
                                NavigationLink{
                                    IngredientView(ingredient: ingredient, inventory: inventory)
                                    
                                }
                                label: {
                                    VStack(spacing: 0){
                                        AsyncImage(url: URL(string: "\(imagesBaseURL)\(ingredient.image ?? "apple.jpg")")) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                            //.frame(width:100, height: 100)
                                        } placeholder: {
                                            ProgressView()
                                                .tint(.gray)
                                        }
                                        Text(ingredient.name!).padding(.bottom, 10)
                                    }.frame(width: space.size.height/7, height: space.size.height/7)
                                }.padding(5).grayscale(!ingredient.inStock ? 1 : 0)
                            }
                        }
                    }.frame(width: space.size.width - doorGap/2, height: space.size.height/5)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color.gray), alignment: .bottom)
                        .offset(x: doorGap/4)
                    
                    
                    
                    ZStack{
                        
                        Color.blue
                            .opacity(0.10)
                        
                        ScrollView(.horizontal){
                            //FREEZER
                           // ZStack{
                                
                                LazyHStack{
                                    ForEach(freezerShelf, id: \.id){ ingredient in
                                        NavigationLink{
                                            IngredientView(ingredient: ingredient, inventory: inventory)
                                            
                                        }
                                        label: {
                                            VStack(spacing: 0){
                                                ZStack{
                                                    AsyncImage(url: URL(string: "\(imagesBaseURL)\(ingredient.image ?? "apple.jpg")")) { image in
                                                        image
                                                            .resizable()
                                                            .scaledToFit()
                                                        //.frame(width:100, height: 100)
                                                    } placeholder: {
                                                        ProgressView()
                                                            .tint(.gray)
                                                    }
                                                }
                                                Text(ingredient.name!).padding(.bottom, 10)
                                            }.frame(width: space.size.height/7, height: space.size.height/7)
                                        }.padding(5).grayscale(!ingredient.inStock ? 1 : 0)
                                    }
                                }
                            //}
                            
                        }
                        
                    }
                    .frame(width: space.size.width - doorGap/2, height: space.size.height/5)
                        
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
                            ForEach(breadShelf, id: \.id){ ingredient in
                                NavigationLink{
                                    IngredientView(ingredient: ingredient, inventory: inventory)
                                    
                                }
                                label: {
                                    VStack(spacing: 0){
                                        ZStack{
                                            AsyncImage(url: URL(string: "\(imagesBaseURL)\(ingredient.image ?? "apple.jpg")")) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                //.frame(width:100, height: 100)
                                            } placeholder: {
                                                ProgressView()
                                                    .tint(.gray)
                                            }
                                        }
                                        Text(ingredient.name!).padding(.bottom, 10)
                                    }.frame(width: space.size.height/7, height: space.size.height/7)
                                }.padding(5).grayscale(!ingredient.inStock ? 1 : 0)
                            }
                        }
                    }.frame(width: space.size.width - doorGap/2, height: space.size.height/5)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color.black), alignment: .top)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color.gray), alignment: .bottom)
                        .offset(x: doorGap/4)
                    
                    
                    
                    ScrollView(.horizontal){
                        //MEAT
                        LazyHStack{
                            ForEach(healthShelf, id: \.id){ ingredient in
                                NavigationLink{
                                    IngredientView(ingredient: ingredient, inventory: inventory)
                                    
                                }
                                label: {
                                    VStack(spacing: 0){
                                        ZStack{
                                            AsyncImage(url: URL(string: "\(imagesBaseURL)\(ingredient.image ?? "apple.jpg")")) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                //.frame(width:100, height: 100)
                                            } placeholder: {
                                                ProgressView()
                                                    .tint(.gray)
                                            }
                                        }
                                        Text(ingredient.name!).padding(.bottom, 10)
                                    }.frame(width: space.size.height/7, height: space.size.height/7)
                                }.padding(5).grayscale(!ingredient.inStock ? 1 : 0)
                            }
                        }
                    }.frame(width: space.size.width - doorGap/2, height: space.size.height/5)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color.gray), alignment: .bottom)
                        .offset(x: doorGap/4)
                    
                    
                    
                    ScrollView(.horizontal){
                        //MADE FOOD
                        LazyHStack{
                            ForEach(snackShelf, id: \.id){ ingredient in
                                NavigationLink{
                                    IngredientView(ingredient: ingredient, inventory: inventory)
                                    
                                }
                                label: {
                                    VStack(spacing: 0){
                                        ZStack{
                                            AsyncImage(url: URL(string: "\(imagesBaseURL)\(ingredient.image ?? "apple.jpg")")) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                //.frame(width:100, height: 100)
                                            } placeholder: {
                                                ProgressView()
                                                    .tint(.gray)
                                            }
                                        }
                                        Text(ingredient.name!).padding(.bottom, 10)
                                    }.frame(width: space.size.height/7, height: space.size.height/7)
                                }.padding(5).grayscale(!ingredient.inStock ? 1 : 0)
                            }
                        }
                    }.frame(width: space.size.width - doorGap/2, height: space.size.height/5)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color.gray), alignment: .bottom)
                        .offset(x: doorGap/4)
                    
                    
                    
                    ScrollView(.horizontal){
                        //DARIY
                        LazyHStack{
                            ForEach(fillerShelf, id: \.id){ ingredient in
                                NavigationLink{
                                    IngredientView(ingredient: ingredient, inventory: inventory)
                                    
                                }
                                label: {
                                    VStack(spacing: 0){
                                        ZStack{
                                            AsyncImage(url: URL(string: "\(imagesBaseURL)\(ingredient.image ?? "apple.jpg")")) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                //.frame(width:100, height: 100)
                                            } placeholder: {
                                                ProgressView()
                                                    .tint(.gray)
                                            }
                                        }
                                        Text(ingredient.name!).padding(.bottom, 10)
                                    }.frame(width: space.size.height/7, height: space.size.height/7)
                                }.padding(5).grayscale(!ingredient.inStock ? 1 : 0)
                            }
                        }
                    }.frame(width: space.size.width - doorGap/2, height: space.size.height/5)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color.gray), alignment: .bottom)
                        .offset(x: doorGap/4)
                    
                    
                    
                    ScrollView(.horizontal){
                        //FREEZER
                        LazyHStack{
                            ForEach(basesShelf, id: \.id){ ingredient in
                                NavigationLink{
                                    IngredientView(ingredient: ingredient, inventory: inventory)
                                    
                                }
                                label: {
                                    VStack(spacing: 0){
                                        ZStack{
                                            AsyncImage(url: URL(string: "\(imagesBaseURL)\(ingredient.image ?? "apple.jpg")")) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                //.frame(width:100, height: 100)
                                            } placeholder: {
                                                ProgressView()
                                                    .tint(.gray)
                                            }
                                        }
                                        Text(ingredient.name!).padding(.bottom, 10)
                                    }.frame(width: space.size.height/7, height: space.size.height/7)
                                }.padding(5).grayscale(!ingredient.inStock ? 1 : 0)
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
                            ForEach(redWineShelf, id: \.id){ ingredient in
                                NavigationLink{
                                    IngredientView(ingredient: ingredient, inventory: inventory)
                                    
                                }
                                label: {
                                    VStack(spacing: 0){
                                        ZStack{
                                            AsyncImage(url: URL(string: "\(imagesBaseURL)\(ingredient.image ?? "apple.jpg")")) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                //.frame(width:100, height: 100)
                                            } placeholder: {
                                                ProgressView()
                                                    .tint(.gray)
                                            }
                                        }
                                        Text(ingredient.name!).padding(.bottom, 10)
                                    }.frame(width: space.size.height/7, height: space.size.height/7)
                                }.padding(5).grayscale(!ingredient.inStock ? 1 : 0)
                            }
                        }
                    }.frame(width: space.size.width, height: space.size.height/6)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color.black), alignment: .bottom)
                    
                    ScrollView(.horizontal){
                        //Red Wine
                        LazyHStack{
                            ForEach(otherWineShelf, id: \.id){ ingredient in
                                NavigationLink{
                                    IngredientView(ingredient: ingredient, inventory: inventory)
                                    
                                }
                                label: {
                                    VStack(spacing: 0){
                                        ZStack{
                                            AsyncImage(url: URL(string: "\(imagesBaseURL)\(ingredient.image ?? "apple.jpg")")) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                //.frame(width:100, height: 100)
                                            } placeholder: {
                                                ProgressView()
                                                    .tint(.gray)
                                            }
                                        }
                                        Text(ingredient.name!).padding(.bottom, 10)
                                    }.frame(width: space.size.height/7, height: space.size.height/7)
                                }.padding(5).grayscale(!ingredient.inStock ? 1 : 0)
                            }
                        }
                    }.frame(width: space.size.width, height: space.size.height/6)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color.black), alignment: .bottom)
                    
                    ScrollView(.horizontal){
                        //Liqour
                        LazyHStack{
                            ForEach(liqourShelf, id: \.id){ ingredient in
                                NavigationLink{
                                    IngredientView(ingredient: ingredient, inventory: inventory)
                                    
                                }
                                label: {
                                    VStack(spacing: 0){
                                        ZStack{
                                            AsyncImage(url: URL(string: "\(imagesBaseURL)\(ingredient.image ?? "apple.jpg")")) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                //.frame(width:100, height: 100)
                                            } placeholder: {
                                                ProgressView()
                                                    .tint(.gray)
                                            }
                                        }
                                        Text(ingredient.name!).padding(.bottom, 10)
                                    }.frame(width: space.size.height/7, height: space.size.height/7)
                                }.padding(5).grayscale(!ingredient.inStock ? 1 : 0)
                            }
                        }
                    }.frame(width: space.size.width, height: space.size.height/3)
                        .overlay(Rectangle().frame(width: nil, height: 30, alignment: .bottom).foregroundColor(Color.black), alignment: .bottom)
                    
                    ScrollView(.horizontal){
                        //Red Wine
                        LazyHStack{
                            ForEach(beerShelf, id: \.id){ ingredient in
                                NavigationLink{
                                    IngredientView(ingredient: ingredient, inventory: inventory)
                                    
                                }
                                label: {
                                    VStack(spacing: 0){
                                        ZStack{
                                            AsyncImage(url: URL(string: "\(imagesBaseURL)\(ingredient.image ?? "apple.jpg")")) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                //.frame(width:100, height: 100)
                                            } placeholder: {
                                                ProgressView()
                                                    .tint(.gray)
                                            }
                                        }
                                        Text(ingredient.name!).padding(.bottom, 10)
                                    }.frame(width: space.size.height/7, height: space.size.height/7)
                                }.padding(5).grayscale(!ingredient.inStock ? 1 : 0)
                            }
                        }
                    }.frame(width: space.size.width, height: space.size.height/6)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color.black), alignment: .bottom)
                    
                    ScrollView(.horizontal){
                        //Red Wine
                        LazyHStack{
                            ForEach(drinkShelf, id: \.id){ ingredient in
                                NavigationLink{
                                    IngredientView(ingredient: ingredient, inventory: inventory)
                                    
                                }
                                label: {
                                    VStack(spacing: 0){
                                        ZStack{
                                            AsyncImage(url: URL(string: "\(imagesBaseURL)\(ingredient.image ?? "apple.jpg")")) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                //.frame(width:100, height: 100)
                                            } placeholder: {
                                                ProgressView()
                                                    .tint(.gray)
                                            }
                                        }
                                        Text(ingredient.name!).padding(.bottom, 10)
                                    }.frame(width: space.size.height/7, height: space.size.height/7)
                                }.padding(5).grayscale(!ingredient.inStock ? 1 : 0)
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
