//
//  AddIngredientView.swift
//  EverydayChef
//
//  Created by Alex Olechnowicz on 2023-06-21.
//

import SwiftUI

struct IngredientView: View{
    
    @State var ingredient: AutocompleteIngredient//? = nil
    //@State var name: String = ""
    @State var inventory: [AutocompleteIngredient]
    
    @State var storagePlace: StorageLocation = .fridge
    @State var imagesBaseURL: String = "https://spoonacular.com/cdn/ingredients_100x100/"
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var recipeViewModel: SearchRecipeByIngredientViewModel = SearchRecipeByIngredientViewModel()
    
    var body: some View {
        GeometryReader{ space in
            
//            NavigationLink(destination: RecipeDetailView(randomRecipeViewModel: RandomRecipeViewModel(), recipe: recipeViewModel.recipeData), isActive: $recipeViewModel.goToRecipe) {
//            }
            
            VStack(alignment: .center){
                //Image(systemName: "photo").resizable()
                AsyncImage(url: URL(string: "\(imagesBaseURL)\(ingredient.image ?? "apple.jpg")")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                    //.frame(width:100, height: 100)
                } placeholder: {
                    ProgressView()
                        .tint(.gray)
                }.frame(height: space.size.height / 5)
                Text(ingredient.name ?? "N/A")
                Toggle(isOn: $ingredient.inStock) {
                    Text("In Stock")
                }.onChange(of: ingredient.inStock) { newValue in
                    if !newValue{
                        self.ingredient.inFreezer = false
                    }
                }
                Toggle(isOn: $ingredient.inFreezer) {
                    Text("In Freezer")
                }
                Text("Catagory: \(ingredient.aisle ?? "N/A")")
//                Picker(selection: $storagePlace){
//                    Text(StorageLocation.fridge.rawValue).tag(StorageLocation.fridge)
//                    Text(StorageLocation.pantry.rawValue).tag(StorageLocation.pantry)
//                    Text(StorageLocation.bar.rawValue).tag(StorageLocation.bar)
//                }.pickerStyle(.segmented)
//                switch storagePlace {
//                case .fridge:
//                    <#code#>
//                case .pantry:
//                    <#code#>
//                case .bar:
//                    <#code#>
//                }
                
                NavigationLink{
                    SearchByIngredientView(ingredient: ingredient, inventory: inventory)
                } label: {
                    
                    Text("Recipes with \(ingredient.name ?? "ingredient")")
                        .padding(10).border(.blue)
                }
                
                
//                Button(action:{
//                    Task{
//                        //ProgressView()
//                        await recipeViewModel.searchRecipesWith(ingredient: ingredient)
//                    }
//                }){
//                    Text("What can I make with this?")
//                }.padding(10).border(.blue)
//                    .disabled(!recipeViewModel.allRecipes.isEmpty)
                
                
//                Toggle("Include Recipes with missing Ingredients?", isOn: $recipeViewModel.includeRecipesWithMissingIngredients)
//                    .onChange(of: recipeViewModel.includeRecipesWithMissingIngredients) { newValue in
//                    Task{
//                        await recipeViewModel.filterRecipes(newValue: newValue)
//                    }
//                }
//                
//                List{
//                    ForEach(recipeViewModel.results, id: \.id){ recipe in
//
//                        Button(action:{
//                            Task{
//                                self.recipeViewModel.recipeData = await recipeViewModel.getRecipeById(id: recipe.id ?? 404)
//                                self.recipeViewModel.goToRecipe = true
//                            }
//                            
//                        }){
//                            AsyncImage(url: URL(string: recipe.image ?? "\(imagesBaseURL) apple.jpg")) { image in
//                                image
//                                    .resizable()
//                                    .scaledToFit()
//                                //.frame(width:100, height: 100)
//                            } placeholder: {
//                                ProgressView()
//                                    .tint(.gray)
//                            }.frame(height: space.size.height / 10)
//                            Text(recipe.title ?? "N/A")
//                        }.grayscale(!recipeViewModel.isInStock(result: recipe, ingredientState: ingredient.inStock, inventory: inventory) ? 1 : 0)
                
                
                
                        
//                        NavigationLink{
//                            RecipeDetailView(randomRecipeViewModel: RandomRecipeViewModel(), recipe: recipeViewModel.recipes.first(where: { thing in
//                                return thing.id == recipe.id
//                            }))
//                        } label:{
//                            AsyncImage(url: URL(string: recipe.image ?? "\(imagesBaseURL) apple.jpg")) { image in
//                                image
//                                    .resizable()
//                                    .scaledToFit()
//                                //.frame(width:100, height: 100)
//                            } placeholder: {
//                                ProgressView()
//                                    .tint(.gray)
//                            }.frame(height: space.size.height / 10)
//                            Text(recipe.title ?? "N/A")
//                        }
                        
                 //   }
                    
                //}
                
                Spacer()
            }.padding(35).frame(width: space.size.width, height: space.size.height)
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing){
                Button(action:{
                    //edit
                    Task(priority: .background){
                        if await FireDbController.hasIngredient(ingredient){
                            print("saving")
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        
                    }
                }){
                    Text("Save")
                }
            }
        }
    }
}

