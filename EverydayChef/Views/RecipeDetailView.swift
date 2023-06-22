//
//  RecipeDetailView.swift
//  CatchEmAllApp
//
//  Created by Ameya Joshi on 2023-06-13.
//

import SwiftUI

struct RecipeDetailView: View {
    
    @ObservedObject var randomRecipeViewModel:RandomRecipeViewModel
    
    var recipe:Recipe?
    
    var summaryString:String? {
        
        get async{
            let summaryStr = recipe?.summary ?? "Unknown"
            
            return summaryStr.stripOutHtml()
        }
        
    }
    
    @State private var showSummary:String = ""
    
    var body: some View {
        
        //if #available(iOS 16.0, *) {
            ScrollView{
                
                VStack{
                    
                    
                    AsyncImage(url: URL(string: recipe?.image ?? "norecipe")) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .cornerRadius(12)
                    } placeholder: {
                        ProgressView()
                            .tint(.red)
                            .scaleEffect(2)
                    }
                    .padding(.bottom, 20)
                    
                    HStack{
                        Text("\(recipe?.title ?? "")")
                            .lineLimit(2)
                        
                        Text("|")
                        
                        Text("Prep Time: \(recipe?.readyInMinutes ?? 45)")
                    }
                    .font(.caption.bold())
                    //.bold()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.bottom, 5)
                    .padding()
                    .background(.yellow)
                    .cornerRadius(12)
                    
                    VStack{
                        Text("Ingredients")
                            .font(.title)
                            .bold()
                        Divider()
                        
                        
                        ScrollView(.horizontal){
                            LazyHStack(alignment:.center, spacing: 5){
                                
                                
                                ForEach(recipe?.extendedIngredients ?? [], id: \.self){ extendedIngredient in
                                    
                                    VStack(spacing:4){
                                        AsyncImage(url: URL(string: "https://spoonacular.com/cdn/ingredients_100x100/" + (extendedIngredient.image ?? "apple.jpg") )) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                            //.frame(width:100, height: 100)
                                        } placeholder: {
                                            ProgressView()
                                                .tint(.gray)
                                        }
                                        
                                        Text(extendedIngredient.name ?? "Unknown")
                                        
                                    }//Inner VStack
                                    
                                    
                                }//ForEach
                            }
                            .frame(height:120)
                            
                        }//Inner ScrollView
                        
                        VStack(alignment:.leading){
                            ForEach(recipe?.extendedIngredients ?? [], id: \.self){ extendedIngredient in
                                Text("* \(extendedIngredient.original ?? "Unknown")")
                            }//Ingredient Name For Each
                        }//Group

                                            Group{
                                                VStack{
                                                    Text("Summary")
                                                        .font(.title.bold())
                                                        //.bold()

                                                    Text(showSummary)
                                                }
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 10)
                                                .background(.yellow)
                                            }
                                            .background(.white)
                                            .cornerRadius(12)
                                            .shadow(color: .gray.opacity(0.5), radius: 8, x: 0, y: 5)
                                            .frame(minWidth:0, maxWidth:.infinity)
                                            //.padding(.horizontal, 2)
                                            .padding(.vertical, 8)
                    }//Ingredients VStack
                    
//                    Group{
//                        VStack{
//                            Text("Summary")
//                                .font(.title.bold())
//                                //.bold()
//
//                            Text(summaryString ?? "Unknown")
//                        }
//                        .padding(.horizontal, 10)
//                        .padding(.vertical, 10)
//                        .background(.yellow)
//                    }
//                    .background(.white)
//                    .cornerRadius(12)
//                    .shadow(color: .gray.opacity(0.5), radius: 8, x: 0, y: 5)
//                    .frame(minWidth:0, maxWidth:.infinity)
//                    //.padding(.horizontal, 2)
//                    .padding(.vertical, 8)
                    
