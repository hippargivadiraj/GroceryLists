//
//  StoreItemListViewModel.swift
//  GroceryLists
//
//  Created by Vadiraj Hippargi on 12/24/20.
//

import Foundation

class StoreItemListViewModel: ObservableObject {
    
    
    private var firestoreService : FirestoreService
    
    @Published var store: StoreViewModel?
    var groceryItemName : String = ""
    
    
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
    
    
}
