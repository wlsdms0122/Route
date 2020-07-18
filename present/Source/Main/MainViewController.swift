//
//  MainViewController.swift
//  present
//
//  Created by JSilver on 2020/06/18.
//  Copyright © 2020 JSilver. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    // MARK: - Layout
    private var root: MainView { view as! MainView }
    
    private var presentingLabel: UILabel { root.presentingLabel }
    
    private var idLabel: UILabel { root.idLabel }
    private var idStepper: UIStepper { root.idStepper }
    private var representButton: UIButton { root.representButton }
    
    private var presentNavigationButton: UIButton { root.presentNavigationButton }
    private var presentTabButton: UIButton { root.presentTabButton }
    private var pushButton: UIButton { root.pushButton }

    // MARK: - Property
    private let disposeBag = DisposeBag()
    
    let id: Int
    
    // MARK: - Constructor
    init(id: Int) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        view = MainView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(id)"
        idLabel.text = "\(id)"
        idStepper.value = Double(id)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presentingLabel.text = presentingViewController?.title
    }
    
    // MARK: - Private
    func bind() {
        idStepper.rx.value
            .map { "\(Int($0))" }
            .bind(to: idLabel.rx.text)
            .disposed(by: disposeBag)
        
        representButton.rx.tap
            .compactMap { [weak self] in self?.idStepper.value }
            .map { Int($0) }
            .subscribe(onNext: { [weak self] id in
//                let viewController = UINavigationController(rootViewController: MainViewController(id: id))
                UIViewController.route(animated: true) {
                    ($0 as? MainViewController)?.id == id
                } completion: {
                    if $0 {
                        count = id
                    }
                }
//                self?.repush(viewController, animated: true, completion: {
//                    guard $0 else { return }
//                    count = id
//                }) { current, _ in
//                    guard let lhs = current as? MainViewController else { return false }
//                    return lhs.id == id
//                }
            })
            .disposed(by: disposeBag)
        
        presentNavigationButton.rx.tap
            .subscribe(onNext: { [weak self] in
                count += 1
                let viewController = MainViewController(id: count)
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.title = "Navigation \(count)"
                self?.present(navigationController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        presentTabButton.rx.tap
            .subscribe(onNext: { [weak self] in
                count += 1
                let viewController1 = UINavigationController(rootViewController: MainViewController(id: count))
                count += 1
                let viewController2 = UINavigationController(rootViewController: MainViewController(id: count))
                count += 1
                let viewController3 = UINavigationController(rootViewController: MainViewController(id: count))
                
                let tabBarController = UITabBarController()
                tabBarController.title = "Tab \(count - 2)"
                tabBarController.viewControllers = [
                    viewController1,
                    viewController2,
                    viewController3
                ]
                
                let navigationController = UINavigationController(rootViewController: tabBarController)
                self?.present(navigationController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        pushButton.rx.tap
            .subscribe(onNext: { [weak self] in
                count += 1
                self?.navigationController?.pushViewController(MainViewController(id: count), animated: true)
            })
            .disposed(by: disposeBag)
    }
}

