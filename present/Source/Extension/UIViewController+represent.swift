//
//  UIViewController+represent.swift
//  present
//
//  Created by JSilver on 2020/06/19.
//  Copyright © 2020 JSilver. All rights reserved.
//

import UIKit

extension UIViewController {
    func represent(_ viewController: UIViewController, animated: Bool, completion: ((Bool) -> Void)? = nil, compare: ((UIViewController) -> Bool)? = nil) {
        let isRouteSuccess: Bool
        if let compare = compare {
            isRouteSuccess = UIViewController.route(animated: animated, compare: compare)
        } else {
            isRouteSuccess = UIViewController.route(viewController, animated: animated)
        }
        
        guard !isRouteSuccess else {
            completion?(false)
            return
        }
        
        present(viewController, animated: animated) { completion?(true) }
    }
    
    /// Route to view controller of controller stack that equal with passed view controller.
    static func route(_ viewController: UIViewController, animated: Bool) -> Bool {
        UIViewController.route(animated: animated) { $0 == viewController }
    }
    
    /// Route to view controller of controller stack that search with compare closure.
    static func route(animated: Bool, compare: (UIViewController) -> Bool) -> Bool {
        guard let viewController = UIViewController.search(compare) else { return false }
        viewController.route(animated: animated)
        return true
    }
    
    /// Route to view controller with animation or not
    private func route(animated: Bool) {
        if presentedViewController != nil {
            // Dismiss child view controller if view controller already presented.
            dismiss(animated: animated, completion: nil)
        }
        
        route(parent: parent, animated: animated)
    }
    
    private func route(parent: UIViewController?, animated: Bool) {
        guard let parent = parent else { return }
        
        switch parent {
        case let tabBarController as UITabBarController:
            tabBarController.selectedViewController = self
            
        case let navigationController as UINavigationController:
            navigationController.popToViewController(self, animated: animated)
            
        default:
            break
        }
        
        parent.route(parent: parent.parent, animated: animated)
    }
    
    /// Search view controller that equal with passed view controller.
    static func search(_ viewController: UIViewController) -> UIViewController? {
        UIViewController.allControllers.filter { $0 == viewController }.last
    }
    
    /// Search view controller that compared by closure.
    static func search(_ compare: (UIViewController) -> Bool) -> UIViewController? {
        UIViewController.allControllers.filter(compare).last
    }
    
    static var allControllers: [UIViewController] {
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else { return [] }
        var viewControllers = rootViewController.subControllers
        
        var viewController = rootViewController
        while let presented = viewController.presentedViewController {
            viewControllers += presented.subControllers
            viewController = presented
        }

        return viewControllers
    }
    
    var subControllers: [UIViewController] {
        children.reduce([self]) { $0 + $1.subControllers }
    }
}
