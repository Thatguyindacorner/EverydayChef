//
//  FireDBController.swift
//  EverydayChef
//
//  Created by Ameya Joshi on 2023-06-19.
//

import Foundation
import FirebaseFirestore

class FireDbController:ObservableObject{
    
    @Published var userRecipeList:[CustomRecipe] = []
    
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
    }
    
}
