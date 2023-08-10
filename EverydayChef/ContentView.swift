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
    
    @State var spoonVerified = false
    @State var inApp = true
    
    @State var disableToolbar = false
    
    @State var currentTab: Tabs = .inventory
    
    @State var upgrade: Bool = false
    
    //inventory tab toolbar variables
    @State var showingSettings: Bool = false
    @State var currentStorageType: StorageLocation = .fridge
    @State var inShoppingList: Bool = false
    @State var addIngredient: Bool = false
    @State var showPopup: Bool = false
    let popupTitle: String  = "How would you like to add an ingredient?"
    
    @State var hideToolbar: Bool = false
    
    
    @EnvironmentObject var session: SessionData
    
    var body: some View {
        
        if SessionData.shared.userAccount?.isActivated ?? false  || session.loggedInUser?.isAnonymous ?? false{
            
            ZStack{
                NavigationView{
                    //
                    TabView(selection: $currentTab) {
                        
                        InventoryTab(
                            inShoppingList: $inShoppingList,
                            addIngredient: $addIngredient,
                            currentStorageType: $currentStorageType).tabItem {
                            
                            Image(systemName: "cabinet")
                            Text("Inventory")
                        }.tag(Tabs.inventory)
                            .confirmationDialog(popupTitle, isPresented: $showPopup, titleVisibility: .visible,
                            actions: {
                                
                                
//                                Button("With Camera"){
//                                    print("Not available yet")
//                                }
                                
                                
                                Button(action: {
                                    addIngredient = true
                                })
                                {
                                    Text(("With Keyboard"))
                                }
                            })
                        
//                        HistoryTab().tabItem {
//                            Image(systemName: "calendar")
//                            Text("History")
//                        }.tag(Tabs.history)
                        
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
                            }.disabled(disableToolbar)
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
                                .onTapGesture {
                                    if !disableToolbar{
                                        disableToolbar = true
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
                                    showPopup = true
                                }){
                                    Image(systemName: "plus")
                                }.disabled(disableToolbar)
                                
                                
//                                Button(action:{
//                                    //shopping list
//                                    inShoppingList = true
//                                }){
//                                    Image(systemName: "cart")
//                                }.disabled(disableToolbar)
                                
                                
                            case .history:
                                Text("")
                            
                            case .recipes:
                                NavigationLink {
                                    ShowFavoriteRecipesView()
                                } label: {
                                    Image(systemName: "suit.heart")
                                }
                            }
                            


                        }
                    }
                    
                    .navigationBarTitleDisplayMode(.inline)
                    
                    //.navigationBarHidden(true)
                    //.navigationBarBackButtonHidden(true)
                }//.navigationViewStyle(.stack)
                    SidebarProfileView(isSidebarVisable: $showingSettings, sidebarHidden: $hideToolbar, upgrade: $upgrade)
                }//}
            .overlay{
                if disableToolbar{
                    Color.black.opacity(0.1)
                        .ignoresSafeArea(.all)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onTapGesture {
                            disableToolbar = false
                        }
                }
                
            }

            
            //.navigationBarTitleDisplayMode(.inline)
            
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        
        
        else{
            ScrollView{
                VStack{
                    Spacer()
                    
                    Text("Awaiting Verification of Spoonacular Account")
                    ProgressView().tint(.gray)
                    
                    Link("Check Mail App", destination: URL(string: "message://")!)
                    
                    HStack{
                        Button(action:{
                            //check both
                            Task{
                                let spoonAccount = await AuthController.spoonacularAccountCall(email: SessionData.shared.loggedInUser!.email!, type: .login)
                                
                                guard spoonAccount != nil
                                else{
                                    print("error with spoon login")
                                    return
                                }
                                
                                if spoonAccount!.activated == 1
                                {
                                    print("account is activated")
                                    //reset password & update db & store apiKey
                                    
                                    do{
                                        try await SessionData.shared.document?.updateData(["isActivated" : true, "apiKey" : spoonAccount!.apiKey!])
                                    }
                                    catch{
                                        print("couldn't update document")
                                    }
                                    
                                    
                                    if await AuthController.resetSpoonPassword(email: SessionData.shared.loggedInUser!.email!){
                                        
                                        if await AuthController.storeAccount(){
                                            print("stored account")
                                            print("showing app now")
                                        }
                                        else{
                                            print("could not access Firebase Account and store details")
                                        }
                                        
                                        
                                    }
                                    else{
                                        print("could not reset password")
                                    }
                                    
                                    
                                }
                                else{
                                    print("fail")
                                }
                                
                            }
                        }){
                            Text("I have verified my account")
                        }
                        
                        
                    }
                    Button(action:{
                        Task{
                            await AuthController.signOut()
                        }
                    }){
                        Text("Sign Out")
                    }
                    
                    Spacer()
                }
            }.navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
        }
            
    }
    
    @ViewBuilder
    func StorageOption(_ loc: StorageLocation) -> some View{
        if loc != currentStorageType{
            Button(action:{
                currentStorageType = loc
                self.disableToolbar = false
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
