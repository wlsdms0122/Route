//
//  IDTabBarController.swift
//  represent-sample
//
//  Created by JSilver on 2022/11/11.
//  Copyright © 2022 JSilver. All rights reserved.
//

import UIKit

class IDTabBarController: UITabBarController, Identifiable {
    // MARK: - Property
    let id: Int
    
    // MARK: - Initializer
    init(id: Int, viewControllers: [UIViewController]) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
        
        self.viewControllers = viewControllers

        title = String(id)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycel
    
    // MARK: - Public
    
    // MARK: - Private
}
