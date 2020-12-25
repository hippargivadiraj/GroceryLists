//
//  StoreListViewModel.swift
//  GroceryLists
//
//  Created by Vadiraj Hippargi on 12/24/20.
//

import Foundation

class StoreListViewModel: ObservableObject {
    
    private var firestoreService : FirestoreService
    @Published var stores : [StoreViewModel] = [ ]
    
    init(){
        firestoreService = FirestoreService()
    }
    
    func getAll()  {
        firestoreService.getAllStores { result  in
            switch result{
            case .success(let stores):
                if let stores = stores {
                    DispatchQueue.main.async {
                        self.stores  = stores.map(StoreViewModel.init)
                    }
                }
            case .failure( let error):
                print(error.localizedDescription)
            }
        }
    }
}

//Create a StoreViewModel to be used by StoreListViewModel
struct StoreViewModel  {
    let store:Store
    
    
    //These are get Properties Cannot Change Them
    
    var storeId:String {
        store.id ?? ""
    }
    
    var name:String {
        store.name
    }
    
    var address: String {
        store.address
    }
    
    var items : [String] {
        store.items ?? [ ]
    }
}
