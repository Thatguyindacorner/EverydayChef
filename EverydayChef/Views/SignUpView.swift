//
//  SignUpView.swift
//  EverydayChef
//
//  Created by Ameya Joshi on 2023-06-19.
//

import SwiftUI

struct SignUpView: View {
    
    @State private var userFName:String = ""
    
    @State private var userLName:String = ""
    
    var body: some View {
        ScrollView{
            VStack{
                TextField("Enter First Name*", text: $userFName)
                    .padding(12)
                    .background(.white)
                    .keyboardType(.namePhonePad)
                    .overlay{
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.2), lineWidth: 1)

                    }
                
                TextField("Enter Last Name*", text: $userLName)
                    .padding(12)
                    .background(.white)
                    .keyboardType(.namePhonePad)
                    .overlay{
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.2), lineWidth: 1)

                    }
                
                
                
            }//VStack
            .padding()
        }//ScrollView
    }//body
    
    //Function to validate Email Address
    func textFieldValidatorEmail(for emailAdd: String) -> Bool {
        if emailAdd.count > 100 {
            return false
        }
        let emailRegex = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
    
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        
        return emailPredicate.evaluate(with: emailAdd)
    }//textFieldValidatorEmail
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
