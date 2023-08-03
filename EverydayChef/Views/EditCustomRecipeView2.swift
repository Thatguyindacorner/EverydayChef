//
//  EditCustomRecipeView2.swift
//  CatchEmAllApp
//
//  Created by Ameya Joshi on 2023-07-25.
//

import SwiftUI

struct EditCustomRecipeView2: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var recipeName:String = ""
    
    @State private var cuisine:String = ""
    
    @State private var ingredients:String = ""
    
    @State private var directions:String = ""
    
    @State private var prepTime:Int = 0
    
    @State private var servesPeople:Int = 0
    
    @ObservedObject var contentData:ContentData = ContentData()
    
    @State private var showAlert:Bool = false
    
    @State private var showImageAlert:Bool = false
    
    @State private var showingImagePicker = false
    
    //@StateObject var fireDBController:FireDBController = FireDBController()
    
    @EnvironmentObject var fireDBController:FireDbController
    
    var customRecipe:CustomRecipe?
    
    @Binding var customRecipeList:[CustomRecipe]
    
    var body: some View {
        ScrollView{
            VStack{
                
                HStack{
                    Button("Save Picture"){
                        print("Save Picture to the Photos Album")
                        showAlert = true
                    }
                    .disabled(contentData.picture == nil ? true : false)
                    
                    Spacer()
                    
                    Button("Get Picture"){
                        print("Show Alert to take a picture or select a picture from Photo Gallery")
                        showImageAlert = true
                    }
                    
                }//HStack
                
                AsyncImage(url: URL(string: customRecipe?.imageURLString ?? "Unknown")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 400, maxHeight: 450)
                } placeholder: {
                    Image(uiImage: UIImage(named: "nopicture")!)
                }

                
//                Image(uiImage: contentData.picture ?? UIImage(named: "nopicture")!)
//                    .resizable()
//                    .scaledToFit()
//                    .cornerRadius(12)
//                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 400, maxHeight: 450)
//
                
                RecipeDetails1(recipeName: $recipeName, cuisine: $cuisine, ingredients: $ingredients, directions: $directions)
                
                PrepTimeAndServes(prepTime: $prepTime, servesPeople: $servesPeople)
                
                Button {
                    print("Update Recipe")
                    
                    Task(priority:.background){
                        
                        let result = await updateRecipe()
                        
                        if result{
                            dismiss()
                        }else{
                            print("Error while updating Custom Recipe")
                        }
                        
                    }//Task
                    
                } label: {
                    Text("Update Recipe")
                        .padding()
                        .padding(.horizontal, 15)
                        .background(.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        //.fontWeight(.bold)
                }
                .padding()

                .alert("Select Option", isPresented: $showImageAlert) {
                    Button("Photo Gallery", role: .none){
                        print("Show Photo Gallery")
                        showingImagePicker = true
                    }
//                        PhotosPicker(selection:$selected, matching: .images, photoLibrary:.shared()){
//                            Text("Photo Gallery")
//                        }//PhotosPicker
                    
                    Button("Camera", role: .none){
                        print("Show ImagePicker on the Sheet")
                        contentData.showSheet = true
                    }
                    
                    Button("Cancel", role: .cancel){
                        showImageAlert = false
                    }
                    
                }//showImageAlert
                
                
                .sheet(isPresented: $showingImagePicker) {
                    CustomPhPicker(picture: $contentData.picture)
                }//Sheet for showingImagePicker
                
                
                .onChange(of: contentData.picture) { uiImage in
                    
                    if let pic = uiImage{
                        contentData.picture = pic
                    }else{
                        print("Can't load Image")
                    }
                    
                }//onChange as a result of user selecting a picture from the Gallery
                
                //Sheet
                .sheet(isPresented: $contentData.showSheet, onDismiss: {
                    contentData.showSheet = false
                }, content: {
                    // ImagePicker(isShown: self.$showImagePicker, uiImage: self.$uiImage)
                    
                    ImagePicker(showSheet: $contentData.showSheet, picture: $contentData.picture)
                }) //Sheet
                
            }//VStack
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
          
            .onAppear{
                recipeName = customRecipe?.recipeName ?? "Edit Recipe Name"
                
                cuisine = customRecipe?.recipeCuisine ?? "Edit Cuisine"
                
                ingredients = customRecipe?.recipeIngredients ?? "Edit Ingredients"
                
                directions = customRecipe?.recipeInstructions ?? "Edit Instructions"
                
                prepTime = customRecipe?.prepTime ?? 0
                
                servesPeople = customRecipe?.serves ?? 0
                
            }//onAppear Main VStack
            
        }//ScrollView
    }//body
    
    func updateRecipe() async -> Bool{
        
        let result = Task(priority:.background){ () -> Bool in
            
            //var val = false
            
            var returnedVal:(Bool, CustomRecipe?)
            
            
            let customRecipeToUpdate = CustomRecipe(id: customRecipe?.id ?? "Unknown", imageURLString: contentData.picture == nil ? customRecipe?.imageURLString ?? "" : "Update",  recipeName: self.recipeName, recipeInstructions: self.directions, recipeCuisine: self.cuisine, recipeIngredients: self.ingredients, serves: self.servesPeople ,prepTime: self.prepTime)
            
            if let updatedPic = contentData.picture{
                returnedVal = await fireDBController.updateCustomRecipe2(customRecipe: customRecipeToUpdate, image: contentData.picture)
            }else{
                print("Image not updated")
                
                returnedVal = await fireDBController.updateCustomRecipe2(customRecipe: customRecipeToUpdate, image: nil)
                
            }
            
            if returnedVal.0{
                print("Custom Recipe and Data uploaded successfully to cloud Firestore")
                
                //self.dismiss()
                
                //dismiss()
                
                if let index = customRecipeList.firstIndex(where: { custRecipe in
                    custRecipe.id == returnedVal.1?.id ?? "Unknown"
                }){
                    customRecipeList[index] = returnedVal.1 ?? customRecipeToUpdate
                    return true
                }//if let
                else{
                   print("No Custom Recipes with matching IDs found")
                    return false
                }// if else
            
            }else{
                return false
            }
            
        }//Task
        
        let uploadResult = await result.value
        
        return uploadResult
    }//update Recipe
    
    
}//struct EditCustomRecipeView2

