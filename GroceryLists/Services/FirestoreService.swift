//
//  FirestoreService.swift
//  GroceryLists
//
//  Created by Vadiraj Hippargi on 12/23/20.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class FirestoreService {
    
    //Create a Firestore DB
    private var db:Firestore
    
    //initialize Firesore
    init(){
        db = Firestore.firestore()
    }
    
    //here is function that gives Save service for saving the Store
    
    func save(store:Store , completion: @escaping (Result<Store?, Error>) -> Void ){
        do{
            let ref =  try db.collection("stores").addDocument(from: store)
            ref.getDocument { (snapshot, error) in
                guard let snapshot = snapshot, error == nil else {
                    completion(.failure(error!))
                    return
                }
                
                let store = try? snapshot.data(as: Store.self)
                completion(.success(store))
                return
            }
        }catch let error {
            completion(.failure(error))
        }
    }
    
    // Gets all the saved Stores
    func getAllStores(completion: @escaping( Result<[Store]?, Error>) -> Void) {
        db.collection("stores").getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            }else{
                if let snapshot = snapshot {
                    let stores:[Store]  = snapshot.documents.compactMap { doc in
                        var store = try? doc.data(as: Store.self)
                        if store != nil{
                            store?.id = doc.documentID
                        }
                        return store
                    }
                    completion(.success(stores))
                }
            }
        }
    }
    
    
    // This function gets store for a given store Id
    func getStoreById(storeId:String, completion: @escaping (Result<Store?, Error >)-> Void)  {
        let ref = db.collection("stores").document(storeId)
        ref.getDocument { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            }else{
                if let snapshot = snapshot {
                    var store:Store? = try? snapshot.data(as: Store.self)
                    if store != nil {
                        store!.id = snapshot.documentID
                        completion(.success(store))
                    }
                }
            }
        }
    }
    
    
    //Updates Store,  using storeId,  with Items and also gets the updated store back
    func updateStore(storeId:String, values: [AnyHashable: Any], completion: @escaping (Result<Store?, Error>) ->Void )  {
        let ref = db.collection("stores").document(storeId)
        ref.updateData( [ "items" : FieldValue.arrayUnion((values["items"] as? [String] ) ?? [ ] ) ] ) { error in
            if let error = error {
                completion(.failure(error))
            }else {
                ref.getDocument { (snapshot, error) in
                    if let error = error {
                        completion(.failure(error))
                    }else{
//                        if let snapshot = snapshot {
//                            var store: Store? = try? snapshot.data(as: Store.self)
//                            if store != nil {
//                                store!.id = snapshot.documentID
//                                completion(.success(store))
//                            }
//                        }
                        // using new get storebyid 
                        self.getStoreById(storeId: storeId) { (result) in
                            switch result{
                            case .success(let store):
                                completion(.success(store))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    
    func updateStore(storeId:String, storeItem:StoreItem, completion: @escaping (Result<Store?, Error>) ->Void) {
        do{
            //Update Store Here
            let _ = try db.collection("stores")
                .document(storeId)
                .collection("items")
                .addDocument(from: storeItem)
            
           // Also get the updated Store
            self.getStoreById(storeId: storeId) { (result) in
                switch result{
                case .success(let store):
                    completion(.success(store))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }catch{
            
        }
    }
    
  // This gets items by SoreId
    func getStoreItemsBy(storeId: String, completion: @escaping ( Result <  [ StoreItem ]?,  Error >)-> Void )  {
        let ref = db.collection("stores").document(storeId).collection("items")
        ref.getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            }else{
                if let snapshot = snapshot {
                    let items : [StoreItem]? =  snapshot.documents.compactMap { doc in
                       var storeItem =  try? doc.data(as: StoreItem.self)
                        storeItem?.id = doc.documentID
                        return storeItem
                    }
                        completion(.success(items))
                }
            }
        }
    }
    
    //Delete a Store Item
    func deleteStoreItem(storeId: String, storeItemId: String, completion: @escaping ( Error? )-> Void)  {
        db.collection("stores")
            .document(storeId)
            .collection("items")
            .document(storeItemId)
            .delete { (error) in
                completion(error)
            }
    }
    
    
}
