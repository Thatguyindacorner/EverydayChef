//
//  FireDBController.swift
//  EverydayChef
//
//  Created by Ameya Joshi on 2023-06-19.
//

import Foundation
import FirebaseFirestore
import UIKit
import FirebaseStorage

@MainActor
class FireDbController:ObservableObject{
    
    @Published var userRecipeList:[CustomRecipe] = []
    
    @Published var favoriteRecipesList:[FavoriteRecipes] = []
    
    private let store = Firestore.firestore()
    
    
    static let sharedFireDBController = FireDbController()
    
    private init(){}
    
    
    func insertUser(newUserData:UserData) async throws{
        
        try await store.collection(MyConstants.COLLECTION_USERS).document(newUserData.uid).setData(newUserData.dictionary)
        
        
    }//insertNewUser
    
    func saveRecipeToFirestore(customRecipe:CustomRecipe) async -> Bool{
        let reference = SessionData.shared.document?.collection("Recipes")
        
        do{
            try await reference?.addDocument(data: customRecipe.dictionary)
            
            return true
            
        }catch{
            print("Error creating Doc in Subcollection")
            return false
        }
        
    }//saveRecipeToFirestore
    
    func updateRecipe(editedRecipe:CustomRecipe) async -> Bool{
        
        let reference = SessionData.shared.document?.collection("Recipes")
        
        do{
            try await reference?.document(editedRecipe.id!).setData(editedRecipe.dictionary)
            
            print("Record updated on Firestore")
            
        }catch{
            print("Unable to update")
            return false
        }
        
        return true
    }
    
