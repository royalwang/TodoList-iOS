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
    
    
    override func viewDidAppear(_ animated: Bool) {
        TodoItemDataManager.sharedInstance.getAllTodos()
        updateTable(todoItems: todos())
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Setup TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        cell.textLabel?.text = todos()[indexPath.row].title
        
        
        // Handle Checkmarks
        if (todos()[indexPath.row].completed) {
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
        
        var itemToMove = todos()[sourceIndexPath.row]
        TodoItemDataManager.sharedInstance.move(at: destinationIndexPath, to: sourceIndexPath)
        
        // Update order on bluemix
        itemToMove.order = todos()[destinationIndexPath.row].order
        TodoItemDataManager.sharedInstance.update(id: itemToMove.id, item: itemToMove)
        
    }
    
    // Allows Completion Marking
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: NSIndexPath) {
        
        TodoItemDataManager.sharedInstance.allTodos[indexPath.row].completed = !todos()[indexPath.row].completed
        
        // Reload individual cell
        self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        
        // Completed Rows are removed upon completion update
        TodoItemDataManager.sharedInstance.update(id: todos()[indexPath.row].id, item: todos()[indexPath.row])
        TodoItemDataManager.sharedInstance.allTodos.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    // Allows Row Deletion
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: NSIndexPath) {
        
        if editingStyle == .delete {
            
            TodoItemDataManager.sharedInstance.delete(at: indexPath)
            
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