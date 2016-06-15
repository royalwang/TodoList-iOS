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
    
    let router = Router()
    
    @IBAction func onDoneClicked(sender: UIButton) {


        // Create New ToDoItem
        let newItem = TodoItem(title: textField.text!, completed: false, order: 1)
        
        // TODO: Store newItem
        router.HTTPPostJSON(url: "http://localhost:8090", jsonObj: newItem.jsonRepresentation) {
            dict, error in
            print(dict,error)
            
        }

        self.navigationController?.popViewController(animated: true)
    }
    
}
