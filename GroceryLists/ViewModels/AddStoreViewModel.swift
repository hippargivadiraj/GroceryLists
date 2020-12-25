//
//  AddStoreViewModel.swift
//  GroceryLists
//
//  Created by Vadiraj Hippargi on 12/24/20.
//

import Foundation

class AddStoreViewModel: ObservableObject {
    
    //Get the firestoreServices to the model
    
    private var firestoreService:FirestoreService
    @Published var saved: Bool = false
    @Published var message: String = ""
    
    var name : String = ""
    var address : String = ""
    
    //Initialization
    init(){
        firestoreService = FirestoreService()
    }
    
    //function to save the store
    func save () {
        let store = Store( name: name, address: address)
        firestoreService.save(store: store) { result in
            switch result{
            case .success(let store ):
                DispatchQueue.main.async {
                    self.saved = store == nil ? false : true
                }
            case .failure( _ ):
                DispatchQueue.main.async {
                    self.message = Constants.Messages.storeSavedFailure
                }
                
            }
        }
    }
    
}
