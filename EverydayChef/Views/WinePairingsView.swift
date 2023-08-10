//
//  WinePairingsView.swift
//  EverydayChef
//
//  Created by Ameya Joshi on 2023-06-19.
//

import SwiftUI

struct WinePairingsView: View {
    
    @State private var foodMode:FoodMode = .wine
    
    @State private var wineName:String = ""
    
    @State private var foodName:String = ""
    
    @State private var showProgress:Bool = false
    
    @StateObject var wineAndFoodViewModel:WineAndFoodViewModel = WineAndFoodViewModel()
    
    
    @State private var errorMessage:String = ""
    
    @State private var displayErrorAlert:Bool = false
    
    enum FoodMode{
        case wine
        
        case food
    }
    
    var body: some View {
        
        if #available(iOS 16.0, *) {
            
            VStack{
                
                HStack{
                    //Spacer()
                    VStack{
                        Image(systemName: "wineglass.fill")
                        
                        Text("Wine")
                    }
                    .frame(minWidth: 0, maxWidth: 200)
                    .padding(.vertical, 20)
                    .background(Color("winecolorbackground"))
                    .foregroundColor(.white)
                    .onTapGesture {
                        foodMode = .wine
                    }//onTapGesture
                    
                    Spacer()
                    
                    VStack{
                        Image(systemName: "fork.knife.circle.fill")
                        Text("Food")
                    }
                    .frame(minWidth: 0, maxWidth: 200)
                    .padding(.vertical, 20)
                    .background(Color.yellow)
                    .onTapGesture {
                        foodMode = .food
                    }//onTapGesture
                    
                    // Spacer()
                }//HStack
                
                ZStack{
                    
                    Group{
                        
                        if foodMode == .wine{
                            
                            WineView(foodName: $foodName, wineAndFoodViewModel: wineAndFoodViewModel, showProgress: $showProgress, errorMessage: self.$errorMessage, displayErrorAlert: self.$displayErrorAlert)
                            
                        }else{
                            //FoodView(wineName: $wineName)
                            FoodView(wineName: $wineName, wineAndFoodViewModel:wineAndFoodViewModel, showProgress: $showProgress, errorMessage: self.$errorMessage, displayErrorAlert: self.$displayErrorAlert)
                        }
                    }//Group
                    
                    if showProgress{
                        ProgressView()
                            .tint(.red)
                            .scaleEffect(4)
                    }
                    
                }//ZStack
                .alert("Error", isPresented: self.$displayErrorAlert) {
                    Button("OK", role: .cancel){
                        self.displayErrorAlert = false
                    }
                } message: {
                    Text("\(self.errorMessage)")
                }
                
                Spacer()
                
            }//VStack main
            .padding()
            .navigationTitle(Text("Wine/Food Pairing"))
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color("navbarcolor"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            
        }//if IOS 16 and UP
    }//body
}//struct WinePairingsView


struct WineView:View{
    
    @Binding var foodName:String
    
    @ObservedObject var wineAndFoodViewModel:WineAndFoodViewModel
    
    @Binding var showProgress:Bool
    
    @FocusState var nameIsFocused:Bool
    
    @Binding var errorMessage:String
    
    @Binding var displayErrorAlert:Bool
    
    var body: some View{
        
            VStack{
                Text("Find a Wine that goes well with food")
                
                TextField("Enter dish/ingredient/cuisine", text: $foodName)
                    .textFieldStyle(.roundedBorder)
                    .modifier(TFModifiers())
                    .focused($nameIsFocused)
                
                Text("Food can be dish name, e.g. steak, an ingredient name e.g. salmon, or cuisine e.g. italian")
                    .font(.caption)
                
                Button {
                    print("Search Wine using API")
                    
                    do{
                        showProgress = true
                        
                        try validateEmptyFields()
                        
                        nameIsFocused = false
                        searchWine()
                        
                    }catch(let err){
                        
                        showProgress = false
                        
                        print("Error while searching for Wine \(err.localizedDescription)")
                        
                        self.errorMessage = err.localizedDescription
                        
                        self.displayErrorAlert = true
                        
                    }//catch
                    
                    
                } label: {
                    Text("Search Wine")
                        .padding()
                        .padding(.horizontal, 15)
                        .background(.red)
                        .foregroundColor(.white)
                        //.bold()
                        .cornerRadius(12)
                } //Button
                
                Group{
                    if wineAndFoodViewModel.winesList.count == 0{
                        
                        //Text(wineAndFoodViewModel.winePairingText)
                        
                        Text("No Wine Data to Show. Please enter a dish name, e.g. steak, an ingredient name e.g. salmon, or cuisine e.g. italian")
                        
                    }else{
                        Text("Paired Wines")
                            .font(.system(size: 19).weight(.semibold))
                        Text("Click on the Wine to get more Information")
                            .font(.caption)
                        
                        HStack{
                            List{
                                ForEach(wineAndFoodViewModel.winesList, id: \.self){wine in
                                    VStack{
                                        Text(wine)
                                    }//Stack
                                }//ForEach
                            }//List
                            .listStyle(.plain)
                            
                            Group{
                                
                                if wineAndFoodViewModel.wineProducts.count == 0 {
                                    EmptyView()
                                }else{
                                    
                                    VStack(spacing:0){
                                        Text("Recomended Wines")
                                            .font(.caption.bold())
                                        
                                        ScrollView{
                                            LazyVStack{
                                                ForEach(wineAndFoodViewModel.wineProducts, id: \.self){wineProduct in
                                                    
                                                    VStack {
                                                        
                                                        Text(wineProduct.description ?? "Unknown")
                                                        
                                                        Text(wineProduct.title ?? "Unknown")
                                                        
                                                        AsyncImage(url: URL(string: wineProduct.imageUrl ?? "none")) { image in
                                                            image
                                                                .resizable()
                                                                .scaledToFit()
                                                                .frame(width:100, height:100)
                                                        } placeholder: {
                                                            ProgressView()
                                                                .scaleEffect(4)
                                                                .tint(.red)
                                                        }//AsyncImage
                                                    }//VStack

                                                    
                                                }
                                            }
                                        }
                                    }
                                }//else
                            }//Group
                        }//HStack--experimental
                        ScrollView{
                            Text("Wine Information")
                                .font(.system(size: 20).bold())
                            Text(wineAndFoodViewModel.wineInfo)
                        }//ScrollView
                        
                    }//else
                }//Group
                
            }//VStack
        
    }//body
    
