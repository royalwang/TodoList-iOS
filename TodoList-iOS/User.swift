//
//  User.swift
//  TodoList-iOS
//
//  Created by Aaron Liberatore on 6/16/16.
//  Copyright © 2016 Swift@IBM Engineering. All rights reserved.
//

import UIKit

class User: NSObject {
    
    /// Grab facebook user id of user from NsUserDefaults
    class var facebookUserId: String {
        get {
            return NSUserDefaults.standard().object(forKey: "facebook_user_id") as! String
        }
        set(userId) {
            
            NSUserDefaults.standard().set(userId, forKey: "facebook_user_id")
            NSUserDefaults.standard().synchronize()
        }
    }
    
    /// grab full name of user from NSUserDefaults
    class var fullName: String {
        get {
            return NSUserDefaults.standard().object(forKey: "user_full_name") as! String
        }
        set(user_full_name) {
            
            NSUserDefaults.standard().set(user_full_name, forKey: "user_full_name")
            NSUserDefaults.standard().synchronize()
        }
        
    }
    /// grab full name of user from NSUserDefaults
    class var email: String {
        get {
            return NSUserDefaults.standard().object(forKey: "user_email") as! String
        }
        set(user_full_name) {
            
            NSUserDefaults.standard().set(user_full_name, forKey: "user_email")
            NSUserDefaults.standard().synchronize()
        }
        
    }
}
