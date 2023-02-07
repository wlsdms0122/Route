//
//  MainView.swift
//  present
//
//  Created by JSilver on 2020/06/18.
//  Copyright © 2020 JSilver. All rights reserved.
//

import UIKit
import SnapKit

final class MainView: UIView {
    // MARK: - View
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
                
        view.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
        view.register(MainActionTableViewCell.self, forCellReuseIdentifier: "MainActionTableViewCell")
        view.register(MainStepTableViewCell.self, forCellReuseIdentifier: "MainStepTableViewCell")
        
        return view
    }()
    
    // MARK: - Property
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    // MARK: - Private
    private func setUp() {
        setUpLayout()
        setUpState()
        setUpAction()
    }
    
    private func setUpLayout() {
        [
            tableView
        ]
            .forEach { addSubview($0) }
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setUpState() {
        backgroundColor = .white
    }
    
    private func setUpAction() {
        
    }
}
