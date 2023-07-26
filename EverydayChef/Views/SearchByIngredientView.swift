//
//  SearchByIngredientView.swift
//  EverydayChef
//
//  Created by Alex Olechnowicz on 2023-07-10.
//

import SwiftUI

extension Bool{
    func toColor() -> Color{
        switch self{
        case true:
            return Color.green
        case false:
            return Color.clear
        }
    }
}

struct SearchByIngredientView: View {
    
    @State var ingredient: AutocompleteIngredient

    @State var inventory: [AutocompleteIngredient]
    
    @State var imagesBaseURL: String = "https://spoonacular.com/cdn/ingredients_100x100/"
    
    @StateObject var recipeViewModel: SearchRecipeByIngredientViewModel = SearchRecipeByIngredientViewModel()
    
    @State var additionalIngredients: [AutocompleteIngredient] = []
    
    @State var catagory: Int = 1
    
    @State var produceList: [AutocompleteIngredient] = []
    @State var proteinList: [AutocompleteIngredient] = []
    @State var dairyList: [AutocompleteIngredient] = []
    @State var otherList: [AutocompleteIngredient] = []
    
    var body: some View {
        GeometryReader{ space in
            
            VStack{
                Text("Main Ingredient").bold()
                VStack{
                    AsyncImage(url: URL(string: "\(imagesBaseURL)\(ingredient.image ?? "apple.jpg")")) { image in
                        image
                            .resizable()
                            .scaledToFit()
                        //.frame(width:100, height: 100)
                    } placeholder: {
                        ProgressView()
                            .tint(.gray)
                    }
                    Text(ingredient.name ?? "N/A")
                }.frame(height: space.size.height/7)
                
                
                Text("Additional Ingredients").bold()
                
//                if !additionalIngredients.isEmpty{
//                    Text("Additional Ingredients").bold()
//                    ScrollView(.horizontal){
//                        LazyHStack{
//                            ForEach(additionalIngredients, id: \.id) { item in
//                                //Text(item.name ?? "N/A")
//                                VStack{
//                                    AsyncImage(url: URL(string: "\(imagesBaseURL)\(item.image ?? "apple.jpg")")) { image in
//                                        image
//                                            .resizable()
//                                            .scaledToFit()
//                                        //.frame(width:100, height: 100)
//                                    } placeholder: {
//                                        ProgressView()
//                                            .tint(.gray)
//                                    }
//                                    Text(item.name ?? "N/A")
//                                }
//                                .frame(width: space.size.height/7)
//                            }
//                        }
//                    }.frame(height: space.size.height/7)
//                }
                
                
//                Picker("", selection: $catagory){
//                    Text("Produce").tag(.produce)
//                    Text("Meat/Seafood").tag(.meat)
//                    Text("Dairy").tag(.dairy)
//                    Text("Other").tag(.other)
//                }
                
                Picker("", selection: $catagory) {
                    Text("Produce").tag(1)
                    Text("Meat/Seafood").tag(2)
                    Text("Dairy").tag(3)
                    Text("Other").tag(0)
                }.pickerStyle(.segmented)
                
                switch catagory{
                case 1:
                    addIngredientsToSearchDisplay(list: produceList).padding(.horizontal, 10).frame(height: space.size.height/7)
                case 2:
                    addIngredientsToSearchDisplay(list: proteinList).padding(.horizontal, 10).frame(height: space.size.height/7)
                case 3:
                    addIngredientsToSearchDisplay(list: dairyList).padding(.horizontal, 10).frame(height: space.size.height/7)
                default:
                    addIngredientsToSearchDisplay(list: otherList).padding(.horizontal, 10).frame(height: space.size.height/7)
                }

                
                NavigationLink(destination: RecipeDetailView(randomRecipeViewModel: RandomRecipeViewModel(), recipe: recipeViewModel.recipeData), isActive: $recipeViewModel.goToRecipe) {
                }
                
                Button(action:{
                    Task{
                        await recipeViewModel.searchRecipesWith(ingredients: self.additionalIngredients, mainIngredient: self.ingredient)
                    }
                }){
                    Text("What can I make with this?")
                }.padding(10).border(.blue)
                    .disabled(!recipeViewModel.allRecipes.isEmpty).padding(.top, 10)
                
                Toggle("Include Recipes with missing Ingredients?", isOn: $recipeViewModel.includeRecipesWithMissingIngredients)
                    .onChange(of: recipeViewModel.includeRecipesWithMissingIngredients) { newValue in
                        Task{
                            await recipeViewModel.filterRecipes(newValue: newValue)
                        }
                    }
                
                if !recipeViewModel.allRecipes.isEmpty{
                    ScrollView(.horizontal){
                        LazyHStack{
                            ForEach(recipeViewModel.results, id: \.id) { recipe in
                                //Text(item.name ?? "N/A")
                                
                                Button(action:{
               
                                    Task{
                                        self.recipeViewModel.recipeData = await recipeViewModel.getRecipeById(id: recipe.id ?? 404)
                                        self.recipeViewModel.goToRecipe = true
                                    }
                                    
                                }){
                                    VStack{
                                        AsyncImage(url: URL(string: recipe.image ?? "\(imagesBaseURL) apple.jpg")) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                            //.frame(width:100, height: 100)
                                        } placeholder: {
                                            ProgressView()
                                                .tint(.gray)
                                        }
                                        
                                        Text(recipe.title ?? "Strawberry Ice Cream")
                                            .font(.title).bold()
                                            .foregroundColor(.blue)
                                            .lineLimit(1)

                                        if recipeViewModel.isInStock(result: recipe, ingredientState: ingredient.inStock, inventory: inventory){
                                            Text("All ingredients in stock")
                                                .font(.caption)
                                                .foregroundColor(.green)
                                                .lineLimit(1)
                                        }
                                        else{
                                            Text("Some ingredients are out of stock")
                                                .font(.caption)
                                                .foregroundColor(.red)
                                                .lineLimit(1)
                                        }
                                        
                                    }.frame(width: space.size.width)
                                }//.grayscale(!recipeViewModel.isInStock(result: recipe, ingredientState: ingredient.inStock, inventory: inventory) ? 1 : 0)
                                
                                
                                //.frame(height: space.size.height/4)
//                                    VStack{
//                                        AsyncImage(url: URL(string: recipe?.image ?? "")) { image in
//                                            image
//                                                .resizable()
//                                                .scaledToFit()
//                                                .cornerRadius(12)
//                                        } placeholder: {
//                                            Image("norecipe")
//                                                .resizable()
//                                                .scaledToFit()
//
//                                        }
//
//                                        VStack{
//
//                                            Text(recipe?.title ?? "Strawberry Ice Cream")
//                                                //.font(.title.weight(.bold))
//                                                .foregroundColor(.green)
//                                                .lineLimit(1)
//
//                                            if recipeViewModel.isInStock(result: recipe, ingredientState: ingredient.inStock, inventory: inventory){
//                                                Text("All ingredients in stock")
//                                                    //.font(.caption.weight(.bold))
//                                                    .foregroundColor(.green)
//                                                    .lineLimit(1)
//                                            }
//                                            else{
//                                                Text("Some ingredients are out of stock")
//                                                    //.font(.caption.weight(.bold))
//                                                    .foregroundColor(.green)
//                                                    .lineLimit(1)
//                                            }
//                                        }
//                                    }
                                    //.background(.yellow)
                                    .cornerRadius(12)
                                    .shadow(color: .gray.opacity(0.5), radius: 8, x: 0, y: 5)
                                
                                
                            }
                        }
                    }//.frame(height: space.size.height/4)
                }
                
                
                
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
//                    }
//
//                }
                
            }
            
        }.padding(.horizontal, 10)
        .onAppear{
            Task{
                if produceList.isEmpty && proteinList.isEmpty && dairyList.isEmpty && otherList.isEmpty{
                    
                    self.inventory = await FireDbController.getInventory()
                    inventory.remove(at: inventory.firstIndex(where: { item in
                        return item.id == ingredient.id
                    })!)
                    
                    for item in inventory{
                        switch item.aisle{
                        case "Produce":
                            produceList.append(item)
                        case "Meat":
                            proteinList.append(item)
                        case "Seafood":
                            proteinList.append(item)
                        case "Milk, Eggs, Other Dairy":
                            dairyList.append(item)
                        case "Cheese":
                            dairyList.append(item)
                        default:
                            otherList.append(item)
                        }
                    }
                    
                }
                
            }
            
        }
    }
    
    @ViewBuilder
    func addIngredientsToSearchDisplay(list: [AutocompleteIngredient]) -> some View{
        
        ScrollView(.horizontal){
            LazyHStack{
                ForEach(list, id: \.id) { item in
                    //Text(item.name ?? "N/A")
                    Button(action:{
                        if !additionalIngredients.contains(where: { ingredient in
                            return ingredient.id == item.id
                        }){
                            additionalIngredients.append(item)
                        }
                        else{
                            additionalIngredients.remove(at: additionalIngredients.firstIndex(where: { ingredient in
                                return ingredient.id == item.id
                            })!)
                        }
                        recipeViewModel.allRecipes = []
                        recipeViewModel.filteredRecipes = []
                        recipeViewModel.results = []
                    }){
                        VStack{
                            AsyncImage(url: URL(string: "\(imagesBaseURL)\(item.image ?? "apple.jpg")")) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                //.frame(width:100, height: 100)
                            } placeholder: {
                                ProgressView()
                                    .tint(.gray)
                            }
                            Text(item.name ?? "N/A")
                        }.background(additionalIngredients.contains(where: { ingredient in
                            return ingredient.id == item.id
                        }).toColor())
                    }
                    
                }
            }
        }
        
//        List{
//            ForEach(list, id: \.id) { item in
//                Button(action:{
//                    if !additionalIngredients.contains(where: { ingredient in
//                        return ingredient.id == item.id
//                    }){
//                        additionalIngredients.append(item)
//                    }
//                    else{
//                        additionalIngredients.remove(at: additionalIngredients.firstIndex(where: { ingredient in
//                            return ingredient.id == item.id
//                        })!)
//                    }
//                })
//                {
//                    Text(item.name ?? "N/A")
//                }.background(additionalIngredients.contains(where: { ingredient in
//                    return ingredient.id == item.id
//                }).toColor())
//
//            }
//        }
    }
    
}

//struct SearchByIngredientView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchByIngredientView()
//    }
//}
