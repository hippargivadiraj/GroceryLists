//
//  GroceryListsApp.swift
//  GroceryLists
//
//  Created by Vadiraj Hippargi on 12/23/20.
//

import SwiftUI
import Firebase

@main
struct GroceryListsApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
