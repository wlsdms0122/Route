//
//  UIViewController+represent.swift
//  present
//
//  Created by JSilver on 2020/06/19.
//  Copyright © 2020 JSilver. All rights reserved.
//

import UIKit

extension UIViewController {
    /// Re present the view controller. If the view controller is already exist, route to the view controller by compare closure.
    /// Or not, present the view controller.
    /// completion closure pass the view controller one of presented view controller or routed view controller
    func represent(_ viewController: UIViewController, animated: Bool, compare: (UIViewController) -> Bool, completion: ((UIViewController) -> Void)? = nil) {
        UIViewController.route(animated: animated, compare: compare) { [weak self] destinationViewController in
            guard let destinationViewController = destinationViewController else {
                self?.present(viewController, animated: animated) { completion?(viewController) }
                return
            }
            
            completion?(destinationViewController)
        }
    }
    
    /// Route to view controller of controller stack that search with compare closure.
    static func route(animated: Bool, compare: (UIViewController) -> Bool, completion: ((UIViewController?) -> Void)? = nil) {
        guard let viewController = UIViewController.search(compare) else {
            completion?(nil)
            return
        }
        
        viewController.route(animated: animated) { completion?(viewController) }
    }
    
    /// Route to view controller with animation or not
    private func route(animated: Bool, completion: @escaping () -> Void) {
        guard presentedViewController != nil else {
            route(parent: parent, animated: animated, completion: completion)
            return
        }
        
        // Dismiss child view controller if view controller already presented.
        dismiss(animated: animated) { [self] in
            route(parent: parent, animated: animated, completion: completion)
        }
    }
    
    private func route(parent: UIViewController?, animated: Bool, completion: () -> Void) {
        guard let parent = parent else {
            completion()
            return
        }
        
        switch parent {
        case let tabBarController as UITabBarController:
            tabBarController.selectedViewController = self
            
        case let navigationController as UINavigationController:
            navigationController.popToViewController(self, animated: animated)
            
        default:
            break
        }
        
        parent.route(parent: parent.parent, animated: animated, completion: completion)
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
    
    private var subControllers: [UIViewController] {
        children.reduce([self]) { $0 + $1.subControllers }
    }
}