struct RecipeDetails1:View{
    
    @Binding var recipeName:String
    
    @Binding var cuisine:String
    
    @Binding var ingredients:String
    
    @Binding var directions:String
    
    var body: some View{
        
        VStack{
            Group{
                
                if #available(iOS 16, *){
                    TextField("Enter Recipe Name", text: $recipeName, axis: .vertical)
                        .modifier(RecipeTFModifiers(paddingValue: 20.0, lineLimitVal: 5))
                    
                    TextField("Enter Cuisine", text: $cuisine, axis: .vertical)
                        .modifier(RecipeTFModifiers(paddingValue: 15.0, lineLimitVal: 5))
                }//if iOS16
                else{
                    TextField("Enter Recipe Name", text: $recipeName)
                        .modifier(RecipeTFModifiers(paddingValue: 20.0, lineLimitVal: 5))
                    
                    TextField("Enter Cuisine", text: $cuisine)
                        .modifier(RecipeTFModifiers(paddingValue: 15.0, lineLimitVal: 5))
                }//if not iOS16
            
                TextField("Enter Ingredients e.g. sugar, eggs", text: $ingredients)
                    .modifier(RecipeTFModifiers(paddingValue: 20.0, lineLimitVal: 5))
                
                TextField("Enter Directions", text: $directions)
                    .modifier(RecipeTFModifiers(paddingValue: 30, lineLimitVal: 5))
                
            }//Group
            .padding(.top, 10)
        }
    }//body
}//struct RecipeDetails1

struct RecipeDetails2:View{
    
    var body: some View{
        VStack{
            
        }//VStack
    }//body
}//RecipeDetails2

struct EditCustomRecipeView2_Previews: PreviewProvider {
    static var previews: some View {
        EditCustomRecipeView2(customRecipeList: .constant([])).environmentObject(FireDbController.sharedFireDBController)
    }
}
