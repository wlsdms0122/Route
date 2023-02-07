//
//  IDNavigationController.swift
//  route-sample
//
//  Created by JSilver on 2022/11/11.
//  Copyright © 2022 JSilver. All rights reserved.
//

import UIKit

class IDNavigationController: UINavigationController, Identifiable {
    // MARK: - Property
    let id: Int
    
    // MARK: - Initializer
    init(id: Int, rootViewController: UIViewController) {
        self.id = id
        super.init(rootViewController: rootViewController)
        
        title = String(id)
        tabBarItem = UITabBarItem(
            title: String(id),
            image: UIImage(systemName: "circle"),
            selectedImage: UIImage(systemName: "circle.fill")
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycel
    
    // MARK: - Public
    
    // MARK: - Private
    
    deinit {
        print("\(id) View controller deinited.")
    }
}

