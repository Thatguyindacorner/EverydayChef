//
//  CreateRecipeView.swift
//  EverydayChef
//
//  Created by Ameya Joshi on 2023-06-19.
//

import SwiftUI

struct CreateRecipeView: View {
    
    @State private var cuisine:String = ""
    
    var body: some View {
        if #available(iOS 16.0, *) {
            ScrollView{
                VStack{
                    Text("Create Recipe")
                        .font(.system(size: 24).bold())
                    
                    TextField("Enter Cuisine", text: $cuisine, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(3)
                    
                    
                    
                }//VStack
                .padding()
                
            }//ScrollView
        }
    }//body
}

struct CreateRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 16.0, *) {
            NavigationStack{
                CreateRecipeView()
            }
        }
    }
}