    func getAllCustomRecipes() async {
        
        let reference = SessionData.shared.document?.collection("Recipes")
        
        reference?.addSnapshotListener({(querySnapshot, error) in
            
            guard let snapshot = querySnapshot else{
                print(#function, "Unable to retrieve data from firestore \(error?.localizedDescription ?? "")")
                return
            }
            
            snapshot.documentChanges.forEach { documentChange in
                
                do{
                    var customRecipe = try documentChange.document.data(as: CustomRecipe.self)
                    
                    let docID = documentChange.document.documentID
                    
                    customRecipe.id = docID
                    
                    let matchingIndex = self.userRecipeList.firstIndex {
                        ($0.id?.elementsEqual(docID))!
                    }
                    
                    if documentChange.type == .added{
                        self.userRecipeList.append(customRecipe)
                        
                        print("Document Added to the collection: \(customRecipe.recipeName)")
                    }//added
                    
                    if documentChange.type == .removed{
                        if matchingIndex != nil{
                            self.userRecipeList.remove(at: matchingIndex!)
                        }
                    }//removed
                    
                    if documentChange.type == .modified{
                        
                        if matchingIndex != nil{
                            self.userRecipeList[matchingIndex!] = customRecipe
                        }
                        
                    }//modified
                    
                }catch{
                    print("Error converting CustomRecipe into an Object, \(error.localizedDescription)")
                }//catch
                
            }//documentChanges
            
        })//addSnapshotListener
        
        
    }//getAllCustomRecipes
    
    
    func deleteRecipe(recipeDocId:String) async{
        
        do{
           try await SessionData.shared.document?.collection("Recipes").document(recipeDocId)
                .delete()
        }catch{
            print("Error while deleting \(error.localizedDescription)")
        }
    }//deleteRecipes
    
    func saveRecipeAsFavorite(favoriteRecipe:FavoriteRecipes) async ->Bool{
        do{
            let reference = SessionData.shared.document?.collection("FavoriteRecipes")
            
            try await reference?.addDocument(data: favoriteRecipe.dictionary)
            
            return true
        }catch{
            print("Error while Saving Favorite Recipe \(error.localizedDescription)")
            return false
        }
    }//saveRecipeAsFavorite
    
    func getAllFavoriteRecipes() async ->[FavoriteRecipes]{
        
        
        do{
            
            let reference = SessionData.shared.document?.collection("FavoriteRecipes")
            
            var favRecipesToReturn:[FavoriteRecipes] = []
            
            
            
            let snapshot = try await reference?.getDocuments()
            
            //reference?.addSnapshotListener({ (querySnapshot, error) in
            
            //            guard let snapshot = querySnapshot else{
            //                print(#function, "Unable to retrieve data from firestore \(error?.localizedDescription ?? "")")
            //                return
            //            }
            
            try snapshot?.documents.forEach({ documentSnapshot in
                var docData = try documentSnapshot.data(as: FavoriteRecipes.self)
                
                let docID = documentSnapshot.documentID
                
                docData.id = docID
                
                print(docData)
                
                favRecipesToReturn.append(docData)
            })
            return favRecipesToReturn
        }catch{
                print("Error in Operation \(error.localizedDescription)")
            return []
            }
            
//            snapshot.documentChanges.forEach { documentChange in
//
//               // do{
//                    var favoriteRecipes = try documentChange.document.data(as: FavoriteRecipes.self)
//
//                    let docID = documentChange.document.documentID
//
//                    favoriteRecipes.id = docID
//
//                    let matchingIndex = self.favoriteRecipesList.firstIndex {
//                        ($0.id?.elementsEqual(docID))!
//                    }
//
//                    if documentChange.type == .added{
//
//                        DispatchQueue.main.async {
//                            self.favoriteRecipesList.append(favoriteRecipes)
//                        }
//
//                        print("Document Added to the collection: \(favoriteRecipes.recipeId)")
//                    }//added
//
//                    if documentChange.type == .removed{
//                        if matchingIndex != nil{
//                            self.favoriteRecipesList.remove(at: matchingIndex!)
//                        }
//                    }//removed
//
//                    if documentChange.type == .modified{
//
//                        if matchingIndex != nil{
//                            self.favoriteRecipesList[matchingIndex!] = favoriteRecipes
//                        }
//
//                    }//modified
//
//                }catch{
//                    print("Error \(error.localizedDescription)")
//                }
//
//            }//snapshot.documentChanges
            
       // })//addSnapshotListener
        
    }//getAllFavoriteRecipes
    
    
    func deleteFavoriteRecipe(favoriteRecipes:FavoriteRecipes) async ->Bool{
        do{
            
            guard let recipeIDToDelete = favoriteRecipes.id else{
                print("No ID Found for this Favorite Recipe")
                
                return false
            }
            
            try await SessionData.shared.document?.collection("FavoriteRecipes")
                .document(recipeIDToDelete)
                .delete()
            
            return true
        }catch{
            print("Error deleting record: \(error.localizedDescription)")
            return false
        }
    }
    
    
    
    static func getInventory() async -> [AutocompleteIngredient]{
        
        do{
            let all = try await SessionData.shared.document?.collection("Ingredients").getDocuments().documents
            print("got documents")
            
            guard all != nil
            else{
                return []
            }
            
            var inventory: [AutocompleteIngredient] = []
            
            for doc in all!{
                var data = try doc.data(as: AutocompleteIngredient.self)
                data.inStock = doc.data()["inStock"] as! Bool
                data.inFreezer = doc.data()["inFreezer"] as! Bool
                inventory.append(data)
            }
            
            print("returning list")
            return inventory
    
        }catch{
            print("Error in getInventory")
            return []
        }
    
    }
    
    static func hasIngredient(_ ingredient: AutocompleteIngredient) async -> Bool{
        do{
            let all = try await SessionData.shared.document?.collection("Ingredients").getDocuments().documents
            print("got documents")
            
            guard all != nil
            else{
                return false
            }
            
            for doc in all!{
                let id = doc.data()["id"] as? Int
                //let data = try doc.data(as: AutocompleteIngredient.self)
                if id! == ingredient.id!{
                    print("has ingredient")
                    await FireDbController.updateIngredientTo(ingredient, doc.documentID)
                    return true
                }
            }
    
        }catch{
            print("Error in hasIngredient")
        }
        print("does not have ingredient")
        return false
    }
    
    static func addIngredient(_ new: AutocompleteIngredient) async{
        do{
            try SessionData.shared.document?.collection("Ingredients").document().setData(from: new)
            print("ingredient added")
    
        }catch{
            print("Error while adding \(error.localizedDescription)")
        }
    }
    
    static func updateIngredientTo(_ new: AutocompleteIngredient, _ id: String) async{
        do{
            try SessionData.shared.document?.collection("Ingredients").document(id).setData(from: new)
            print("ingredient updated")
    
        }catch{
            print("Error while updating \(error.localizedDescription)")
        }
    }
    
    
    
    /*
      Updated Save Custom Recipes and get custom recipes
     */
    func saveCustomRecipes(customRecipe:CustomRecipe, image:UIImage?) async -> Bool{
        
        let reference = SessionData.shared.document?.collection("Recipes")
        
        guard let docIdFolder = SessionData.shared.document?.documentID else{
            print("No User data found for this User")
            
            return false
        }
        
        let photoName = UUID().uuidString
        
        let storage = Storage.storage()
        
        let storageRef = storage.reference().child("\(docIdFolder)/Photos/\(photoName).jpeg")
        
        guard image != nil else{
            print("Image is nil")
            
            return false
        }
        
        guard let resizedImage = image?.jpegData(compressionQuality: 0.2)else{
            print("Cannot compress image")
            return false
        }
        
        var metaData = StorageMetadata()
        
        metaData.contentType = "image/jpg"
        
        var imageURLString = ""
        
        do{
            
            let _ = try await storageRef.putDataAsync(resizedImage, metadata: metaData)
            
            print("Image Saved")
            
            do{
                let imageURL = try await storageRef.downloadURL() //Get the URL for the image saved at this reference location
                
                imageURLString = "\(imageURL)" //Save this in the Document CustomRecipe
            
            }catch{
                print("Could not get imageURL after saving Image to the Database \(error.localizedDescription)")
                return false
            }
            
        }catch{
            print("Could not storage Image to Cloud Storage")
            return false
        }//catch
        
        /*
          Now save the CustomRecipe along with the imageURL of the image uploaded on to Cloud Firestore
         */
        
        
        do{
            var newCustomRecipe = customRecipe
            
            newCustomRecipe.imageURLString = imageURLString
            
            //try await db.collection(collectionString).document(photoName).setData(newCustomRecipe.dictonary)
            
            try await reference?.document(photoName).setData(newCustomRecipe.dictionary)
            
            print("Data uploaded successfully")
            return true
        }catch{
            print("ERROR: Could not save/update document in photos, \(error.localizedDescription)")
            
            return false
        }
        
    }//savePhoto
    
    
    func getCustomRecipes() async -> [CustomRecipe]{
        
        do{
//            let db = Firestore.firestore()
//
//            let collectionString = "photos"
            
           // let dbReference = db.collection(collectionString)
            
            let dbReference = SessionData.shared.document?.collection("Recipes")
            
            var receivedCustomRecipes:[CustomRecipe] = []
            
            let snapshot = try await dbReference?.getDocuments()
            
            try snapshot?.documents.forEach({ documentSnapShot in
                
                receivedCustomRecipes.removeAll()
                
                var docData = try documentSnapShot.data(as: CustomRecipe.self)
                
                let docID = documentSnapShot.documentID
                
                docData.id = docID
                
                receivedCustomRecipes.append(docData)
                
            })//snapshot.documents.forEach
            
            return receivedCustomRecipes
            
        }catch{
            print("Error while fetching My Recipes \(error.localizedDescription)")
            return []
        }//catch
        
       // return []
    }//getCustomRecipes
    
    
    
    /*
      Testing Update Recipe --- Version 2.0
     */
    func updateCustomRecipe2(customRecipe:CustomRecipe, image:UIImage?) async -> (Bool, CustomRecipe?){
        
        let reference = SessionData.shared.document?.collection("Recipes")
        
        guard let docIdFolder = SessionData.shared.document?.documentID else{
            print("No User data found for this User")
            
            return (false, nil)
        }
        
        
        guard let photoName =  customRecipe.id else{
            print("No Such Document")
            return (false, nil)
        }
        
        var imageURLString = ""
        
        var customRecipeToUpdate = customRecipe
        
        print("Recipe ID to update \(customRecipeToUpdate.id ?? "Unknown ID")")
        
        if let imageToUpdate = image{
            
            print("Document ID for the Photo: \(customRecipe.id ?? "Unknown ID")")
            
           
            let storage = Storage.storage()
            
            let storageRef = storage.reference().child("\(docIdFolder)/Photos/\(photoName).jpeg")
            
            
            guard let resizedImage = image?.jpegData(compressionQuality: 0.2)else{
                print("Cannot compress image")
                return (false, nil)
            }
            
            let metaData = StorageMetadata()
            
            metaData.contentType = "image/jpg"
            
            do{
                let _ = try await storageRef.putDataAsync(resizedImage, metadata: metaData)
                
                print("Image Saved")
                
                do{
                    let imageURL = try await storageRef.downloadURL() //Get the URL for the image saved at this reference location
                    
                    imageURLString = "\(imageURL)" //Save this in the Document CustomRecipe
                    
                    customRecipeToUpdate.imageURLString = imageURLString
                    
                }catch{
                    print("Could not get imageURL after saving Image to the Database \(error.localizedDescription)")
                    return (false, nil)
                }
                
            }catch{
                print("Could not Save Image to Cloud Storage \(error.localizedDescription)")
                
                return (false, nil)
            }//catch Image
    
        }else{
            print("Image not updated. Save the Document without updating the Image")
            
        }//if image nil check
       
        do{
            
            print("Recipe ID to update \(customRecipeToUpdate.id ?? "Unknown ID")")
            
            try await reference?.document(photoName).setData(customRecipeToUpdate.dictionary)
            
            
            print("Data uploaded successfully")
            
            return (true, customRecipeToUpdate)
        }catch{
            print("ERROR: Could not save/update document in photos, \(error.localizedDescription)")
            
            return (false, nil)
        }
        
        
    }//updateCustom Recipe
    
    
    
    func deleteCustomRecipe(customRecipe:CustomRecipe?) async -> Bool{
        
        guard customRecipe?.id != nil else{
            print("No Such Image/Document")
            
            return false
        }
        
        
        let reference = SessionData.shared.document?.collection("Recipes")
        
        guard let docIdFolder = SessionData.shared.document?.documentID else{
            print("No User data found for this User")
            
            return false
        }
        
        
        guard let photoName =  customRecipe?.id else{
            print("No Such Document")
            return false
        }
        
        
        let storage = Storage.storage()
        
        //let storageRef = storage.reference().child("\(customRecipe?.id ?? "Unknown").jpeg")
        
        let storageRef = storage.reference().child("\(docIdFolder)/Photos/\(photoName).jpeg")
        
        do{
            try await storageRef.delete()
        }catch{
            print("Cannot delete Image from Cloud Storage \(error.localizedDescription)")
            return false
        }
        
        /*
          Delete the Document itself from Firestore
         */
        do{
            
            let db = Firestore.firestore()
            
            let collectionString = "photos"
            
            //let docRef = db.collection(collectionString).document(customRecipe?.id ?? "UnkownID")
            
            try await reference?.document(photoName).delete()
            
            print("Document with id \(customRecipe?.id ?? "Unknown") deleted from Firestore")
            
            return true
        }catch{
            print("Error deleting Document from Firestore \(error.localizedDescription)")
            
            return false
        }//catch
    } //func deleteCustomRecipe
    
    
    
    /*
       Refactored Get all Favorite Recipes
     */
    func getAllFavoriteRecipes2() async throws ->[FavoriteRecipes]{
        
        
            let reference = SessionData.shared.document?.collection("FavoriteRecipes")
            
            var favRecipesToReturn:[FavoriteRecipes] = []
            
            
            
            let snapshot = try await reference?.getDocuments()
            
            
            try snapshot?.documents.forEach({ documentSnapshot in
                var docData = try documentSnapshot.data(as: FavoriteRecipes.self)
                
                let docID = documentSnapshot.documentID
                
                docData.id = docID
                
                favRecipesToReturn.append(docData)
            })
            return favRecipesToReturn
       
    }//getAllFavoriteRecipes
    
    
    /*
      Refactored Save Custom Recipes
     */
    func saveCustomRecipes2(customRecipe:CustomRecipe, image:UIImage?) async throws -> Bool{
        
        let reference = SessionData.shared.document?.collection("Recipes")
        
        guard let docIdFolder = SessionData.shared.document?.documentID else{
            print("No User data found for this User")
            
            return false
        }
        
        let photoName = UUID().uuidString
        
        let storage = Storage.storage()
        
        let storageRef = storage.reference().child("\(docIdFolder)/Photos/\(photoName).jpeg")
        
        guard image != nil else{
            print("Image is nil")
            
            return false
        }
        
        guard let resizedImage = image?.jpegData(compressionQuality: 0.2)else{
            print("Cannot compress image")
            return false
        }
        
        var metaData = StorageMetadata()
        
        metaData.contentType = "image/jpg"
        
        var imageURLString = ""
        
        
        let _ = try await storageRef.putDataAsync(resizedImage, metadata: metaData)
        
        print("Image Saved")
        
        
        let imageURL = try await storageRef.downloadURL() //Get the URL for the image saved at this reference location
        
        imageURLString = "\(imageURL)" //Save this in the Document CustomRecipe
        
        /*
         Now save the CustomRecipe along with the imageURL of the image uploaded on to Cloud Firestore
         */
        
        var newCustomRecipe = customRecipe
        
        newCustomRecipe.imageURLString = imageURLString
        
        //try await db.collection(collectionString).document(photoName).setData(newCustomRecipe.dictonary)
        
        try await reference?.document(photoName).setData(newCustomRecipe.dictionary)
        
        print("Data uploaded successfully")
        
        return true
        
    }//saveCustomRecipes2
 
    
    
    /*
      Get Custom Recipes Refactored
     */
    func getCustomRecipes2() async throws -> [CustomRecipe]{
        
        
            let dbReference = SessionData.shared.document?.collection("Recipes")
            
            var receivedCustomRecipes:[CustomRecipe] = []
            
            let snapshot = try await dbReference?.getDocuments()
            
            try snapshot?.documents.forEach({ documentSnapShot in
                
                //receivedCustomRecipes.removeAll()
                
                var docData = try documentSnapShot.data(as: CustomRecipe.self)
                
                let docID = documentSnapShot.documentID
                
                docData.id = docID
                
                receivedCustomRecipes.append(docData)
                
            })//snapshot.documents.forEach
                
        print("\(receivedCustomRecipes.count)")
        
            return receivedCustomRecipes
            
       // return []
    }//getCustomRecipes
    
    
    
    /*
      Refactored Delete Recipe
     */
    func deleteCustomRecipe2(customRecipe:CustomRecipe?) async throws -> Bool{
        
        guard customRecipe?.id != nil else{
            print("No Such Image/Document")
            
            return false
        }
        
        
        let reference = SessionData.shared.document?.collection("Recipes")
        
        guard let docIdFolder = SessionData.shared.document?.documentID else{
            print("No User data found for this User")
            
            return false
        }
        
        
        guard let photoName =  customRecipe?.id else{
            print("No Such Document")
            return false
        }
        
        
        let storage = Storage.storage()
        
        //let storageRef = storage.reference().child("\(customRecipe?.id ?? "Unknown").jpeg")
        
        let storageRef = storage.reference().child("\(docIdFolder)/Photos/\(photoName).jpeg")
        
            try await storageRef.delete()
        /*
          Delete the Document itself from Firestore
         */
            
            let db = Firestore.firestore()
            
            let collectionString = "photos"
            
            //let docRef = db.collection(collectionString).document(customRecipe?.id ?? "UnkownID")
            
            try await reference?.document(photoName).delete()
            
            print("Document with id \(customRecipe?.id ?? "Unknown") deleted from Firestore")
            
            return true
       
    } //func deleteCustomRecipe
    
}
