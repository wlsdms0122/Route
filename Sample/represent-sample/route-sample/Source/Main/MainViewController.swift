//
//  MainViewController.swift
//  present
//
//  Created by JSilver on 2020/06/18.
//  Copyright © 2020 JSilver. All rights reserved.
//

import UIKit
import Route
import RxSwift
import RxCocoa
import JSToast

struct SectionDataSource {
    let section: [MainSection]
    
    init(_ section: [MainSection] = []) {
        self.section = section
    }
    
    subscript(indexPath: IndexPath) -> MainItem {
        section[indexPath.section].items[indexPath.item]
    }
}

struct MainSection {
    let model: MainModel
    let items: [MainItem]
    
    init(
        model: MainModel = MainModel(),
        items: [MainItem]
    ) {
        self.model = model
        self.items = items
    }
}

struct MainModel {
    let title: String?
    let description: String?
    
    init(
        title: String? = nil,
        description: String? = nil
    ) {
        self.title = title
        self.description = description
    }
}

enum MainItem {
    case id(Int)
    case allStack([Int])
    case step(value: Int, handler: (Int) -> Void)
    case route
    case log
    case presentNavigation
    case presentTabBar
    case push
}

class MainViewController: UIViewController, Identifiable {
    // MARK: - View
    private let root = MainView()
    
    private var tableView: UITableView { root.tableView }

    // MARK: - Property
    private var dataSource = SectionDataSource()
    
    private var routeID: Int
    private var logID: Int
    let id: Int
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    init(id: Int) {
        self.id = id
        self.routeID = id
        self.logID = id
        super.init(nibName: nil, bundle: nil)
        
        setUp()
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
        
        updateDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateDataSource()
    }
    
    // MARK: - Public
    
    // MARK: - Private
    private func setUp() {
        setUpLayout()
        setUpState()
        setUpAction()
    }
    
    private func setUpLayout() {
        
    }
    
    private func setUpState() {
        title = String(id)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setUpAction() {
        
    }
    
    private func updateDataSource() {
        dataSource = SectionDataSource([
            .init(
                model: .init(
                    title: "IDENTIFICATION"
                ),
                items: [
                    .id(id),
                    .allStack(
                        allViewControllers.compactMap(\.identifier)
                    )
                ]
            ),
            .init(
                model: .init(
                    title: "ROUTING"
                ),
                items: [
                    .step(value: routeID, handler: { [weak self] in
                        self?.routeID = $0
                    }),
                    .route
                ]
            ),
            .init(
                model: .init(
                    title: "LOG"
                ),
                items: [
                    .step(value: logID, handler: { [weak self] in
                        self?.logID = $0
                    }),
                    .log
                ]
            ),
            .init(
                model: .init(
                    title: "ROUTING"
                ),
                items: [
                    .presentNavigation,
                    .presentTabBar,
                    .push
                ]
            )
        ])
        
        tableView.reloadData()
    }
    
    private func route(to id: Int) {
        rootViewController.route(animated: true) {
            $0.identifier == id
        } completion: { [weak self] in
            guard let viewController = $0 else {
                self?.showToast(message: "Fail to route. Not found \(id) view controller.")
                return
            }
            
            self?.showToast(
                message: """
                Success to route.
                
                \(viewController)
                """
            )
        }
    }
    
    private func printLog(id: Int) {
        guard let viewController = allViewControllers.first(where: { $0.identifier == id })
        else {
            print(
                """
                
                Not found \(id) view controller.
                """
            )
            return
        }
        
        let allViewControllers = viewController.allViewControllers.compactMap(\.identifier)
        
        print(
            """
            
            ❏ All view controllers: \(allViewControllers)
            ❏ Log view controller: \(id)
            ❏ Current view controller: \(self.id)
            """
        )
    }
    
    private func presentNavigationController() {
        let viewController = IDNavigationController(
            id: AppDelegate.getID(),
            rootViewController: MainViewController(id: AppDelegate.getID())
        )
        
        present(
            viewController,
            animated: true
        )
    }
    
    private func presentTabBarController() {
        let viewController = IDNavigationController(
            id: AppDelegate.getID(),
            rootViewController: IDTabBarController(
                id: AppDelegate.getID(),
                viewControllers: [
                    IDNavigationController(
                        id: AppDelegate.getID(),
                        rootViewController: MainViewController(id: AppDelegate.getID())
                    ),
                    IDNavigationController(
                        id: AppDelegate.getID(),
                        rootViewController: MainViewController(id: AppDelegate.getID())
                    ),
                    IDNavigationController(
                        id: AppDelegate.getID(),
                        rootViewController: MainViewController(id: AppDelegate.getID())
                    )
                ]
            )
        )
        
        present(
            viewController,
            animated: true
        )
    }
    
    private func pushController() {
        let viewController = MainViewController(id: AppDelegate.getID())
        
        navigationController?.pushViewController(
            viewController,
            animated: true
        )
    }
    
    private func showToast(message: String) {
        Toaster.shared.showToast(
            Toast(ToastView(message: message)),
            withDuration: 3,
            positions: [
                .inside(of: .top),
                .center(of: .x)
            ],
            boundary: .init(top: 8, left: 8, bottom: 8, right: 8),
            showAnimator: .slideIn(duration: 0.1, direction: .down)
        )
    }
    
    deinit {
        print("\(id) View controller deinited.")
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        dataSource.section.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.section[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataSource[indexPath]
        
        switch item {
        case let .id(id):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else { fatalError() }
            
            cell.configure(title: "ID", description: String(id))
            
            return cell
            
        case let .allStack(stack):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else { fatalError() }
            
            cell.configure(title: "All Stack", description: stack.description)
            
            return cell
            
        case let .step(value, handler):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainStepTableViewCell", for: indexPath) as? MainStepTableViewCell else { fatalError() }
            
            cell.configure(
                value: value,
                range: (0 ..< .max)
            ) {
                handler($0)
            }
            
            return cell
            
        case .route:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainActionTableViewCell", for: indexPath) as? MainActionTableViewCell else { fatalError() }
            
            cell.configure(title: "Route")
            
            return cell
            
        case .log:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainActionTableViewCell", for: indexPath) as? MainActionTableViewCell else { fatalError() }
            
            cell.configure(title: "Print Log")
            
            return cell
            
        case .presentNavigation:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainActionTableViewCell", for: indexPath) as? MainActionTableViewCell else { fatalError() }
            
            cell.configure(title: "Present Navigation Controller")
            
            return cell
            
        case .presentTabBar:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainActionTableViewCell", for: indexPath) as? MainActionTableViewCell else { fatalError() }
            
            cell.configure(title: "Present Tab Bar Controller")
            
            return cell
            
        case .push:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainActionTableViewCell", for: indexPath) as? MainActionTableViewCell else { fatalError() }
            
            cell.configure(title: "Push")
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        dataSource.section[section].model.title
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        dataSource.section[section].model.description
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let item = dataSource[indexPath]
        
        switch item {
        case .id,
            .allStack,
            .step:
            return nil
            
        default:
            return indexPath
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSource[indexPath]
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch item {
        case .route:
            route(to: routeID)
            
        case .log:
            printLog(id: logID)
            
        case .presentNavigation:
            presentNavigationController()
            
        case .presentTabBar:
            presentTabBarController()
            
        case .push:
            pushController()
            
        default:
            break
        }
    }
}

extension UIViewController {
    var identifier: Int? { (self as? any Identifiable<Int>)?.id }
    
    var rootViewController: UIViewController { allViewControllers.first ?? self }
}
