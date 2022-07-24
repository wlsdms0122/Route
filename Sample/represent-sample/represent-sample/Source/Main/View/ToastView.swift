//
//  ToastView.swift
//  represent-sample
//
//  Created by jsilver on 2022/07/24.
//  Copyright © 2022 JSilver. All rights reserved.
//

import UIKit
import SnapKit

final class ToastView: UIView {
    // MARK: - View
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textColor = .white
        
        return view
    }()
    
    // MARK: - Property
    private let message: String
    
    // MARK: - Initializer
    init(message: String) {
        self.message = message
        super.init(frame: .zero)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    // MARK: - Public
    
    // MARK: - Private
    private func setUp() {
        setUpLayout()
        setUpState()
        setUpAction()
    }
    
    private func setUpLayout() {
        [
            titleLabel
        ]
            .forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
                .inset(8)
            $0.trailing.leading.equalToSuperview()
                .inset(16)
        }
    }
    
    private func setUpState() {
        backgroundColor = .black.withAlphaComponent(0.7)
        layer.cornerRadius = 8
        
        titleLabel.text = message
    }
    
    private func setUpAction() {
        
    }
    
}
