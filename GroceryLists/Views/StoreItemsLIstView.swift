//
//  StoreItemsLIstView.swift
//  GroceryLists
//
//  Created by Vadiraj Hippargi on 12/24/20.
//

import SwiftUI
//import Combine

struct StoreItemsLIstView: View {
    
    var store: StoreViewModel
    @StateObject private var storeItemListVM = StoreItemListViewModel()
    
    //    @State var cancellable: AnyCancellable?
    
    var body: some View {
        
        VStack {
            TextField("Enter Items", text: $storeItemListVM.groceryItemName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("save"){
                storeItemListVM.addItemsToStore(storeId: store.storeId)
            }
            
            if let store = storeItemListVM.store {
                List(store.items, id:\.self ){ item in
                    Text(item)
                    
                }
                
            }
            Spacer()
        }
        
        .onAppear(perform: {
            //                cancellable = storeItemListVM.$store.sink { value in
            //                    if let value = value {
            //                        store = value
            //                    }
            //                }
            
            storeItemListVM.getStoreById(storeId: store.storeId)
        })
    }
}


struct StoreItemsLIstView_Previews: PreviewProvider {
    static var previews: some View {
        StoreItemsLIstView(store: StoreViewModel(store: Store(id: "223344", name: "Walmart", address: "1234 Some Avenue", items: ["Carrot", "Banana"] )))
    }
}

