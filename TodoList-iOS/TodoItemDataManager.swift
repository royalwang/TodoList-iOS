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
            do {
                let json = try NSJSONSerialization.jsonObject(with: data, options: .mutableContainers)
                self.allTodos.append(self.parseItem(item: json)!)

            } catch {
                print("Error Storing Data")
            }
        }

    }
    
    func delete(id: String) {
        router.HTTPDelete(url: "\(bluemixURL)/todos/\(id)") {
            data, error in
            
        }
    }
    
    func update(id: String, item: TodoItem) {
        router.HTTPPatch(url: "\(bluemixURL)/todos/\(id)", jsonObj: item.jsonRepresentation) {
            data, error in
            print(data,error)
            
        }
        
    }
    
    func get(id: String) {
        router.HTTPGet(url: "\(bluemixURL)/todos/\(id)") {
            data, error in
            print(data,error)
            
        }
        
    }
    // Loads todolist from url
    
    func getAllTodos() {
        let url = NSURL(string: bluemixURL)
        
        dataTask = defaultSession.dataTask(with: url!) {
            data, response, error in
            
            dispatch_async(dispatch_get_main_queue()) {
                UIApplication.shared().isNetworkActivityIndicatorVisible = false
            }
            
            if let error = error {
                print(error.localizedDescription)
                
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    do {
                        let json = try NSJSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                        //print(json)
                        self.parseTodoList(json: json)
                    } catch {
                        print("Error parsing data")
                    }
                }
            }
        }
        
        dataTask?.resume()
        
        
    }
    
    private func parseTodoList(json: AnyObject){
        
        allTodos.removeAll()
        
        if let json = json as? [AnyObject] {
            for item in json {
                
                guard let todo = parseItem(item: item) else {
                    continue
                }
                
                allTodos.append(todo)
                                        
            }
                
        }
    }
    
    private func parseItem(item: AnyObject) -> TodoItem? {
        if let item = item as? [String: AnyObject] {
            
            let id    = item["id"] as? String
            
            let title = item["title"] as? String
            let completed = item["completed"] as? Bool
            let order = item["order"] as? Int
            
            /*guard let uid = id else {
                
            }
            
            guard let titleValue = title else {
                
            }
            
            guard let completedValue = completed else {
                
            }
            
            guard let orderValue = order else {
                
            }*/
            
            return TodoItem(id: id!, title: title!, completed: completed!, order: order!)
        }
        
        return nil
    }
}
