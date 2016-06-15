//
//  TodoItem.swift
//  TodoList-iOS
//
//  Created by Robert Dickerson on 5/12/16.
//  Copyright © 2016 Swift@IBM Engineering. All rights reserved.
//

import Foundation

struct TodoItem {
    
    let id: String
    let title: String
    var completed: Bool
    let order: Int
    
    var jsonRepresentation : String {
        return "{\"title\":\"\(title)\",\"completed\":\"\(completed)\",\"order\":\"\(order)\"}"
    }
    
    func jsonWithID(id: String) -> String {
        return "{\"id\":\"\(id)\",\"title\":\"\(title)\",\"completed\":\"\(completed)\",\"order\":\"\(order)\"}"
    }
    
}