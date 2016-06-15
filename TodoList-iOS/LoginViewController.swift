//
//  LoginViewController.swift
//  TodoList-iOS
//
//  Created by Aaron Liberatore on 6/10/16.
//  Copyright © 2016 Swift@IBM Engineering. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    /// Loading indicator when connecting to Facebook
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    /// Button to allow user to sign in with Facebook
    @IBOutlet weak var facebookButton: FBSDKLoginButton!
    
    /// Label to show an error if authentication is unsuccessful
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        if (FBSDKAccessToken.current() != nil) {
            
            dispatch_async(dispatch_get_main_queue()) {
                [unowned self] in
                self.performSegue(withIdentifier: "todolist", sender: self)
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        configureFacebook()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureFacebook()
    {
        facebookButton.readPermissions = ["public_profile", "email"];
        facebookButton.delegate = self
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        FBSDKGraphRequest.init(graphPath: "me",
                               parameters: ["fields":"first_name, last_name, email"]).start { (connection, result, error) -> Void in
            // Process error
            if ((error) != nil) {
                print("Error: \(error)")
            } else {
                let first: String = (result.objectFor("first_name") as? String)!
                let last: String = (result.objectFor("last_name") as? String)!
                let email: String = (result.objectFor("email") as? String)!
                print("Hi", first,last, email)
                self.welcomeLabel.text = "Welcome, \(first) \(last)"
                
            }
                                
        }
        
        
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!){}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
