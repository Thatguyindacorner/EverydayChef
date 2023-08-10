//
//  CreateRecipeView2.swift
//  CatchEmAllApp
//
//  Created by Ameya Joshi on 2023-07-16.
//

import SwiftUI
import PhotosUI

extension HorizontalAlignment{
    enum MyCustomAlignment:AlignmentID{
        static func defaultValue(in dimension: ViewDimensions) -> CGFloat {
            return dimension[HorizontalAlignment.center]
        }//defaultValue()
    }//MyCustomAlignment
    
    static let customAlignment = HorizontalAlignment(MyCustomAlignment.self)
    
}//extension

class ContentData:ObservableObject{
    //@Published var path:NavigationPath = NavigationPath()
    
    @Published var showSheet:Bool = false
    
    @Published var picture:UIImage?
}

struct CreateRecipeView2: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var fireDBController:FireDbController = FireDbController.sharedFireDBController
    
    @State private var cuisine:String = ""
    
    @State private var ingredients:String = ""
    
    @State private var recipeName:String = ""
    
    @State private var directions:String = ""
    
    @State private var inputText:String = ""
    
    @State private var horizontalOffset:CGFloat = 0
    
    @State private var verticalOffsets:CGFloat = 5
    
    @State var editing: Bool = false
    
    @ObservedObject var contentData:ContentData = ContentData()
    
    @State private var showAlert:Bool = false
    
    @State private var showImageAlert:Bool = false
    
    var ImagePickerView:ImagePicker!
    

    //@State private var selected:PhotosPickerItem?


    
    @State private var showingImagePicker = false
    
    //@StateObject var fireDBController:FireDBController = FireDBController()
    
    /*
       StepperView State
     */
    @State private var prepTime:Int = 0
    
    @State private var servesPeople:Int = 0
    
    
    /*
       State Properties to handle and display errors
     */
    @State private var errorMessage:String = ""
    
    @State private var displayErrorAlert:Bool = false
    
    
    /*
      Progress View
     */
    @State private var showProgress:Bool = false
    
    
