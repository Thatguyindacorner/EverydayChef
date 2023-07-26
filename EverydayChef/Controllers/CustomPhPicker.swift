//
//  CustomPhPicker.swift
//  CatchEmAllApp
//
//  Created by Ameya Joshi on 2023-07-17.
//

import Foundation
import SwiftUI
import PhotosUI


struct CustomPhPicker:UIViewControllerRepresentable{
    
    //@Binding var selected:PhotosPickerItem?
    
    @Binding var picture:UIImage?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        
        picker.delegate = context.coordinator
        
        return picker
        
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator:NSObject, PHPickerViewControllerDelegate{
        
        let parent:CustomPhPicker
        
        init(_ parent:CustomPhPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else {
                print("No Photo selected")
                return
            }
            
            if provider.canLoadObject(ofClass: UIImage.self){
                
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    
                    //self.parent.picture = image as? UIImage
                    
                    Task(priority:.background){

                        await MainActor.run {
                            self.parent.picture = image as? UIImage

                        }
                        
//                        if let image = image as? UIImage{
//
//                            await self.setImage(image:image)
//
//
//                        }else{
//                            print("Can't typecast into UIImage")
//                        }
                    }//Task
                    
                    
                }//provider.loadObject
                
            }//if canLoadObject
            
            
        }//func picker
        
        
    }//class Coordinator
}
