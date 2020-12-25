//
//  ContentView.swift
//  GroceryLists
//
//  Created by Vadiraj Hippargi on 12/23/20.
//

import SwiftUI

struct ContentView: View {
    @State var isPresented:Bool = false
    @ObservedObject private  var storesListVM = StoreListViewModel()
    
    var body: some View {
        NavigationView{
                List(storesListVM.stores, id: \.storeId){ store in
                    NavigationLink(
                        destination: StoreItemsLIstView(store: store),
                        label: {
                            StoreCell(store: store)
                        })
                 
                } .sheet(isPresented: $isPresented, onDismiss: {
                    storesListVM.getAll()
                },  content: {
                AddStoreView()
            })
            .navigationTitle("Gocery App")
            .navigationBarItems(trailing: Button(action: {
                isPresented.toggle()
            }, label: {
                Image(systemName: "plus")
            }))
            .onAppear(perform: {
                storesListVM.getAll()
            })
        }
    }//NavigationView
}//ContentView


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct StoreCell: View {
    let store:StoreViewModel
    
    var body: some View {
        VStack(alignment: .leading){
            Text(store.name)
                .font(.headline)
                .foregroundColor(.blue)
            Text(store.address)
        }
    }
}
