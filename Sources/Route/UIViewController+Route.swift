//
//  UIViewController+Route.swift
//  Route
//
//  Created by JSilver on 2020/06/19.
//  Copyright © 2020 JSilver. All rights reserved.
//

import UIKit

extension UIViewController {
    /// Route to a view controller that satisfies compare statement in receiver's children.
    ///
    /// ```
    /// route(animated: true) {
    ///     $0 is SomeViewController
    /// } completion {
    ///     guard let viewController = $0 else {
    ///         // Fail to route. view controlelr that satisfies the compare statements not found.
    ///         return
    ///     }
    ///     // Success to route.
    /// }
    /// ```
    public func route(
        animated: Bool,
        where predicate: (UIViewController) -> Bool,
        completion: ((UIViewController?) -> Void)? = nil
    ) {
        guard let viewController = search(where: predicate).last else {
            // Not exist view controller that satisfies the compare statement.
            completion?(nil)
            return
        }
        
        // Found view controller that satisfies the compare statement.
        guard viewController.presentedViewController != nil else {
            viewController.route(animated: animated) { [weak viewController] in completion?(viewController) }
            return
        }
        
        // Dismiss child view controller
        viewController.dismiss(animated: animated) { [weak viewController] in
            viewController?.route(animated: animated) { completion?(viewController) }
        }
    }
    
    /// Route to a view controller. if it exist in receiver's children.
    public func route<ViewController: UIViewController>(
        to viewControlelr: ViewController,
        animated: Bool,
        completion: ((ViewController?) -> Void)? = nil
    ) {
        route(
            animated: animated,
            where: { $0 == viewControlelr },
            completion: { completion?($0 as? ViewController) }
        )
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
    
    /// Search view controller that compared by closure in receiver's children.
    ///
    /// ```
    /// let viewController = search { $0 is SomeViewController }
    /// ```
    public func search(where predicate: (UIViewController) -> Bool) -> [UIViewController] {
        let allViewControllers = allViewControllers
        
        guard let startIndex = allViewControllers.firstIndex(of: self) else {
            return []
        }
        
        let endIndex = allViewControllers.endIndex
        let subViewControllers = allViewControllers[ startIndex ..< endIndex]
        
        return subViewControllers.filter(predicate)
    }
    
    public func search<ViewController: UIViewController>(of viewController: ViewController) -> ViewController? {
        search { $0 == viewController }
            .first as? ViewController
    }
    
    public func search<ViewController>(of type: ViewController.Type) -> [ViewController] {
        search { $0 is ViewController }
            .compactMap { $0 as? ViewController }
    }
    
    public var allViewControllers: [UIViewController] {
        let superViewController = superViewController
        
        return [superViewController] + superViewController.subViewControllers
    }
    
    private var superViewController: UIViewController {
        guard let parent = presentingViewController ?? parent else { return self }
        return parent.superViewController
    }
    
    private var subViewControllers: [UIViewController] {
        guard let presented = presentedViewController else {
            return descendants
        }
        
        return descendants + [presented] + presented.subViewControllers
    }
    
    private var descendants: [UIViewController] {
        children.flatMap { [$0] + $0.descendants }
    }
}
