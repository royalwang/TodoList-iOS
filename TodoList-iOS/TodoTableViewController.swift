//
//  TodoTableViewController.swift
//  TodoList-iOS
//
//  Created by Robert Dickerson on 5/12/16.
//  Copyright © 2016 Swift@IBM Engineering. All rights reserved.
//

import Foundation
import UIKit

class TodoTableViewController: UITableViewController {
    
    var todoItems = [TodoItem]()
    
    let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.default())
    
    var dataTask: NSURLSessionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadTodoList()
        // self.tableView.isEditing = true
    }
    
   
    @IBAction func onEditClicked(sender: AnyObject) {
        self.tableView.isEditing = true      
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) 
        
        cell.textLabel?.text = todoItems[indexPath.row].title
        
        return cell
    }
    
    func downloadTodoList() {
        let url = NSURL(string: "http://localhost:8090/")
        
        dataTask = defaultSession.dataTask(with: url!) {
            data, response, error in
            
            dispatch_async(dispatch_get_main_queue()) {
                UIApplication.shared().isNetworkActivityIndicatorVisible = false
            }
            
            if let error = error {
                print(error.localizedDescription)
                
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    self.updateTable(data)
                }
            }
        }
        
        dataTask?.resume()
        
        
    }
    
    func updateTable(_ data: NSData?) {
        
        do {
            let json = try NSJSONSerialization.jsonObject(with: data!, options: .mutableContainers)
        
            todoItems = parseTodoList(json: json)
            
            print(todoItems)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
            
            //print(json)
        } catch {
            
        }
    }
    
    private func parseTodoList(json: AnyObject) -> [TodoItem] {
        
        var todos = [TodoItem]()
        
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
                    
                    todos.append( TodoItem(title: titleValue, completed: completedValue, order: orderValue) )
                    
                    
                }
                
            }
        }
        
        return todos
    }
    
    
    
}