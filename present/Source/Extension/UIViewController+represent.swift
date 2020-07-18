//
//  UIViewController+represent.swift
//  present
//
//  Created by JSilver on 2020/06/19.
//  Copyright © 2020 JSilver. All rights reserved.
//

import UIKit

extension UIViewController {
    func represent(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil, compare: (UIViewController) -> Bool) {
        UIViewController.route(animated: animated, compare: compare) { [weak self] isRouteSuccess in
            guard !isRouteSuccess else {
                completion?()
                return
            }
            
            self?.present(viewController, animated: animated) { completion?() }
        }
    }
    
    /// Route to view controller of controller stack that search with compare closure.
    static func route(animated: Bool, compare: (UIViewController) -> Bool, completion: ((Bool) -> Void)? = nil) {
        guard let viewController = UIViewController.search(compare) else {
            completion?(false)
            return
        }
        viewController.route(animated: animated) { completion?(true) }
    }
    
    /// Route to view controller with animation or not
    private func route(animated: Bool, completion: (() -> Void)?) {
        if presentedViewController != nil {
            // Dismiss child view controller if view controller already presented.
            dismiss(animated: animated, completion: completion)
        }
        
        route(parent: parent, animated: animated)
        completion?()
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
