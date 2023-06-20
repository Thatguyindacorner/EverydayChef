//
//  CreateRecipeView.swift
//  EverydayChef
//
//  Created by Ameya Joshi on 2023-06-19.
//

import SwiftUI

struct CreateRecipeView: View {
    
    @EnvironmentObject var fireDBController:FireDbController
    
    @State private var cuisine:String = ""
    
    @State private var ingredients:String = ""
    
    @State private var recipeName:String = ""
    
    @State private var directions:String = ""
    
    var body: some View {
        if #available(iOS 16.0, *) {
            ScrollView{
                VStack{
                    Text("Create Recipe")
                        .font(.system(size: 24).bold())
                    
                    Group{
                        TextField("Enter Recipe Name", text: $recipeName, axis: .vertical)
                            .modifier(RecipeTFModifiers(paddingValue: 20.0, lineLimitVal: 5))
                        
                        TextField("Enter Cuisine", text: $cuisine, axis: .vertical)
                            .modifier(RecipeTFModifiers(paddingValue: 15.0, lineLimitVal: 5))
                        
                        TextField("Enter Ingredients e.g. sugar, eggs", text: $ingredients)
                            .modifier(RecipeTFModifiers(paddingValue: 20.0, lineLimitVal: 5))
                        
                        TextField("Enter Directions", text: $directions)
                            .modifier(RecipeTFModifiers(paddingValue: 30, lineLimitVal: 5))
                            
                        
                    }//Group
                    .padding(.top, 10)
                    
                    Button(action:{
                        print("Save Data to Firestore for this user")
                        addRecipe()
                    }){
                        Text("Save Recipe")
                            .padding(10)
                            .background(.blue)
                            .foregroundColor(.white)
                            .bold()
                            .cornerRadius(10)
                    }
                    
                }//VStack
                .padding()
                
            }//ScrollView
        }
    }//body
    
    func addRecipe(){
        Task{
            
            let customRecipe = CustomRecipe(recipeName: self.recipeName, recipeInstructions: self.directions, recipeCuisine: self.cuisine, recipeIngredients: self.ingredients)
            
          let result =  await fireDBController.saveRecipeToFirestore(customRecipe: customRecipe)
            
          print(result)
        }
    }
    
}

struct RecipeTFModifiers:ViewModifier{
    
    let paddingValue:CGFloat
    
    let lineLimitVal:Int
    
    
    init(paddingValue: CGFloat, lineLimitVal:Int) {
        self.paddingValue = paddingValue
        self.lineLimitVal = lineLimitVal
    }
    
    func body(content: Content) -> some View {
        content
            .textFieldStyle(CustomTextFieldStyle(setPadding: paddingValue))
            .lineLimit(self.lineLimitVal)
            .padding(.bottom, 10)
//            .textFieldStyle(.roundedBorder)
//            .frame(height: 48)
//            .lineLimit(5)
//            .padding(.bottom, 10)
    }
    
}

public struct CustomTextFieldStyle : TextFieldStyle {
    
    let setPadding:CGFloat
    
    init(setPadding: CGFloat) {
        self.setPadding = setPadding
    }
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
        //.font(.largeTitle) // set the inner Text Field Font
            .padding(setPadding) // Set the inner Text Field Padding
        //Give it some style
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(Color.primary.opacity(0.5), lineWidth: 0.5))
    }
}

struct CreateRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 16.0, *) {
            NavigationStack{
                CreateRecipeView().environmentObject(FireDbController.sharedFireDBController)
            }
        }
    }
}
