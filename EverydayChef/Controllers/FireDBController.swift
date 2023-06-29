//
//  FireDBController.swift
//  EverydayChef
//
//  Created by Ameya Joshi on 2023-06-19.
//

import Foundation
import FirebaseFirestore

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
    
}
