//
//  ImagePicker.swift
//  LearningCameraUse
//
//  Created by Ameya Joshi on 2023-07-11.
//

import Foundation
import SwiftUI

struct ImagePicker:UIViewControllerRepresentable{
    
    //@Binding var path:NavigationPath
    
    @Binding var showSheet:Bool
    
    @Binding var picture:UIImage?
    
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = context.coordinator
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            imagePickerController.sourceType = .camera
            
            imagePickerController.mediaTypes =  ["public.image"]
            
            imagePickerController.allowsEditing = false
            
            imagePickerController.cameraCaptureMode = .photo
            
        }//if camera available
        else{
            print("The Media is not available")
        }
            
        return imagePickerController
        
    }//makeUIViewController
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> ImagePickerCoordinator {
        //ImagePickerCoordinator(path: $path, picture: $picture)
        ImagePickerCoordinator(showSheet: $showSheet, picture: $picture)
    }//func makeCoordinator
    
    
}
