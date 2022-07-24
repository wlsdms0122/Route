//
//  MainViewController.swift
//  present
//
//  Created by JSilver on 2020/06/18.
//  Copyright © 2020 JSilver. All rights reserved.
//

import UIKit
import Represent
import RxSwift
import RxCocoa
import JSToast

class MainViewController: UIViewController {
    // MARK: - View
    private let root = MainView()
    
    private var idLabel: UILabel { root.idLabel }
    private var idStepper: UIStepper { root.idStepper }
    private var routeButton: UIButton { root.routeButton }
    private var logButton: UIButton { root.logButton }
    
    private var presentNavigationButton: UIButton { root.presentNavigationButton }
    private var presentTabButton: UIButton { root.presentTabButton }
    private var pushButton: UIButton { root.pushButton }

    // MARK: - Property
    private let disposeBag = DisposeBag()
    
    private var newWindow: UIWindow?
    
    // MARK: - Initializer
    init() {
        super.init(nibName: nil, bundle: nil)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        view = root
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idLabel.text = title
        idStepper.value = Double(title ?? "") ?? 0
    }
    
    // MARK: - Public
    
    // MARK: - Private
    private func bind() {
        idStepper.rx.value
            .map { "\(Int($0))" }
            .bind(to: idLabel.rx.text)
            .disposed(by: disposeBag)
        
        routeButton.rx.tap
            .withLatestFrom(idStepper.rx.value)
            .map { Int($0) }
            .subscribe(onNext: { [weak self] id in
                self?.route(animated: true) {
                    $0.title == "\(id)"
                } completion: { [weak self] in
                    guard let viewController = $0?.topMostViewController else {
                        self?.showToast(message: "Fail to route to \(id).")
                        return
                    }
                    
                    self?.showToast(
                        message: """
                        Success to route to \(id).
                        Current presented view controller is \(viewController.title ?? "UNKNOWN").
                        """
                    )
                    
                    if let id = Int(viewController.title ?? "") {
                        count = id + 1
                    }
                }
            })
            .disposed(by: disposeBag)
        
        logButton.rx.tap
            .subscribe(onNext: { [weak self] in
                print(self?.superViewController.subViewControllers)
            })
            .disposed(by: disposeBag)
        
        presentNavigationButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.presentNavigationController(id: count)
                count += 2
            })
            .disposed(by: disposeBag)
        
        presentTabButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.presentTabBarController(id: count)
                count += 7
            })
            .disposed(by: disposeBag)
        
        pushButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.pushController(id: count)
                count += 1
            })
            .disposed(by: disposeBag)
    }
    
    private func presentNavigationController(id: Int) {
        let viewController = MainViewController()
        viewController.title = "\(id + 1)"
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.title = "\(id)"
        
        present(navigationController, animated: true, completion: nil)
    }
    
    private func presentTabBarController(id: Int) {
        let viewController1 = MainViewController()
        viewController1.title = "\(id + 3)"
        
        let navigationController1 = UINavigationController(rootViewController: viewController1)
        navigationController1.title = "\(id + 2)"
        navigationController1.tabBarItem = UITabBarItem(
            title: "\(id + 2)",
            image: UIImage(systemName: "circle"),
            selectedImage: UIImage(systemName: "circle.fill")
        )
        
        let viewController2 = MainViewController()
        viewController2.title = "\(id + 5)"
        
        let navigationController2 = UINavigationController(rootViewController: viewController2)
        navigationController2.title = "\(id + 4)"
        navigationController2.tabBarItem = UITabBarItem(
            title: "\(id + 4)",
            image: UIImage(systemName: "circle"),
            selectedImage: UIImage(systemName: "circle.fill")
        )
        
        let viewController3 = MainViewController()
        viewController3.title = "\(id + 7)"
        
        let navigationController3 = UINavigationController(rootViewController: viewController3)
        navigationController3.title = "\(id + 6)"
        navigationController3.tabBarItem = UITabBarItem(
            title: "\(id + 6)",
            image: UIImage(systemName: "circle"),
            selectedImage: UIImage(systemName: "circle.fill")
        )
        
        let tabBarController = UITabBarController()
        tabBarController.title = "\(id + 1)"
        tabBarController.viewControllers = [
            navigationController1,
            navigationController2,
            navigationController3
        ]
        
        let navigationController = UINavigationController(rootViewController: tabBarController)
        navigationController.title = "\(id)"
        
        present(navigationController, animated: true, completion: nil)
    }
    
    private func pushController(id: Int) {
        let viewController = MainViewController()
        viewController.title = "\(id)"
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showToast(message: String) {
        Toaster.shared.showToast(
            Toast(ToastView(message: message)),
            withDuration: 3,
            positions: [
                .inside(of: .top),
                .center(of: .x)
            ]
        )
    }
}
