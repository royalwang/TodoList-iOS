/**
 * Copyright IBM Corporation 2016
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import UIKit

class User: NSObject {
    
    /// Grab facebook user id of user from NsUserDefaults
    class var facebookUserId: String {
        get {
            if let userId = NSUserDefaults.standard().object(forKey: "facebook_user_id") as? String {
                return userId
            } else {
                return "Not Set"
            }
        }
        set(userId) {
            
            NSUserDefaults.standard().set(userId, forKey: "facebook_user_id")
            NSUserDefaults.standard().synchronize()
        }
    }
    
    /// grab full name of user from NSUserDefaults
    class var fullName: String {
        get {
            if let userId = NSUserDefaults.standard().object(forKey: "user_full_name") as? String {
                return userId
            } else {
                return "Not Set"
            }
        }
        set(user_full_name) {
            
            NSUserDefaults.standard().set(user_full_name, forKey: "user_full_name")
            NSUserDefaults.standard().synchronize()
        }
        
    }
    /// grab full name of user from NSUserDefaults
    class var email: String {
        get {
            if let userId = NSUserDefaults.standard().object(forKey: "user_email") as? String {
                return userId
            } else {
                return "Not Set"
            }
            
        }
        set(user_full_name) {
            
            NSUserDefaults.standard().set(user_full_name, forKey: "user_email")
            NSUserDefaults.standard().synchronize()
        }
        
    }
}
