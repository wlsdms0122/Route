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
    enum Color {
        static let background: UIColor = UIColor(dynamicProvider: {
            switch $0.userInterfaceStyle {
            case .dark:
                return .init(red: 209.0 / 255, green: 209.0 / 255, blue: 214.0 / 255, alpha: 1)
                
            default:
                return .init(red: 28.0 / 255, green: 28.0 / 255, blue: 30.0 / 255, alpha: 1)
            }
        })
    }
    
    // MARK: - View
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textColor = .systemGray6
        
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
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = min(bounds.height / 2, 22)
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
            titleLabel
        ]
            .forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
                .inset(12)
            $0.trailing.leading.equalToSuperview()
                .inset(24)
        }
    }
    
    private func setUpState() {
        backgroundColor = Color.background
        
        layer.shadowColor = Color.background.withAlphaComponent(0.75).cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = .init(width: 0, height: 2)
        
        titleLabel.text = message
    }
    
    private func setUpAction() {
        
    }
    
}
