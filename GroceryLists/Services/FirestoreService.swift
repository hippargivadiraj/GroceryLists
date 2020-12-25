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
                        if let snapshot = snapshot {
                            var store: Store? = try? snapshot.data(as: Store.self)
                            if store != nil {
                                store!.id = snapshot.documentID
                                completion(.success(store))
                            }
                        }
                    }
                }
            }
        }
    }
    
    
}
