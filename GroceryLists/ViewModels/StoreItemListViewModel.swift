//
//  StoreItemListViewModel.swift
//  GroceryLists
//
//  Created by Vadiraj Hippargi on 12/24/20.
//

import Foundation



struct StoreItemViewState: Codable  {
    var name: String = ""
    var price: String = ""
    var quantity: String = ""
    
}

struct StoreItemViewModel: Codable {
    var storeItem : StoreItem
    
    var storeItemId: String {
        storeItem.id ?? " "
    }
    
    var name: String{
        storeItem.name
    }
    var price: Double{
        storeItem.price
    }
    var quantity: Int{
        storeItem.quantity
    }
}

class StoreItemListViewModel: ObservableObject {
    
    
    private var firestoreService : FirestoreService
    
    @Published var store: StoreViewModel?
    var groceryItemName : String = ""
    
 //   var storeItemVS  =  StoreItemViewState()
    @Published var storeItems : [StoreItemViewModel] = [ ]
    
    init(){
        firestoreService = FirestoreService()
    }
    
    func getStoreById(storeId:String)  {
        firestoreService.getStoreById(storeId: storeId) { (result) in
            switch result {
            case .success(let store):
                if let store = store {
                    DispatchQueue.main.async {
                        self.store = StoreViewModel(store: store)
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
  /*
     New addItemToStore is created Making this addItemsToStore not necessry
     
    func addItemsToStore(storeId: String)  {
        firestoreService.updateStore(storeId: storeId, values: ["items" : [groceryItemName] ]) { (result) in
            switch result {
            case .success(let storeModel):
                if let model = storeModel {
                    self.store = StoreViewModel(store: model)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    */
  
    func addItemToStore(storeId: String, storeItemVS:StoreItemViewState, completion: @escaping (Error?)-> Void ){
        let storeItem = StoreItem.from(storeItemVS: storeItemVS)
        firestoreService.updateStore(storeId: storeId, storeItem: storeItem) { (result) in
            switch result{
            case .success(_):
            completion(nil)
            case.failure( let error):
                completion(error)
            }
        }
        
    }
     
    
    func getStoreItemsBy(storeId:String)  {
        firestoreService.getStoreItemsBy(storeId: storeId) { (result) in
            switch result{
            case .success(let items):
                if let items = items {
                    DispatchQueue.main.async {
                        self.storeItems = items.map(StoreItemViewModel.init)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            
            }
        }
    }
    
    func deleteStoreItem(storeId: String, storeItemId: String ) {
        firestoreService.deleteStoreItem(storeId: storeId, storeItemId: storeItemId) { (error) in
            if error == nil {
                
                self.getStoreItemsBy(storeId: storeId)
            }
            
        }
    }
    
}
