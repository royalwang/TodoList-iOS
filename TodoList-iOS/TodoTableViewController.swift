//
//  TodoTableViewController.swift
//  TodoList-iOS
//
//  Created by Robert Dickerson on 5/12/16.
//  Copyright © 2016 Swift@IBM Engineering. All rights reserved.
//

import Foundation
import UIKit
//import Credentials


class TodoTableViewController: UITableViewController {
    
    var todoItems = [TodoItem]()
    
    let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.default())
    
    var dataTask: NSURLSessionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadTodoList()
        // self.tableView.isEditing = true
    }
    
    // Setup TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: NSIndexPath) -> UITableViewCell {
        
        todoItems.sort(isOrderedBefore: { $0.order < $1.order })
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        cell.textLabel?.text = todoItems[indexPath.row].title
        
        
        // Handle Checkmarks
        if (todoItems[indexPath.row].completed) {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        
        return cell
    }
    
    
    // Allows Movable Rows
    
    @IBAction func onEditClicked(sender: UIBarButtonItem) {
        self.isEditing = !self.isEditing
        
    }
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: NSIndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: NSIndexPath, to destinationIndexPath: NSIndexPath) {
        
        let itemToMove = todoItems[sourceIndexPath.row]
        todoItems.remove(at: destinationIndexPath.row)
        todoItems.insert(itemToMove, at: sourceIndexPath.row)
        
    }
    
    // Allows boolean completion changing
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: NSIndexPath) {

        var item = todoItems[indexPath.row]
        item.completed = !item.completed
        
        todoItems[indexPath.row].completed = !todoItems[indexPath.row].completed
        
        // Reload individual cell
        self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
        
        //TODO: Update bluemix database
    }
    
    // Allows row deletion
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: NSIndexPath) {
        
        if editingStyle == .delete {
            todoItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        
    }
    
    
    // Loads todolist from url
    
    func downloadTodoList() {
        let url = NSURL(string: "http://localhost:8090")//"http://todolist-sublunate-ectromelia.mybluemix.net")
        
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
            print("json",json)
            todoItems = parseTodoList(json: json)
            
            print(todoItems)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
            
        } catch {
            print("Error")
            
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