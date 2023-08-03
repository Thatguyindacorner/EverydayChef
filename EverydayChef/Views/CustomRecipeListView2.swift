//
//  CustomRecipeListView2.swift
//  EverydayChef
//
//  Created by Ameya Joshi on 2023-07-24.
//

import SwiftUI

struct CustomRecipeListView2: View {
    
    @EnvironmentObject var fireDBController:FireDbController
    
    @State private var customRecipeList:[CustomRecipe] = []
    
    @State private var editCustomRecipe:CustomRecipe?
    
    @GestureState var press = false
    
    var body: some View{
        VStack{
            Text("Custom Recipes")
            
            List{
                
                ForEach(customRecipeList){ customRecipe in
                    LazyVStack{
                        NavigationLink {
                            CustomRecipeDetailView(customRecipe: customRecipe)
                        } label: {
                            CustomRecipeCardView(customRecipe: customRecipe)

                                .swipeActions(allowsFullSwipe: false, content: {
                                    
                                    Button("Edit"){
                                        editCustomRecipe = customRecipe
                                    } //Edit Button
                                    .tint(.blue)
                                    
                                    Button("Delete", role: .destructive){
                                        print("Delete custom recipe")
                                        
                                        Task(priority:.background){
                                            let result = await deleteCustRecipe(customRecipe)

                                            if result{
                                                print("Custom Recipe deleted from Firestore")

                                                //customRecipesList.remove(atOffsets: indexSet)

                                                if let index = customRecipeList.firstIndex(where: { $0.id == customRecipe.id }){
                                                    customRecipeList.remove(at: index)
                                                }else{
                                                    print("Item not found. Cannot delete custom recipe")
                                                }//if let
                                                    
                                            }else{
                                                print("Error while deleting Custom Recipe from Firestore")
                                            }
                                        }//Task
                                        
                                    }//Delete Button
                                    
                                })//swipeActions
                            
                            
                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                .listRowSeparator(.hidden, edges: .all)
                                .listRowBackground(Color(white: 1.0))
                                .padding(.vertical, 10)
                               
                            
                            
                        }//NavigationLink Label
                    }//LazyVStack

                }//ForEach
//                .onDelete { indexSet in
//                    print("Delete the CustomRecipe from Firebase Firestore and Cloud Firestore")
//
//                    var recipeToDelete:CustomRecipe?
//
//                    Task(priority:.background){
//                        for index in indexSet{
//
//                            recipeToDelete = customRecipeList[index]
//
//                            let result = await deleteCustRecipe(recipeToDelete)
//
//                            if result{
//                                print("Custom Recipe deleted from Firestore")
//
//                                customRecipeList.remove(atOffsets: indexSet)
//
//
//                            }else{
//                                print("Error while deleting Custom Recipe from Firestore")
//                            }
//
//                        }//for
//
//                    }//Task
//
//                }//onDelete
                
                
            }//List
            .listStyle(.plain)
            
            
            /*
              Display Sheet to edit the Custom Recipe
             */
            .sheet(item: $editCustomRecipe) { item in
                EditCustomRecipeView2(customRecipe: item, customRecipeList: self.$customRecipeList)
            }//Sheet to display the Edit View
            
        }//VStack
        .onAppear{
            Task(priority:.background){
                customRecipeList = await fireDBController.getCustomRecipes()
                
                if customRecipeList.count > 0{
                    print("Custom Recipes Fetched from the Database")
                }//if count > 0
            }//Task
        }//onAppear
    }//body
    
    func deleteCustRecipe(_ custRecipe:CustomRecipe?) async -> Bool{
        
        let taskResult = Task(priority:.background){ () -> Bool in
         
            let result = await fireDBController.deleteCustomRecipe(customRecipe: custRecipe)
         
            return result
        }
        
        let deleteResult = await taskResult.value
        
        return deleteResult
    }//func deleteCustRecipe
    
    
}//struct CustomRecipeListView2

struct CustomRecipeListView2_Previews: PreviewProvider {
    static var previews: some View {
        CustomRecipeListView2().environmentObject(FireDbController.sharedFireDBController)
    }
}
