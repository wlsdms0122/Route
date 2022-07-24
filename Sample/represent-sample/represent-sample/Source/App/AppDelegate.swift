//
//  AppDelegate.swift
//  present
//
//  Created by JSilver on 2020/06/18.
//  Copyright © 2020 JSilver. All rights reserved.
//

import UIKit

var count = 2

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        let viewController = MainViewController()
        viewController.title = "\(1)"
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.title = "\(0)"
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        self.window = window
        return true
    }
}

