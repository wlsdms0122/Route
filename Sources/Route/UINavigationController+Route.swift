//
//  UINavigationController+Route.swift
//
//
//  Created by jsilver on 7/2/24.
//

import UIKit

public extension UINavigationController {
    func viewControllers(until viewController: UIViewController) -> [UIViewController] {
        let startIndex = viewControllers.startIndex
        let endIndex = viewControllers.firstIndex(of: viewController) ?? viewControllers.endIndex
        
        guard !viewControllers.isEmpty else { return viewControllers }
        
        return Array(viewControllers[startIndex...endIndex])
    }
}
