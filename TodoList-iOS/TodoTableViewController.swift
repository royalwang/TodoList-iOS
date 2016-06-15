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
    
    override func viewDidAppear(_ animated: Bool) {
        TodoItemDataManager.sharedInstance.getAllTodos()
        todoItems = todos()
        updateTable(todoItems: todoItems)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todoItems = todos()
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
        
        TodoItemDataManager.sharedInstance.update(id: todoItems[indexPath.row].id, item: todoItems[indexPath.row])
    }
    
    // Allows row deletion
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: NSIndexPath) {
        
        if editingStyle == .delete {
            TodoItemDataManager.sharedInstance.delete(id: todoItems[indexPath.row].id)
            todoItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        
    }
    
    func updateTable(todoItems: [TodoItem]) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })

    }
    
    func todos() -> [TodoItem] {
        return TodoItemDataManager.sharedInstance.allTodos
    }
        
}