//
//  CustomRecipeListView.swift
//  EverydayChef
//
//  Created by Ameya Joshi on 2023-06-19.
//

import SwiftUI

struct CustomRecipeListView: View {
    
    @EnvironmentObject var fireDBController:FireDbController
    
    @State private var showSheet:Bool = false
    
    @State private var editCustomRecipe:CustomRecipe?
    
    @GestureState var press = false
    
    
    var body: some View {
      
            
            VStack{
                
                Text("Custom Recipes")
  
                                            
                        List{
                            
                            ForEach(fireDBController.userRecipeList, id: \.self){ customRecipe in
                                
                                Text("\(customRecipe.recipeName)")
//                                    .onTapGesture {
//                                        editCustomRecipe = customRecipe
//                                    }
                                    .gesture(
                                        LongPressGesture(minimumDuration: 0.7)
                                            .updating($press, body: { currentState, gestureState, transaction in
                                                gestureState = currentState
                                            })
                                            .onEnded({ value in
                                                editCustomRecipe = customRecipe
                                                
                                            })
                                    )
                                
                            }
                            .onDelete { indexSet in
                                deleteRecord(indexSet: indexSet)
                            }
                            
                            
                        }//List
                        .listStyle(.plain)
                
                        .sheet(item: $editCustomRecipe) { item in
                            EditCustomRecipeSheet(customRecipe: item)
                        }
  
            }//VStack
            .onAppear{
                Task{
                    
                    fireDBController.userRecipeList = []
                    
                    await fireDBController.getAllCustomRecipes()
                    
                    print(fireDBController.userRecipeList)
                }
            }
            
            .navigationTitle(Text("Custom Recipes"))
            .navigationBarTitleDisplayMode(.inline)
        
    }
    
    
    
    
    func deleteRecord(indexSet:IndexSet){
        
        Task(priority:.background){
            for index in indexSet{
                await fireDBController.deleteRecipe(recipeDocId: fireDBController.userRecipeList[index].id ?? "")
                
                print("Record Deleted")
            }
        }
    }
}

struct CustomRecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        
        if #available(iOS 16.0, *) {
            NavigationStack{
                CustomRecipeListView().environmentObject(FireDbController.sharedFireDBController)
            }
        }
    }
}