//    init(){
////        ImagePickerView = ImagePicker(path: $contentData.path, picture: $contentData.picture)
//        ImagePickerView = ImagePicker(showSheet: $contentData.showSheet, picture: $contentData.picture)
//    }
    
    var body: some View {
        //if #available(iOS 16, *) {
        
        ZStack{
            
            ScrollView{
                VStack{
                    //Text("Create Recipe")
                        //.font(.system(size: 24).bold())
                    
                    Group{
                        
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
                            Image(uiImage: contentData.picture ?? UIImage(named: "nopicture")!)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(12)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 400, maxHeight: 450)
                        }//VStack
                    }//Image Group
                    
                    //Alert for Saving Picture
                    .alert("Save Picture", isPresented: $showAlert) {
                        
                        Button("Cancel", role: .cancel){
                            showAlert = false
                        }
                        
                        Button("Save", role: .none){
                            if let picture = contentData.picture{
                                
                                UIImageWriteToSavedPhotosAlbum(picture, nil, nil, nil)
                                
                                showAlert = false
                            }// if let
                        }
                        
                    } message: {
                        Text("Do you want to Store the Picture in the Photos Library?")
                    }//showAlert
                    
                    
                    
                    Group{
                        
                        if #available(iOS 16, *){
                            TextField("Enter Recipe Name", text: $recipeName, axis: .vertical)
                                .modifier(RecipeTFModifiers(paddingValue: 20.0, lineLimitVal: 5))
                            
                            TextField("Enter Cuisine", text: $cuisine, axis: .vertical)
                                .modifier(RecipeTFModifiers(paddingValue: 15.0, lineLimitVal: 5))
                        }else{
                            TextField("Enter Recipe Name", text: $recipeName)
                                .modifier(RecipeTFModifiers(paddingValue: 20.0, lineLimitVal: 5))
                            
                            TextField("Enter Cuisine", text: $cuisine)
                                .modifier(RecipeTFModifiers(paddingValue: 15.0, lineLimitVal: 5))
                        }
                        
                        TextField("Enter Ingredients e.g. sugar, eggs", text: $ingredients)
                            .modifier(RecipeTFModifiers(paddingValue: 20.0, lineLimitVal: 5))
                        
                        TextField("Enter Directions", text: $directions)
                            .modifier(RecipeTFModifiers(paddingValue: 30, lineLimitVal: 5))
                        
                        
                    }//Group
                    .padding(.top, 10)
                    
                    Group{
                        PrepTimeAndServes(prepTime: $prepTime, servesPeople: $servesPeople)
                    }//PrepTimeAndServes
                    
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
                    
                    
                    Button(action:{
                        print("Save Data to Firestore for this user")
                        //addRecipe()
                        
                        showProgress = true
                        
                        Task(priority:.background){
                            //let result =  await saveRecipeToFirestore()
                            
                            let result =  await saveRecipeToFirestore2()
                            
                            if result{
                                print("Go Back to previous Screen")
                                
                                contentData.showSheet = false
                                
                                contentData.picture = nil
                                
                                self.showProgress = false
                                
                                dismiss()
                            }//if result
                            else{
                                print("Problem uploading Data to the Cloud Firestore")
                                
                                self.showProgress = false
                                
                                self.displayErrorAlert = true
                            }
                        }//Task
                        //dismiss()
                    }){
                        Text("Save Recipe")
                            .padding(10)
                            .background(.blue)
                            .foregroundColor(.white)
                        //.bold()
                            .cornerRadius(10)
                    }
                    
                    //Display Error
                    .alert("Error", isPresented: self.$displayErrorAlert) {
                        Button("OK", role: .cancel){
                            self.displayErrorAlert = false
                        }
                    } message: {
                        Text("\(self.errorMessage)")
                    }
                    
                    
                    //Sheet
                    .sheet(isPresented: $contentData.showSheet, onDismiss: {
                        contentData.showSheet = false
                    }, content: {
                        // ImagePicker(isShown: self.$showImagePicker, uiImage: self.$uiImage)
                        
                        ImagePicker(showSheet: $contentData.showSheet, picture: $contentData.picture)
                    }) //Sheet
                    
                    //                    .onChange(of: selected) { (photosPickerItem:PhotosPickerItem?) in
                    //
                    //                        Task(priority: .background) {
                    //
                    //                            if let data = try? await photosPickerItem?.loadTransferable(type: Data.self){
                    //                               // picture = UIImage(data: data)
                    //                                contentData.picture = UIImage(data: data)
                    //                            }//if let data
                    //                        }//Task
                    
                    //                    }//onChange
                    
                    .onChange(of: contentData.picture) { uiImage in
                        
                        if let pic = uiImage{
                            contentData.picture = pic
                        }else{
                            print("Can't load Image")
                        }
                        
                    }//onChange as a result of user selecting a picture from the Gallery
                    
                    .sheet(isPresented: $showingImagePicker) {
                        CustomPhPicker(picture: $contentData.picture)
                    }
                    
                }//VStack
                .padding()
                
                //.searchable(text: .constant(""))
                
            }//ScrollView

            .navigationTitle("Create Recipe")

            
            if self.showProgress{
                ProgressView()
                    .tint(.red)
                    .scaleEffect(4)
            }
            
        }//ZStack

        //}//if iOS 16
    }//body
    
    func saveRecipeToFirestore() async -> Bool {
       
        let result = Task(priority:.background){
        
            
            let customRecipe = CustomRecipe(recipeName: self.recipeName, recipeInstructions: self.directions, recipeCuisine: self.cuisine, recipeIngredients: self.ingredients, serves: self.servesPeople, prepTime: self.prepTime)
            
           // let val = await fireDBController.saveCustomRecipes(customRecipe: customRecipe, image: contentData.picture)
            
            let val = await fireDBController.saveCustomRecipes(customRecipe: customRecipe, image: contentData.picture == nil ? UIImage(named: "nopicture") : contentData.picture)
            
            if val{
                print("Custom Recipe and Data uploaded successfully to cloud Firestore")
                
                //self.dismiss()
                
                //dismiss()
                
                return true
            }else{
                return false
            }
            
        }//Task
        
        let uploadResult = await result.value
        
        return uploadResult
    }//saveRecipeToFirestore
    
    
    
    func saveRecipeToFirestore2() async -> Bool {
       
        let result = Task(priority:.background){ () -> Bool in
        
            
            let customRecipe = CustomRecipe(recipeName: self.recipeName, recipeInstructions: self.directions, recipeCuisine: self.cuisine, recipeIngredients: self.ingredients, serves: self.servesPeople, prepTime: self.prepTime)
            
           // let val = await fireDBController.saveCustomRecipes(customRecipe: customRecipe, image: contentData.picture)
            
            do{
                let val = try await fireDBController.saveCustomRecipes2(customRecipe: customRecipe, image: contentData.picture == nil ? UIImage(named: "nopicture") : contentData.picture)
                
                
                if val{
                    print("Custom Recipe and Data uploaded successfully to cloud Firestore")
                
                    return true
                }else{
                    return false
                }
            }catch{
                print("Error Saving Custom Recipe to Firestore \(error.localizedDescription)")
                
                self.errorMessage = "Error Saving Custom Recipe. Please try again"
                
                return false
            }//catch
            
            
        }//Task
        
        let uploadResult = await result.value
        
        return uploadResult
    }//saveRecipeToFirestore2
    
}//struct CreateRecipeView2

struct PrepTimeAndServes:View{
    
    @Binding var prepTime:Int
    
    @Binding var servesPeople:Int
    
    var body: some View{
        
        VStack(alignment:.customAlignment){
            
            HStack(spacing:20){
                
                HStack {
                    Text("Prep Time:\(prepTime.formatted(.number.precision(.fractionLength(0)))) Minutes")
                    
                    Image(systemName: "timer.circle.fill")
                        .foregroundColor(.blue)
                }//Inner VStack
        
                Stepper("", value: $prepTime, in: 0...200)
                    .labelsHidden()
                Spacer()
            }//HStack
            //.padding(.horizontal, 8)
            .padding(.bottom, 10)
            //.border(.blue)
            
            
            HStack(spacing:20){
                
                HStack {
                    Text("Serves: \(servesPeople.formatted(.number.precision(.fractionLength(0))))")
                    
                    Image(systemName: "person.2.fill")
                        .foregroundColor(.blue)
                }//Inner VStack
        
                Stepper("", value: $servesPeople, in: 0...20)
                    .labelsHidden()
//                    .alignmentGuide(.customAlignment) { dimension in
//                        dimension[HorizontalAlignment.center] - 7
//                    }
                Spacer()
            }//HStack
           // .padding(.horizontal, 8)
            //.border(.yellow)
           
            
        }//VStack
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding(.top, 10)
        //.border(.black)
        //.padding(.horizontal, 7)
        
        
    }//body
}//PrepTimeAndServe


struct CreateRecipeView2_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 16, *) {
            NavigationStack{
                CreateRecipeView2().environmentObject(FireDbController.sharedFireDBController)
            }
        }
        
    }
}//CreateRecipeView2 Preview


/*
 Custom Alignment Test
 */



struct PrepTimeAndServes_Previews:PreviewProvider{
    static var previews: some View{
        if #available(iOS 16, *){
            NavigationStack{
                PrepTimeAndServes(prepTime: .constant(0), servesPeople: .constant(0))
            }
        }
    }
}
