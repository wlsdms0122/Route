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
    let idLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        
        return view
    }()
    
    let idStepper = UIStepper()
    
    private let idStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 16
        
        return view
    }()
    
    let routeButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        
        let view = UIButton(configuration: configuration)
        view.setTitle("Route", for: .normal)
        
        return view
    }()
    
    let logButton: UIButton = {
        var configuration = UIButton.Configuration.tinted()
        configuration.cornerStyle = .capsule
        
        let view = UIButton(configuration: configuration)
        view.setTitle("Log", for: .normal)
        
        return view
    }()
    
    private let actionStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        
        return view
    }()
    
    private let routeStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 8
        view.axis = .vertical
        
        return view
    }()
    
    let presentNavigationButton: UIButton = {
        let view = UIButton(configuration: .gray())
        view.setTitle("Present Navigation", for: .normal)
        
        return view
    }()
    
    let presentTabButton: UIButton = {
        let view = UIButton(configuration: .gray())
        view.setTitle("Present Tab", for: .normal)
        
        return view
    }()
    
    let pushButton: UIButton = {
        let view = UIButton(configuration: .gray())
        view.setTitle("Push", for: .normal)
        
        return view
    }()
    
    private let bottomStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 4
        
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
            idLabel,
            idStepper
        ]
            .forEach { idStackView.addArrangedSubview($0) }
        
        [
            routeButton,
            logButton
        ]
            .forEach { actionStackView.addArrangedSubview($0) }
        
        [
            idStackView,
            actionStackView
        ]
            .forEach { routeStackView.addArrangedSubview($0) }
        
        [
            presentNavigationButton,
            presentTabButton,
            pushButton
        ]
            .forEach { bottomStackView.addArrangedSubview($0) }
        
        [
            routeStackView,
            bottomStackView
        ]
            .forEach { addSubview($0) }
        
        routeStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
                .inset(24)
            $0.centerY.equalToSuperview().inset(-50)
        }
        
        bottomStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
                .inset(24)
            $0.bottom.equalTo(safeAreaLayoutGuide)
                .inset(12)
            
        }
    }
    
    private func setUpState() {
        backgroundColor = .white
    }
    
    private func setUpAction() {
        
    }
}
