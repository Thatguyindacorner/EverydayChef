//
//  ImagePickerCoordinator.swift
//  LearningCameraUse
//
//  Created by Ameya Joshi on 2023-07-11.
//

import Foundation
import SwiftUI

class ImagePickerCoordinator:NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
   // @Binding var path:NavigationPath
    
    @Binding var showSheet:Bool
    
    @Binding var picture:UIImage?
    
//    init(path:Binding<NavigationPath>, picture: Binding<UIImage?>){
    init(showSheet:Binding<Bool>, picture: Binding<UIImage?>){
        
        //self._path = path
        self._showSheet = showSheet
        
        self._picture = picture
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let newPicture = info[.originalImage] as? UIImage{
            
            picture = newPicture
            
        }//if let newPicture
        else{
            print("No Picture found")
        }
    
        //path = NavigationPath()
        self.showSheet = false
    }//func imagePickerController
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //path = NavigationPath()
        self.showSheet = false
    }
    
}