struct AddIngredientView: View {
    
    @StateObject var ingredientViewModel: IngredientSearchViewModel = IngredientSearchViewModel()
    
    @EnvironmentObject var session: SessionData
    
    @State var selected = false
    @State var selectedIngredient: AutocompleteIngredient? = nil
    
    @State var message: String = ""
    @State var showConfirmation = false
    
    var body: some View {
        
        VStack{
            
            
            
            if ingredientViewModel.results.isEmpty {
                Text("No Results")
            }
            else{
                if showConfirmation && !selected{
                    loadPopup()
                }
                List{
                    
                    ForEach(ingredientViewModel.results, id: \.id){result in
                        Button(action:{
                            Task(priority: .background){
                                if await !FireDbController.hasIngredient(result){
                                    selected = true
                                    selectedIngredient = result
                                }
                                else{
                                    message = "\(result.name?.capitalized ?? "This ingredient") is already in your inventory"
                                    showConfirmation = true
                                }
                            }
                        }){
                            Text(result.name ?? "N/A")
                        }.disabled(showConfirmation)

                        
                    }
                    
                }
                Spacer()
            }
            
        }
        .alert(isPresented: $selected, content: {
            Alert(title: Text(selectedIngredient?.name ?? "N/A"),
                  message: Text("Add Ingredient to Inventory?"),
                  primaryButton: .default(Text("Yes")){
                Task(priority: .background){
                        await FireDbController.addIngredient(selectedIngredient!)
                        
                    message = "\(selectedIngredient?.name?.capitalized ?? "This ingredient") has been added to your inventory"
                    
                    
                    
                    selectedIngredient = nil
                    showConfirmation = true
                    
                    
                    
                        
                    }

            },
                  secondaryButton: .default(Text("No")){
                message = "\(selectedIngredient?.name?.capitalized ?? "This ingredient") has NOT been added to your inventory"
                
                    selectedIngredient = nil
                showConfirmation = true
            })
        })
        .onChange(of: ingredientViewModel.query) { newValue in
            Task(priority: .background){
                await ingredientViewModel.searchFor()
            }
        }
        .navigationTitle("Ingredient Search")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $ingredientViewModel.query)
        
//        .toolbar {
//            ToolbarItemGroup(placement: .navigationBarTrailing){
//                Button(action:{
//
//                }){
//                    Text("Custom")
//                }
//            }
//        }
        
    }
    
    func addIngredient() async{
        // success msg
        // error msg
        
        
        
        selectedIngredient = nil
    }
    
    @ViewBuilder
    func loadPopup() -> some View{
        //Text("?????")
        RoundedRectangle(cornerRadius: 2).opacity(0.1)
            .overlay {
                Text(message).foregroundColor(.black).bold().multilineTextAlignment(.center)
                //RoundedRectangle(cornerRadius: 2)//.background(.black).opacity(0.1)
            }.frame(maxHeight: 100)
            .onAppear{
            print("showing")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                showConfirmation = false
            }
        }
        
    }
}

struct AddIngredientView_Previews: PreviewProvider {
    static var previews: some View {
        AddIngredientView()
    }
}
