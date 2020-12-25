//
//  Store.swift
//  GroceryLists
//
//  Created by Vadiraj Hippargi on 12/23/20.
//

import Foundation

struct Store:Codable {
    var id: String?
    let name:String
    let address:String
    
    //Store has Items but Items can be Null So , optional
    //Item array is NESTED within Store
    var items : [String]?
}
