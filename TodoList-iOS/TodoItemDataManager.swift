//
//  TodoItemDataManager.swift
//  TodoList-iOS
//
//  Created by Aaron Liberatore on 6/15/16.
//  Copyright © 2016 Swift@IBM Engineering. All rights reserved.
//

import UIKit
import Foundation

class TodoItemDataManager: NSObject {
    
    let router = Router()
    
    static let sharedInstance = TodoItemDataManager()
    
    let localURL = "http://localhost:8090"
    let bluemixURL = "http://todolist-unsputtering-imperialist.mybluemix.net"
    
    var dataTask: NSURLSessionTask?
    let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.default())
    
    var allTodos = [TodoItem]()
    
    override init() {
        super.init()
        getAllTodos()
    }
    
    
    // Store item in todolist
    func store(title: String){
        
        let json = "{\"title\":\"\(title)\",\"completed\":\"\(false)\",\"order\":\"\(TodoItemDataManager.sharedInstance.allTodos.count + 1)\"}"
        
        router.HTTPPost(url: bluemixURL, jsonObj: json) {
            data, error in
            if error != nil { print(error?.localizedDescription) }
            else {
                do {
                    let json = try NSJSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    self.allTodos.append(self.parseItem(item: json)!)

                } catch { print("Error Storing Data") }
            }
        }

    }
    
    func delete(at: NSIndexPath) {
        
        let id = allTodos[at.row].id
        TodoItemDataManager.sharedInstance.allTodos.remove(at: at.row)
        
        router.HTTPDelete(url: "\(bluemixURL)/todos/\(id)") {
            data, error in
            if error != nil { print(error?.localizedDescription) }
        }
    }
    
    func update(id: String, item: TodoItem) {
        router.HTTPPatch(url: "\(bluemixURL)/todos/\(id)", jsonObj: item.jsonRepresentation) {
            data, error in
            if error != nil { print(error?.localizedDescription) }
        }
        
    }
    
    func get(id: String) {
        router.HTTPGet(url: "\(bluemixURL)/todos/\(id)") {
            data, error in
            if error != nil { print(error?.localizedDescription) }
        }
        
    }
    // Loads todolist from url
    
    func getAllTodos() {
        //let url = NSURL(string: bluemixURL)
        
        router.HTTPGet(url: bluemixURL) {
            data, error in
                do {
                    let json = try NSJSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    self.parseTodoList(json: json)
                } catch {
                    print("Error parsing data")
                }
            }
        }
    
    private func parseTodoList(json: AnyObject){
        
        allTodos.removeAll()
        
        if let json = json as? [AnyObject] {

            for item in json {
                
                guard let todo = parseItem(item: item) else {
                    continue
                }
                
                insertSorted(seq: &allTodos, newItem: todo)
                                        
            }
                
        }
    }
    
    private func parseItem(item: AnyObject) -> TodoItem? {
        if let item = item as? [String: AnyObject] {
            
            let id        = item["id"] as? String
            let title     = item["title"] as? String
            let completed = item["completed"] as? Bool
            let order     = item["order"] as? Int
            
            guard let uid = id,
                  let titleValue = title,
                  let completedValue = completed,
                  let orderValue = order else {
                
                    return nil
            }

            
            return TodoItem(id: uid, title: titleValue, completed: completedValue, order: orderValue)
        }
        
        return nil
    }
    
    func insertSorted<T: Comparable>( seq: inout [T], newItem item: T) {
        let index = seq.reduce(0) { $1 < item ? $0 + 1 : $0 }
        seq.insert(item, at: index)
    }
    
    func move(at: NSIndexPath, to: NSIndexPath) {
        let itemToMove = allTodos[at.row]
        allTodos.remove(at: at.row)
        allTodos.insert(itemToMove, at: to.row)
    }
}