                    VStack{
                        HStack{
                            Spacer()
                            Text("Instructions")
                                .font(.title)
                                .bold()
                                .padding()
                            Spacer()
                        }
                        
                        Divider()
                        
                        ForEach(recipe?.analyzedInstructions[0].steps ?? [], id:\.self){ step in
                            
                            VStack(alignment:.leading, spacing: 5){
                                
                                HStack(alignment:.top){
                                    VStack(alignment:.leading){
                                        Text("\(step.number ?? 0)")
                                            .bold()
                                            .padding()
                                        Spacer()
                                    }
                                    
                                    VStack(alignment:.leading){
                                        Text("\(step.step ?? "")")
                                            .fixedSize(horizontal: false, vertical: true)
                                            .padding()
                                        Spacer()
                                    }
                                }//HStack
                                
                                //TODO: Ingredients Info and Image
                                Group{
                                    if step.ingredients.count > 0{
                                        HStack{
                                            Spacer()
                                            Text("Related Ingredients")
                                                .font(.system(size: 18).weight(.semibold))
                                                .padding(.bottom, 8)
                                            Spacer()
                                        }
                                        
                                        ScrollView(.horizontal){
                                            LazyHStack{
                                                ForEach(step.ingredients, id:\.self){ingredient in
                                                    VStack{
                                                        AsyncImage(url: URL(string: "https://spoonacular.com/cdn/ingredients_100x100/" + (ingredient.image ?? "apple.jpg") )) { image in
                                                            image
                                                                .resizable()
                                                                .scaledToFit()
                                                            //.frame(width:100, height: 100)
                                                        } placeholder: {
                                                            ProgressView()
                                                                .tint(.gray)
                                                        }
                                                        
                                                        Text(ingredient.name ?? "Unknown")
                                                        
                                                    }//Inner VStack
                                                    .padding(.horizontal, 7)
                                                }
                                            }
                                            .frame(height:120)
                                        }
                                    }//if ingredients not empty
                                }//Group
                                
                                Group{
                                    if step.equipment.count > 0{
                                        HStack{
                                            Spacer()
                                            Text("Related Equipment")
                                                .font(.system(size: 18).weight(.semibold))
                                                .padding(.bottom, 8)
                                                .padding(.top, 10)
                                            Spacer()
                                        }
                                        ScrollView(.horizontal){
                                            LazyHStack{
                                                ForEach(step.equipment, id:\.self){equipment in
                                                    VStack{
                                                        AsyncImage(url: URL(string: "https://spoonacular.com/cdn/equipment_100x100/" + (equipment.image ?? "slow-cooker.jpg") )) { image in
                                                            image
                                                                .resizable()
                                                                .scaledToFit()
                                                            //.frame(width:100, height: 100)
                                                        } placeholder: {
                                                            ProgressView()
                                                                .tint(.gray)
                                                        }
                                                        
                                                        Text(equipment.name ?? "Unknown")
                                                    }
                                                }//ForEach
                                            }
                                            .frame(height:120)
                                        }
                                    }
                                }//Group
                                
                            }//VStack Step Number and Instruction
                            .background(.white)
                            .cornerRadius(12)
                            .shadow(color: .gray.opacity(0.5), radius: 8, x: 0, y: 5)
                            .frame(minWidth:0, maxWidth:.infinity)
                            //.padding(.horizontal, 2)
                            .padding(.vertical, 8)
                            
                            
                        }//ForEach Step
                        
                    }
                    //Spacer()
                    
                }//VStack
                .padding()
                .navigationTitle(Text("Recipe Details"))
                .navigationBarTitleDisplayMode(.inline)
                
                .onAppear{
                    Task(priority:.background){
                        let summ = await summaryString
                        
                        self.showSummary = summ ?? "Unknown"
                        
                    }
                }
                
            }//ScrollView
            //.ignoresSafeArea(.all)
        //}
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 16.0, *) {
            NavigationStack{
                RecipeDetailView(randomRecipeViewModel: RandomRecipeViewModel(), recipe: Recipe(vegetarian: Optional(false), aggregateLikes: Optional(56), pricePerServing: Optional(140.42), id: 716377, title: Optional("Vegetable Rice"), readyInMinutes: Optional(45), servings: Optional(2), image: Optional("https://spoonacular.com/recipeImages/716377-556x370.jpg"), summary: Optional("If you have around <b>45 minutes</b> to spend in the kitchen, Vegetable Rice might be an awesome <b>gluten free</b> recipe to try. This main course has <b>707 calories</b>, <b>17g of protein</b>, and <b>11g of fat</b> per serving. This recipe serves 2. For <b>$1.4 per serving</b>, this recipe <b>covers 23%</b> of your daily requirements of vitamins and minerals. 56 people have made this recipe and would make it again. This recipe from Afrolems requires rice, chili powder, lemon juice, and vegetables. Overall, this recipe earns a <b>good spoonacular score of 77%</b>. Users who liked this recipe also liked <a href=\"https://spoonacular.com/recipes/wild-rice-and-brown-rice-cakes-with-roasted-vegetable-rag-186690\">Wild Rice and Brown Rice Cakes with Roasted Vegetable Ragù</a>, <a href=\"https://spoonacular.com/recipes/cauliflower-brown-rice-and-vegetable-fried-rice-1625893\">Cauliflower, Brown Rice, and Vegetable Fried Rice</a>, and <a href=\"https://spoonacular.com/recipes/cauliflower-brown-rice-and-vegetable-fried-rice-716426\">Cauliflower, Brown Rice, and Vegetable Fried Rice</a>."), instructions: "Wash and bring to boil your rice for about 10 minutes.Chop your green vegetables and set aside. Strain the water from the rice and reduce the heat. Add your vegetables, butter, lemon juice and chili powder. Chop your garlic and add to the pot of rice with your seasoning cubes. Allow steaming on low heat till the rice is soft. Serve your vegetable rice hot with any protein of your choice. ", extendedIngredients: [EverydayChef.ExtendedIngredient(aisle: Optional("Milk, Eggs, Other Dairy"), image: Optional("butter-sliced.jpg"), original: Optional("1.5 Tablespoons of melted butter"), name: Optional("butter"), amount: Optional(1.5), unit: Optional("Tablespoons")), EverydayChef.ExtendedIngredient(aisle: Optional("Spices and Seasonings"), image: Optional("chili-powder.jpg"), original: Optional("1 teaspoon of Chili powder"), name: Optional("chili powder"), amount: Optional(1.0), unit: Optional("teaspoon")), EverydayChef.ExtendedIngredient(aisle: Optional("Produce"), image: Optional("garlic.png"), original: Optional("2 cloves of garlic"), name: Optional("garlic"), amount: Optional(2.0), unit: Optional("cloves")), EverydayChef.ExtendedIngredient(aisle: Optional("Meat"), image: Optional("diced-ham.jpg"), original: Optional("Seasoning cubes"), name: Optional("seasoning cubes"), amount: Optional(2.0), unit: Optional("servings")), EverydayChef.ExtendedIngredient(aisle: Optional("Produce"), image: Optional("lemon-juice.jpg"), original: Optional("1.5 teaspoons of Lemon Juice"), name: Optional("lemon juice"), amount: Optional(1.5), unit: Optional("teaspoons")), EverydayChef.ExtendedIngredient(aisle: Optional("Pasta and Rice"), image: Optional("uncooked-white-rice.png"), original: Optional("1.5 cups of Rice"), name: Optional("rice"), amount: Optional(1.5), unit: Optional("cups")), EverydayChef.ExtendedIngredient(aisle: Optional("Produce"), image: Optional("mixed-vegetables.png"), original: Optional("2 cups of chopped green vegetables (Spinach or Ugwu)"), name: Optional("vegetables"), amount: Optional(2.0), unit: Optional("cups"))], analyzedInstructions: [EverydayChef.AnalyzedInstruction(steps: [EverydayChef.Step(number: Optional(1), step: Optional("Wash and bring to boil your rice for about 10 minutes.Chop your green vegetables and set aside. Strain the water from the rice and reduce the heat."), ingredients: [EverydayChef.Ingredient(name: Optional("vegetable"), image: Optional("mixed-vegetables.png")), EverydayChef.Ingredient(name: Optional("water"), image: Optional("water.png")), EverydayChef.Ingredient(name: Optional("rice"), image: Optional("uncooked-white-rice.png"))], equipment: []), EverydayChef.Step(number: Optional(2), step: Optional("Add your vegetables, butter, lemon juice and chili powder. Chop your garlic and add to the pot of rice with your seasoning cubes. Allow steaming on low heat till the rice is soft. "), ingredients: [EverydayChef.Ingredient(name: Optional("seasoning cube"), image: Optional("stock-cube.jpg")), EverydayChef.Ingredient(name: Optional("chili powder"), image: Optional("chili-powder.jpg")), EverydayChef.Ingredient(name: Optional("lemon juice"), image: Optional("lemon-juice.jpg")), EverydayChef.Ingredient(name: Optional("vegetable"), image: Optional("mixed-vegetables.png")), EverydayChef.Ingredient(name: Optional("butter"), image: Optional("butter-sliced.jpg")), EverydayChef.Ingredient(name: Optional("garlic"), image: Optional("garlic.png")), EverydayChef.Ingredient(name: Optional("rice"), image: Optional("uncooked-white-rice.png"))], equipment: [EverydayChef.Equipment(name: Optional("pot"), image: Optional("stock-pot.jpg"))]), EverydayChef.Step(number: Optional(3), step: Optional("Serve your vegetable rice hot with any protein of your choice. "), ingredients: [EverydayChef.Ingredient(name: Optional("vegetable"), image: Optional("mixed-vegetables.png")), EverydayChef.Ingredient(name: Optional("rice"), image: Optional("uncooked-white-rice.png"))], equipment: [])])]))
            }
        }
    }
}
