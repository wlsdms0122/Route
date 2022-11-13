//
//  AppDelegate.swift
//  present
//
//  Created by JSilver on 2020/06/18.
//  Copyright © 2020 JSilver. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    static private(set) var id: Int = 0
    static func getID() -> Int {
        defer {
            id += 1
        }
        return id
    }
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        let navigationController = IDNavigationController(
            id: AppDelegate.getID(),
            rootViewController: MainViewController(id: AppDelegate.getID())
        )
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        self.window = window
        return true
    }
}

