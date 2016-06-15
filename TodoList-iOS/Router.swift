//
//  Router.swift
//  TodoList-iOS
//
//  Created by Aaron Liberatore on 6/14/16.
//  Copyright © 2016 Swift@IBM Engineering. All rights reserved.
//

import UIKit

class Router: NSObject {
    let url = NSURL(string: "http://localhost:8090")
    
    func HTTPGet(url: String, callback: (Dictionary<String, AnyObject>, NSError?) -> Void) {
        
        
        let session = NSURLSession.shared();
        let request : NSMutableURLRequest = NSMutableURLRequest();
        
        request.url = NSURL(string: url)!
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request as NSURLRequest) {
            data, response, error in
            
            dispatch_async(dispatch_get_main_queue()) {
                UIApplication.shared().isNetworkActivityIndicatorVisible = false
            }
            
            error != nil ? callback(Dictionary<String, AnyObject>(), error) : callback(self.JSONToDict(string: String(data: data!, encoding: NSUTF8StringEncoding)!), nil)
        };
        task.resume();
    }
    
     // Task: Executes an HTTP POST request to the destination url
     // containing the given json serializable object
    
    func HTTPPost(url: String,
                      jsonObj: AnyObject,
                      callback: (NSData, NSError?) -> Void) {
        let session = NSURLSession.shared();
        let request : NSMutableURLRequest = NSMutableURLRequest();
        
        request.url = NSURL(string: url)!
        request.httpMethod = "POST"
        request.httpBody = jsonObj.data(using: NSUTF8StringEncoding)!
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request as NSURLRequest) {
            data, response, error in
            
            dispatch_async(dispatch_get_main_queue()) {
                UIApplication.shared().isNetworkActivityIndicatorVisible = false
            }
            
            callback(data!, error)
            
        };
        task.resume();
        
    }
    
    func HTTPPatch(url: String,
                      jsonObj: AnyObject,
                      callback: (NSData, NSError?) -> Void) {
        let session = NSURLSession.shared();
        let request : NSMutableURLRequest = NSMutableURLRequest();
        
        request.url = NSURL(string: url)!
        request.httpMethod = "PATCH"
        request.httpBody = jsonObj.data(using: NSUTF8StringEncoding)!
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request as NSURLRequest) {
            data, response, error in
            
            dispatch_async(dispatch_get_main_queue()) {
                UIApplication.shared().isNetworkActivityIndicatorVisible = false
            }
            
            callback(data!, error)
            
        };
        task.resume();
        
    }

    
    func HTTPDelete(url: String, callback: (String, String?) -> Void) {
        let session = NSURLSession.shared();
        let request : NSMutableURLRequest = NSMutableURLRequest();
        
        request.url = NSURL(string: url)!
        request.httpMethod = "DELETE"
        
        let task = session.dataTask(with: request as NSURLRequest) {
            data, response, error in
        
            dispatch_async(dispatch_get_main_queue()) {
                UIApplication.shared().isNetworkActivityIndicatorVisible = false
            }
        
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                print(data)
            }
        
        };
        task.resume();
    }
    
    // Purpose: Converts a serialized json string to a dictionary!
    
    func JSONToDict(string: String) -> [String: AnyObject]{
        
        if let data = string.data(using: NSUTF8StringEncoding){
            
            do {
                if let dictionary = try NSJSONSerialization.jsonObject(with: data, options: NSJSONReadingOptions.mutableContainers) as? [String: AnyObject]{
                    
                    return dictionary
                    
                }
            } catch {
                
                print("error")
                
            }
        }
        return [String: AnyObject]()
    }
}



