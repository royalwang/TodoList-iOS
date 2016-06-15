//
//  AddTodoViewController.swift
//  TodoList-iOS
//
//  Created by Robert Dickerson on 5/12/16.
//  Copyright © 2016 Swift@IBM Engineering. All rights reserved.
//

import UIKit

class AddTodoViewController: UIViewController {

    @IBOutlet var textField: UITextField!
    
    @IBAction func onDoneClicked(sender: UIButton) {


        // Create New ToDoItem
        let item = TodoItem(title: textField.text!, completed: false, order: TodoItemDataManager.sharedInstance.allTodos.count + 1)
        
        TodoItemDataManager.sharedInstance.store(item: item)

        self.navigationController?.popViewController(animated: true)
    }
    
}
