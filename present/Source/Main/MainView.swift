//
//  MainView.swift
//  present
//
//  Created by JSilver on 2020/06/18.
//  Copyright © 2020 JSilver. All rights reserved.
//

import UIKit
import SnapKit

class MainView: UIView {
    // MARK: - Layout
    let presentingLabel: UILabel = {
        let view = UILabel()
        return view
    }()
    
    let idLabel: UILabel = {
        let view = UILabel()
        return view
    }()
    
    let idStepper: UIStepper = {
        let view = UIStepper()
        return view
    }()
    
    let representButton: UIButton = {
        let view = UIButton()
        view.setTitle("Represent", for: .normal)
        view.setTitleColor(view.tintColor, for: .normal)
        return view
    }()
    
    private lazy var idStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [idLabel, idStepper])
        view.axis = .horizontal
        view.spacing = 16
        return view
    }()
    
    private lazy var representStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [idStackView, representButton])
        view.spacing = 8
        view.axis = .vertical
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        
        [presentingLabel, representStackView].forEach { view.addSubview($0) }
        presentingLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.centerX.equalToSuperview()
        }
        
        representStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        return view
    }()
    
    let presentNavigationButton: UIButton = {
        let view = UIButton()
        view.setTitle("Present Navigation", for: .normal)
        view.setTitleColor(view.tintColor, for: .normal)
        return view
    }()
    
    let presentTabButton: UIButton = {
        let view = UIButton()
        view.setTitle("Present Tab", for: .normal)
        view.setTitleColor(view.tintColor, for: .normal)
        return view
    }()
    
    let pushButton: UIButton = {
        let view = UIButton()
        view.setTitle("Push", for: .normal)
        view.setTitleColor(view.tintColor, for: .normal)
        return view
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [presentNavigationButton, presentTabButton, pushButton])
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()
    
    // MARK: - Property
    
    // MARK: - Constructor
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    private func setupLayout() {
        backgroundColor = .white
        
        [contentView, bottomStackView].forEach { addSubview($0) }
        contentView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(bottomStackView.snp.top)
        }
        
        bottomStackView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(80)
        }
    }
}
