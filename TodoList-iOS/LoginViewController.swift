//
//  LoginViewController.swift
//  TodoList-iOS
//
//  Created by Aaron Liberatore on 6/10/16.
//  Copyright © 2016 Swift@IBM Engineering. All rights reserved.
//

import UIKit
//import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    /// Loading indicator when connecting to Facebook
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    /// Button to allow user to sign in with Facebook
    @IBOutlet weak var facebookButton: UIButton! = UIButton()//FBSDKLoginButton! = FBSDKLoginButton()
    
    /// Label to show an error if authentication is unsuccessful
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
