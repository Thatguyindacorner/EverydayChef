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
    
    
    @State private var errorMessage:String = ""
    
    @State private var displayErrorAlert:Bool = false
    
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

                    HStack{
                        Button(action:{
                            Task{
                                self.regularSearch = false
                                print("Search What can I make now")
                                self.results = await SearchRecipeByIngredientViewModel.readyToMakeRecipes()
                            }
                            
                        }){
                            Text("What can I make now?")
                                .padding()
                                .padding(.horizontal, 15)
                                .background(.brown)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        Button(action:{
                            self.regularSearch = true
                            print("Perform Recipe Search Action")
                            //searchRecipe()
                            
                            Task(priority:.background){
                                
                                do{
                                    
                                    try validateEmptyFields()
                                    
                                    let result = await searchRecipe2()
                                    
                                    if result{
                                        print("Successfully found Search Results")
                                        
                                        randomRecipeViewModel.showProgressView = false
                                        
                                    }else{
                                        
                                        print("Error while getting Search Results or unable to search for Recipes")
                                        
                                        randomRecipeViewModel.showProgressView = false
                                        
                                        self.displayErrorAlert = true
                                        
                                        
                                    }//if result false
                                    
                                    
                                }catch(let err){
                                    
                                    print("Error: \(err.localizedDescription)")
                                    
                                    self.errorMessage = err.localizedDescription
                                    
                                    randomRecipeViewModel.showProgressView = false
                                    
                                    self.displayErrorAlert = true
                                    
                                }//catch
                                
                                
                                
//                                let result = await searchRecipe2()
//
//                                if result{
//                                    print("Successfully found Search Results")
//                                }else{
//
//                                    print("Error while getting Search Results or unable to search for Recipes")
//
//                                    self.displayErrorAlert = true
//
//                                }//if result false
                                
                            }//Task
                            
                        }){
                            Text("Search")
                                .padding()
                                .padding(.horizontal, 15)
                                .background(.brown)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

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
                
                ZStack{
                    ScrollView(){
                        
                        if regularSearch && randomRecipeViewModel.recipeList.count <= 0{
                            NoDataView()
                        }else if !regularSearch && results.count <= 0{
                            NoIngredientsRecipesView()
                        } else{
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
                                }//LazyVStack
                                
                            }//if regularSearch
                            
                            else{
                                LazyVStack{
                                    ForEach (results, id: \.id){ recipe in
                                        
                                        Button(action:{
                                            
                                            Task{
                                                self.recipeData = await SearchRecipeByIngredientViewModel().getRecipeById(id: recipe.id ?? 404)
                                                self.goToRecipe = true
                                            }
                                            
                                        }){
                                            VStack{
                                                NavigationLink(destination: RecipeDetailView(randomRecipeViewModel: randomRecipeViewModel, recipe: recipeData), isActive: $goToRecipe) {
                                                }
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
                                                
                                                
                                                
                                            }.background(.white)
                                                .cornerRadius(12)
                                                .shadow(color: .gray.opacity(0.5), radius: 8, x: 0, y: 5)
                                        }
                                        
                                        
                                    }
                                }
                            }
                        }//if data is not empty
                    }//ScrollView
                    
                    .alert("Error", isPresented: self.$displayErrorAlert) {
                        Button("OK", role: .cancel){
                            self.displayErrorAlert = false
                        }
                    } message: {
                        Text("\(self.errorMessage)")
                    }//alert

                    
                    if randomRecipeViewModel.showProgressView{
                        ProgressView()
                            .tint(.red)
                            .scaleEffect(4)
                    }//if randomRecipeViewModel.showProgressView
                    
                }//ZStack
               
                
                
            }//VStack
            .padding(.horizontal, 10)
            .onAppear{
                
                Task{
                    //await randomRecipeViewModel.getRandomRecipes()
                    
                    let result = await queryRandomRecipes()
                    
                    if result{
                        print("Received Random Recipe Results")
                    }else{
                       print("Unable to get Random Recipe Results")
                        self.displayErrorAlert = true
                    }
                    
                }//Task
                
            }//onAppear
            .navigationTitle(Text("Random Recipes"))
      //  }//NavStack
        
    }//body
    
    func searchRecipe(){
        Task(priority:.background){
           await randomRecipeViewModel.searchRecipes(searchTerm:recipeSearch)
        }
    } //searchRecipe
    
    /*
      Refactored Random Recipes Func
     */
    func queryRandomRecipes() async ->Bool{
        
        let randomRecipeResult = Task(priority:.background){() -> Bool in
            
            do{
                
               let result = try await randomRecipeViewModel.getRandomRecipes2()
                
               return result
                
            } catch{
                
                print("Error while getting Random Recipes \(error.localizedDescription)")
                
                self.errorMessage = error.localizedDescription
                
                return false
            }//catch
        }//randomRecipeResult
        
        let recipeResult = await randomRecipeResult.value
        
        return recipeResult
        
    }//queryRandomRecipes
    
    /*
      Refactored Search Recipes
     */
    func searchRecipe2() async -> Bool{
        
        randomRecipeViewModel.showProgressView = true
        
        let returnedSRTaskResult = Task(priority:.background){ () -> Bool in
            
            do{
                let result = try await randomRecipeViewModel.searchRecipes2(searchTerm:recipeSearch)
                
                return result
            }catch{
                print("Error while getting results for Recipes \(error.localizedDescription)")
                
                self.errorMessage = error.localizedDescription
                
                randomRecipeViewModel.showProgressView = false
                
                return false
                
            }//catch
            
        }//returnedSRTaskResult
        
        let result = await returnedSRTaskResult.value
        
        return result
    }//searchRecipes2
    
    
    func validateEmptyFields() throws{
        if self.recipeSearch.isEmpty{
            throw ErrorEnum.FieldsEmpty
        }
    }//validateEmptyFields
    
} //RandomRecipeView Struct


struct NoDataView:View{
    
    var body: some View{
        
        Text("Couldn't load Data. Please Try again")
        
    }//body

}//No Data Struct


struct NoIngredientsRecipesView:View{
    
    var body: some View{
        Text("Couldn't Load any Recipes by Ingredients. Please try again")
    }//body
    
}// NoIngredientsRecipeView

//struct RandomRecipeView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack{
//            RandomRecipeView()
//        }
//    }
//}
