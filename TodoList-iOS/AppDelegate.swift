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
import FBSDKLoginKit

//
//  AppDelegate.swift
//  TestAppDelegate
//
//  Created by Chia Huang on 9/9/16.
//  Copyright © 2016 Chia Huang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Set Themes and Styling
        ThemeManager.setupStyling()
        let theme = ThemeManager.currentTheme()
        ThemeManager.applyTheme(theme: theme)

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

    private func application(_ application: UIApplication,
                             willFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?)
        -> Bool {
            // Override point for customization after application launch.
            return FBSDKApplicationDelegate.sharedInstance()
                .application(application,
                             didFinishLaunchingWithOptions: launchOptions)
    }

    func applicationWillTerminate(application: UIApplication) {
        /* Called when the application is about to terminate. Save data if appropriate.
         See also applicationDidEnterBackground:. */
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }

    private func application(_ application: UIApplication,
                             open url: URL,
                             sourceApplication: String?,
                             annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance()
            .application(application,
                         open: url,
                         sourceApplication: sourceApplication,
                         annotation: annotation)
    }
}

//
//
//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//    var window: UIWindow?
//
//    @objc(application:didFinishLaunchingWithOptions:)
//        private func application(_ application: UIApplication,
//                     didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
//
//        // Set Themes and Styling
//        ThemeManager.setupStyling()
//        let theme = ThemeManager.currentTheme()
//        ThemeManager.applyTheme(theme: theme)
//
//        return true
//    }
//
//    @objc(applicationWillResignActive:)
//        func applicationWillResignActive(_ application: UIApplication) {
//        /* Sent when the application is about to move from active to inactive state.
//         This can occur for certain types of temporary interruptions (such as an incoming
//         phone call or SMS message) or when the user quits the application and it begins
//         the transition to the background state.
//
//         Use this method to pause ongoing tasks, disable timers, and throttle
//         down OpenGL ES frame rates. Games should use this method to pause the game. */
//    }
//
//    @objc(applicationDidEnterBackground:)
//        func applicationDidEnterBackground(_ application: UIApplication) {
//        /* Use this method to release shared resources, save user data, invalidate
//         timers, and store enough application state information to restore your
//         application to its current state in case it is terminated later.
//         If your application supports background execution, this method is
//         called instead of applicationWillTerminate: when the user quits. */
//    }
//
//    @objc(applicationWillEnterForeground:)
//        func applicationWillEnterForeground(_ application: UIApplication) {
//        /* Called as part of the transition from the background to the inactive state;
//         here you can undo many of the changes made on entering the background. */
//    }
//
//    @objc(applicationDidBecomeActive:)
//        func applicationDidBecomeActive(_ application: UIApplication) {
//        /* Restart any tasks that were paused (or not yet started)
//         while the application was inactive. If the application was
//         previously in the background, optionally refresh the user interface. */
//    }
//
//    @objc(applicationWillTerminate:) func applicationWillTerminate(_ application: UIApplication) {
//        /* Called when the application is about to terminate.
//         Save data if appropriate. See also applicationDidEnterBackground:. */
//    }
//}
