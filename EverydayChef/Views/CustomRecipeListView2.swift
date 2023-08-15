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
    
    @State private var errorMessage:String = ""
    
    @State private var displayErrorAlert:Bool = false
    
    @State private var showProgress:Bool = false
    
    var body: some View{
        VStack{
            //Text("Custom Recipes")
            
            ZStack{
                
                if customRecipeList.count <= 0 {
                    NoCustRecipeView()
                }else{
                    
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
                                                    //let result = await deleteCustRecipe(customRecipe)
                                                    
                                                    let result = await deleteCustRecipe2(customRecipe)
                                                    
                                                    if result{
                                                        print("Custom Recipe deleted from Firestore")
                                                        
                                                        //customRecipesList.remove(atOffsets: indexSet)
                                                        
                                                        if let index = customRecipeList.firstIndex(where: { $0.id == customRecipe.id }){
                                                            customRecipeList.remove(at: index)
                                                        }else{
                                                            print("Item not found. Cannot delete custom recipe")
                                                            
                                                            self.errorMessage = "Error while deleting Recipe. Please try again"
                                                            
                                                            self.displayErrorAlert = true
                                                            
                                                        }//if let
                                                        
                                                    }else{
                                                        print("Error while deleting Custom Recipe from Firestore")
                                                        
                                                        self.displayErrorAlert = true
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
              
                }//if Collection is not empty
                
                if showProgress{
                    ProgressView()
                        .tint(.red)
                        .scaleEffect(4)
                }
                
            }//ZStack
            //Display Alert!
            .alert("Error", isPresented: self.$displayErrorAlert) {
                Button("OK", role: .cancel){
                    self.displayErrorAlert = false
                }
            } message: {
                Text("\(self.errorMessage)")
            }
            
            
            /*
              Display Sheet to edit the Custom Recipe
             */
            .sheet(item: $editCustomRecipe) { item in
                EditCustomRecipeView2(customRecipe: item, customRecipeList: self.$customRecipeList)
            }//Sheet to display the Edit View
            
        }//VStack

        .toolbar{
            ToolbarItemGroup(placement: .navigationBarTrailing){
                NavigationLink {
                    CreateRecipeView2()
                } label: {
                    Image(systemName: "plus")
                }
                
            }
        }
        .navigationTitle("My Recipes")
        .onAppear{
            if customRecipeList.isEmpty{
                Task(priority:.background){
//                showProgress = true
//                customRecipeList = await fireDBController.getCustomRecipes()
//
//                if customRecipeList.count > 0{
//                    print("Custom Recipes Fetched from the Database")
//                }//if count > 0
                
                
                showProgress = true
                
                let result = await getCustRecipesFromFirestore()

                if result{
                    print("Custom Recipes Fetched from Firestore")
                }else{
                    print("Error retrieving Custom Recipes from Firestore")
                }
                
                }//Task
            }

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
    
    
    func getCustRecipesFromFirestore() async -> Bool{
        
        let retrieveResult = Task(priority:.background){ () -> Bool in
            
            do{
                
                customRecipeList = try await fireDBController.getCustomRecipes2()
                
                if customRecipeList.count > 0{
                    print("Custom Recipes Fetched from the Database")
                    
                    showProgress = false
                    
                    return true
                }//if count > 0
                else{
                    
                    showProgress = false
                    return false
                }//else
                
            }catch{
                print("Error Retrieving custom recipes from FireStore \(error.localizedDescription)")
                
                self.errorMessage = "Error while retrieving Custom Recipes. Please Try Again"
                
                showProgress = false
                
                self.displayErrorAlert = true
                
                return false
            }//catch
        }//retrieveResult
        
        let result = await retrieveResult.value
        
        return result
    }//getCustomRecipesFromFirestore
    
    
    func deleteCustRecipe2(_ custRecipe:CustomRecipe?) async -> Bool{
        
        let taskResult = Task(priority:.background){ () -> Bool in
         
            do{
                
                let result = try await fireDBController.deleteCustomRecipe2(customRecipe: custRecipe)
                
                return result
            }catch{
                print("Error trying to Delete Recipe from Firestore \(error.localizedDescription)")
                
                self.errorMessage = "Error trying to delete Recipe from Firestore. Please try again"
                
                return false
            }//catch
        }//taskResult
        
        let deleteResult = await taskResult.value
        
        return deleteResult
    }//func deleteCustRecipe
    
}//struct CustomRecipeListView2


struct NoCustRecipeView:View{
    
    var body: some View{
        
        Text("No Custom Recipe Results to show")
        
    }//body
    
}//NoCustRecipeView

struct CustomRecipeListView2_Previews: PreviewProvider {
    static var previews: some View {
        CustomRecipeListView2().environmentObject(FireDbController.sharedFireDBController)
    }
}
