//
//  RandomRecipeView.swift
//  CatchEmAllApp
//
//  Created by Ameya Joshi on 2023-06-13.
//

import SwiftUI

struct RandomRecipeView: View {
    
    @StateObject var randomRecipeViewModel:RandomRecipeViewModel = RandomRecipeViewModel()
    
    @State private var recipeSearch:String = ""
    
    @State var regularSearch: Bool = true
    @State var results: [FoundRecipesByIngredients] = []
    @State var goToRecipe = false
    @State var recipeData:Recipe? = nil
    @State var imagesBaseURL: String = "https://spoonacular.com/cdn/ingredients_100x100/"
    
    @EnvironmentObject var firedbController:FireDbController
    
    var body: some View {
       // NavigationStack{
            VStack{
                
                VStack {
                    TextField("Search Recipes", text: $recipeSearch)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .textFieldStyle(.roundedBorder)
                    
                    Button(action:{
                        self.regularSearch = true
                        print("Perform Recipe Search Action")
                        searchRecipe()
                    }){
                        Text("Search")
                            .padding()
                            .padding(.horizontal, 15)
                            .background(.brown)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
//                    HStack{
//                        Button(action:{
//                            Task{
//                                self.regularSearch = false
//                                print("Search What can I make now")
//                                self.results = await SearchRecipeByIngredientViewModel.readyToMakeRecipes()
//                            }
//
//                        }){
//                            Text("What can I make now?")
//                                .padding()
//                                .padding(.horizontal, 15)
//                                .background(.brown)
//                                .foregroundColor(.white)
//                                .cornerRadius(10)
//                        }
//                        Button(action:{
//                            self.regularSearch = true
//                            print("Perform Recipe Search Action")
//                            searchRecipe()
//                        }){
//                            Text("Search")
//                                .padding()
//                                .padding(.horizontal, 15)
//                                .background(.brown)
//                                .foregroundColor(.white)
//                                .cornerRadius(10)
//                        }
//                    }
                    
                    
                }
                
                ScrollView(){
                    
                    if regularSearch{
                        LazyVStack{
                    
                            ForEach(randomRecipeViewModel.recipeList, id: \.self){ recipe in
                                
                                NavigationLink {
                                    RecipeDetailView(randomRecipeViewModel: randomRecipeViewModel, recipe: recipe).environmentObject(firedbController)
                                } label: {
                                    RecipeCardView(recipe: recipe)
                                        .padding(.vertical, 10)
                                }
                            }//ForEach
                        }
                    
                    }//LazyVStack
//
//                    else{
//                        LazyVStack{
//                            ForEach (results, id: \.id){ recipe in
//
//                                Button(action:{
//
//                                    Task{
//                                        self.recipeData = await SearchRecipeByIngredientViewModel().getRecipeById(id: recipe.id ?? 404)
//                                        self.goToRecipe = true
//                                    }
//
//                                }){
//                                    VStack{
//                                        NavigationLink(destination: RecipeDetailView(randomRecipeViewModel: randomRecipeViewModel, recipe: recipeData), isActive: $goToRecipe) {
//                                        }
//                                        AsyncImage(url: URL(string: recipe.image ?? "\(imagesBaseURL) apple.jpg")) { image in
//                                            image
//                                                .resizable()
//                                                .scaledToFit()
//                                            //.frame(width:100, height: 100)
//                                        } placeholder: {
//                                            ProgressView()
//                                                .tint(.gray)
//                                        }
//
//                                        Text(recipe.title ?? "Strawberry Ice Cream")
//                                            .font(.title).bold()
//                                            .foregroundColor(.blue)
//                                            .lineLimit(1)
//
//
//
//                                    }.background(.white)
//                                        .cornerRadius(12)
//                                        .shadow(color: .gray.opacity(0.5), radius: 8, x: 0, y: 5)
//                                }
//
//
////                                NavigationLink {
////                                    RecipeDetailView(randomRecipeViewModel: randomRecipeViewModel, recipe: recipe).environmentObject(firedbController)
////                                } label: {
////                                    RecipeCardView(recipe: recipe)
////                                        .padding(.vertical, 10)
////                                }
//                            }
//                        }
//                    }
                    
                    
                }//ScrollView
                
//                List{
//
//                    ForEach(randomRecipeViewModel.recipeList, id: \.self){ recipe in
//                        VStack(alignment:.leading){
//                            Text(recipe.title ?? "Unknown")
//
//                            AsyncImage(url: URL(string: recipe.image!), content: {image in
//                                image
//                                    .resizable()
//                                    .scaledToFill()
//                                    .frame(maxWidth:100, maxHeight: 100)
//                                    .cornerRadius(16)
//                                    .shadow(radius: 8, x: 5, y:5)
//
//                            }) {
//                                RoundedRectangle(cornerRadius: 10)
//                                    .foregroundColor(.clear)
//                                    .frame(maxWidth: 100, maxHeight: 100)
//                            }
//
////                            Image(recipe.image!)
////                                .resizable()
////                                .scaledToFit()
////                                .frame(width: 100, height: 100)
//                        }
//                    }
//
//                }//List
//                .listStyle(.plain)
                
            }//VStack
            .padding(.horizontal, 10)
            .onAppear{
                Task{
                    await randomRecipeViewModel.getRandomRecipes()
                }
            }
            .navigationTitle(Text("Random Recipes"))
      //  }//NavStack
        
    }//body
    
    func searchRecipe(){
        Task(priority:.background){
           await randomRecipeViewModel.searchRecipes(searchTerm:recipeSearch)
        }
    }
}

//struct RandomRecipeView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack{
//            RandomRecipeView()
//        }
//    }
//}
