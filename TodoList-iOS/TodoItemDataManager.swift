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
    
    let baseURL = "http://localhost:8090"
    let bluemixURL = "http://todolist-unsputtering-imperialist.mybluemix.net"
    
    var dataTask: NSURLSessionTask?
    let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.default())
    
    var allTodos = [TodoItem]()
    
    override init() {
        super.init()
        getAllTodos()
    }
    
    
    // Store item in todolist
    func store(item: TodoItem){
        
        allTodos.append(item)  // Right now there is a delay that forces a refresh. This is temporary, since it does not validate
        
        router.HTTPPostJSON(url: bluemixURL, jsonObj: item.jsonRepresentation) {
            dict, error in
            print(dict,error)
            
        }
    }
    
    func delete(id: String) {
        
        router.HTTPDelete(url: "\(bluemixURL)/\(id)") {
            data, error in
            print(data,error)
            
        }
    }
    func update(id: String, item: TodoItem) {
        router.HTTPPostJSON(url: bluemixURL, jsonObj: item.jsonWithID(id: id)) {
            dict, error in
            print(dict,error)
            
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
                
                if let item = item as? [String: AnyObject] {
                    
                    let title = item["title"] as? String
                    let completed = item["completed"] as? Bool
                    let order = item["order"] as? Int
                    
                    guard let titleValue = title else {
                        continue
                    }
                    
                    guard let completedValue = completed else {
                        continue
                    }
                    
                    guard let orderValue = order else {
                        continue
                    }
                    
                    allTodos.append(TodoItem(title: titleValue, completed: completedValue, order: orderValue) )
                                        
                }
                
            }
        }
    }
    
}
