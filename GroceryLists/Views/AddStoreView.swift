//
//  AddStoreView.swift
//  GroceryLists
//
//  Created by Vadiraj Hippargi on 12/24/20.
//

import SwiftUI

struct AddStoreView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var addStoreVM = AddStoreViewModel()
    
    var body: some View {
        
        NavigationView{
            Form{
                Section{
                    TextField("Name", text: $addStoreVM.name)
                    TextField("Address", text: $addStoreVM.address)
                    HStack{
                        Spacer()
                        Button( "Save"){
                            addStoreVM.save()
                            
                        }.onChange(of: addStoreVM.saved, perform: { value in
                            if value{
                                presentationMode.wrappedValue.dismiss()
                            }
                           
                        })
                        .padding()
                        
                    }
                    Text(addStoreVM.message)
                }
            }
            .navigationTitle("Add New Store")
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark")
            }))
        }
    }
}

struct AddStoreView_Previews: PreviewProvider {
    static var previews: some View {
        AddStoreView()
    }
}
