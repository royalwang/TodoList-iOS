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
        
        TodoItemDataManager.sharedInstance.store(title: textField.text!)

        self.navigationController?.popViewController(animated: true)
    }
    
}
