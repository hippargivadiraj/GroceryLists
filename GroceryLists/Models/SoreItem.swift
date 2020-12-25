//
//  SoreItem.swift
//  GroceryLists
//
//  Created by Vadiraj Hippargi on 12/25/20.
//

import Foundation

struct StoreItem: Codable {
    var id:String?
    var name:String
    var price: Double = 0.0
    var quantity: Int = 0
    
}

//This is to convert StoreItemViewState elemts into StoreItem
extension StoreItem {
    
    static func from(storeItemVS : StoreItemViewState) -> StoreItem {
        
        return StoreItem(name: storeItemVS.name, price: Double(storeItemVS.price) ?? 0.0 , quantity : Int(storeItemVS.quantity) ?? 0 )
        
    }
}
