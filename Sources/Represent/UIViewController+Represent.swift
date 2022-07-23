//
//  UIViewController+represent.swift
//  present
//
//  Created by JSilver on 2020/06/19.
//  Copyright © 2020 JSilver. All rights reserved.
//

import UIKit

public extension UIViewController {
    /// Re present the view controller.
    /// If the view controller is already exist in stack, route to the view controller that satisfies compare statement.
    /// Or not, present the view controller.
    ///
    /// Completion closure pass the view controller one of presented view controller or routed view controller.
    func represent(
        _ viewController: UIViewController,
        animated: Bool,
        compare: (UIViewController) -> Bool,
        completion: ((UIViewController) -> Void)? = nil
    ) {
        // Route to the view controller that satisfies the compare statement.
        route(
            animated: animated,
            compare: compare
        ) { [weak self] destination in
            guard let destination = destination else {
                // If fail to route, present the passed view controller.
                self?.present(viewController, animated: animated) { completion?(viewController) }
                return
            }
            
            // If succes to route, pass found view controller to completion handler.
            completion?(destination)
        }
    }
    
    /// Route to the view controller that satisfies compare statement in requested view controller's stack.
    ///
    /// ```
    /// route(animated: true) {
    ///     $0 is SomeViewController
    /// } completion {
    ///     guard let viewController = $0 else {
    ///         // Fail to route. not exist view controller
    ///         // that satisfies the compare statements.
    ///         return
    ///     }
    ///     // Success to route.
    /// }
    /// ```
    func route(
        animated: Bool,
        compare: (UIViewController) -> Bool,
        completion: ((UIViewController?) -> Void)? = nil
    ) {
        guard let viewController = search(compare).last else {
            // Not exist view controller that satisfies the compare statement.
            completion?(nil)
            return
        }
        
        // Found view controller that satisfies the compare statement.
        guard viewController.presentedViewController != nil else {
            viewController.route(animated: animated) { completion?(viewController) }
            return
        }
        
        // Dismiss child view controller
        viewController.dismiss(animated: animated) {
            viewController.route(animated: animated) { completion?(viewController) }
        }
    }
    
    private func route(animated: Bool, completion: () -> Void) {
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
        
        parent.route(animated: animated, completion: completion)
    }
    
    /// Search view controller that compared by closure.
    ///
    /// ```
    /// let viewController = search { $0 is SomeViewController }
    /// ```
    func search(_ compare: (UIViewController) -> Bool) -> [UIViewController] {
        allViewControllers.filter(compare)
    }
    
    var topMostViewController: UIViewController {
        subViewControllers.last ?? self
    }
    
    var allViewControllers: [UIViewController] {
        [superViewController] + superViewController.subViewControllers
    }
    
    var superViewController: UIViewController {
        guard let parent = presentingViewController ?? parent else { return self }
        return parent.superViewController
    }
    
    var subViewControllers: [UIViewController] {
        guard let presented = presentedViewController else {
            return descendants
        }
        
        return descendants + [presented] + presented.subViewControllers
    }
    
    var descendants: [UIViewController] {
        children.flatMap { [$0] + $0.descendants }
    }
}
