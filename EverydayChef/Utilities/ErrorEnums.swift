//
//  ErrorEnums.swift
//  EverydayChef
//
//  Created by Ameya Joshi on 2023-06-19.
//

//import Foundation

//
//  ErrorEnums.swift
//  Group13_Be4Reel
//
//  Created by Ameya Joshi on 2023-03-30.
//

import Foundation

enum ErrorEnum:Error{
    
    case FieldsEmpty
    
    case InvalidLength
    
    case InvalidEmailPattern

    case arrayEmpty
}


extension ErrorEnum:LocalizedError{
    
    
    var errorDescription: String?{
        
        switch self{
         
            
        case .FieldsEmpty:
            return NSLocalizedString("Required Fields cannot be empty", comment: "Empty Fields")
            
        case .InvalidLength:
            return NSLocalizedString("Password should be 6 or more characters", comment: "Invalid Password Length")
            
        case .InvalidEmailPattern:
            return NSLocalizedString("The Email Address you've entered is invalid. Please enter a Valid Email address", comment: "Invalid Email Pattern")
           
        case .arrayEmpty:
            return NSLocalizedString("Cannot Load Contents or this Content is unavailable. Please try again", comment: "Empty Array Results")
        }
    }
    
    
    
}
