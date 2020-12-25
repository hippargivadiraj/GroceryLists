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
    
    @State var storeItemVS = StoreItemViewState()
    
    //    @State var cancellable: AnyCancellable?
    
   
    //deleting the index of item
    private func deleteStoreItem(at indexSet: IndexSet)  {
        indexSet.forEach {index in
        let storeItem = storeItemListVM.storeItems[index]
        storeItemListVM.deleteStoreItem(storeId: store.storeId, storeItemId: storeItem.storeItemId)
        }
    }
    
    var body: some View {
        
        VStack {
            TextField("Enter Items", text: $storeItemVS.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Enter Items", text: $storeItemVS.price)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Enter Items", text: $storeItemVS.quantity)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("save"){
                storeItemListVM.addItemToStore(storeId: store.storeId, storeItemVS: storeItemVS) { (error) in
                    
                    if error == nil {
                        storeItemVS = StoreItemViewState()
                        storeItemListVM.getStoreItemsBy(storeId: store.storeId )
                    }
                }
            }
            
            List {
                ForEach(storeItemListVM.storeItems, id:\.storeItemId ){
                    storeItem in
                    Text(storeItem.name)
                }.onDelete(perform:
                    deleteStoreItem
                )
            }
                
            
            Spacer()
        
        }
        .onAppear(perform: {
            //                cancellable = storeItemListVM.$store.sink { value in
            //                    if let value = value {
            //                        store = value
            //                    }
            //                }
            
           // storeItemListVM.getStoreById(storeId: store.storeId)
            
            storeItemListVM.getStoreItemsBy(storeId: store.storeId)
        })
    }
}


struct StoreItemsLIstView_Previews: PreviewProvider {
    static var previews: some View {
        StoreItemsLIstView(store: StoreViewModel(store: Store(id: "223344", name: "Walmart", address: "1234 Some Avenue", items: ["Carrot", "Banana"] )))
    }
}

