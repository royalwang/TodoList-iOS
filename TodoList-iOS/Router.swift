//
//  Router.swift
//  TodoList-iOS
//
//  Created by Aaron Liberatore on 6/14/16.
//  Copyright © 2016 Swift@IBM Engineering. All rights reserved.
//

import UIKit

class Router: NSObject {
    
    let session = NSURLSession.shared();
    let request : NSMutableURLRequest = NSMutableURLRequest();
    
    func HTTPGet(url: String, callback: (NSData, NSError?) -> Void) {
        
        request.url = NSURL(string: url)!
        request.httpMethod = "GET"
        
        taskManager() { data, error in
            callback(data, error)
        }
    }
    
     // Task: Executes an HTTP POST request to the destination url
     // containing the given json serializable object
    
    func HTTPPost(url: String,
                      jsonObj: AnyObject,
                      callback: (NSData, NSError?) -> Void) {
        
        request.url = NSURL(string: url)!
        request.httpMethod = "POST"
        request.httpBody = jsonObj.data(using: NSUTF8StringEncoding)!
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        taskManager() { data, error in
            callback(data, error)
        }
        
    }
    
    func HTTPPatch(url: String,
                   jsonObj: AnyObject,
                   callback: (NSData, NSError?) -> Void) {
        
        request.url = NSURL(string: url)!
        request.httpMethod = "PATCH"
        request.httpBody = jsonObj.data(using: NSUTF8StringEncoding)!
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        taskManager() { data, error in
            callback(data, error)
        }
        
    }

    
    func HTTPDelete(url: String, callback: (NSData, NSError?) -> Void) {
        
        request.url = NSURL(string: url)!
        request.httpMethod = "DELETE"
        
        taskManager() { data, error in
            callback(data, error)
        }
    }
    
    func taskManager(callback: (NSData, NSError?) -> Void) {
        
        let task = session.dataTask(with: request as NSURLRequest) {
            data, response, error in
            
            dispatch_async(dispatch_get_main_queue()) {
                UIApplication.shared().isNetworkActivityIndicatorVisible = false
            }
            
            if let error = error {
                print(error.localizedDescription)
                
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    callback(data!, error)
                }
            }
            
            
        };
        
        task.resume();
    }
}