    func searchWine(){
        Task(priority:.background){
            
            //showProgress = true
            
            let result = await wineAndFoodViewModel.findWine(for: foodName)
            
            
            if result == true{
                print("Found Wine")
                showProgress = false
            }else{
                print("No Results Found")
                showProgress = false
            }
            
        }//Task
    }//func searchWine()
    
    func validateEmptyFields() throws{
        
        if foodName.isEmpty{
            throw ErrorEnum.FieldsEmpty
        }// if foodName Text Empty
            
    }//validateEmptyFields
    
    
}//WineView Struct


struct FoodView:View{
    
    @Binding var wineName:String
    
    @ObservedObject var wineAndFoodViewModel:WineAndFoodViewModel
    
    @Binding var showProgress:Bool
    
    @FocusState var nameIsFocused:Bool
    
    @Binding var errorMessage:String
    
    @Binding var displayErrorAlert:Bool
    
    var body: some View{
        VStack{
            Text("Find a Dish that goes well with a Wine")
            
            TextField("Enter wine type e.g. merlot", text: $wineName)
                .textFieldStyle(.roundedBorder)
                .modifier(TFModifiers())
                .focused($nameIsFocused)
            
            Text("Required* The type of wine that should be paired, e.g merlot, riesling, etc.")
                .font(.caption)
            
            Button {
                print("Search Food")
                
                do{
                    
                    showProgress = true
                    
                    try validateEmptyFields()
                    
                    nameIsFocused = false
                    
                    findFoods()
                }catch(let err){
                    
                    showProgress = false
                    
                    print("Error while searching for Wine \(err.localizedDescription)")
                    
                    self.errorMessage = err.localizedDescription
                    
                    self.displayErrorAlert = true
                }//catch
                
//                nameIsFocused = false
//
//                findFoods()
            } label: {
                Text("Search Food")
                    .padding()
                    .padding(.horizontal, 15)
                    .background(.cyan)
                    .foregroundColor(.white)
                    //.fontWeight(.bold)
                    .cornerRadius(12)
            }//Button
            
            Group{
                
                if wineAndFoodViewModel.foodList.count == 0{
                    
                    //Text("OOOOOOps.....")
                    
                    //Text(wineAndFoodViewModel.foodText)
                    
                    Text("No Food Data to Show. Please enter the type of wine that should be paired, e.g merlot, riesling, etc.")
                    
                }//if
                else{
                    
                    List{
                        
                        ForEach(wineAndFoodViewModel.foodList, id: \.self){foodName in
                            NavigationLink {
                                WineRecipesView(dishName: foodName)
                            } label: {
                                Text(foodName)
                                    .bold()
                            }
                        }//ForEach
                        
                    }//List
                    .listStyle(.plain)
                    
                }//else
            }//Group

            
        }//VStack
    }//body
    
    func findFoods(){
        Task(priority:.background){
            
            wineAndFoodViewModel.foodList = []
            
            wineAndFoodViewModel.foodText = ""
            
            let result = await wineAndFoodViewModel.findFood(for: wineName.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))
            
            if result{
                print("Found Foods")
                showProgress = false
            }else{
                print("Error Procesing Request")
                showProgress = false
            }
        }
    }//findFoods
    
    
    func validateEmptyFields() throws{
        
        if wineName.isEmpty{
            throw ErrorEnum.FieldsEmpty
        }// if foodName Text Empty
            
    }//validateEmptyFields
    
}//FoodView



struct TFModifiers:ViewModifier{
    
    func body(content: Content) -> some View {
        content
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
    }
    
}//TFModifiers

struct WinePairingsView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 16.0, *) {
            NavigationStack{
                WinePairingsView()
            }
        }
    }
}
