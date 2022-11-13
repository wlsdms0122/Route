//
//  MainTableViewCell.swift
//  route-sample
//
//  Created by JSilver on 2022/11/11.
//  Copyright © 2022 JSilver. All rights reserved.
//

import UIKit
import SnapKit

class MainTableViewCell: UITableViewCell {
    // MARK: - View
    private let titleLable: UILabel = {
        let view = UILabel()
        view.font = .preferredFont(forTextStyle: .body)
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = .preferredFont(forTextStyle: .body)
        view.textColor = .lightGray
        view.textAlignment = .right
        view.numberOfLines = 0
        
        return view
    }()
    
    // MARK: - Property
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLable.text = nil
        descriptionLabel.text = nil
    }
    
    // MARK: - Public
    public func configure(title: String, description: String) {
        titleLable.text = title
        descriptionLabel.text = description
    }
    
    // MARK: - Private
    private func setUp() {
        setUpLayout()
        setUpState()
        setUpAction()
    }
    
    private func setUpLayout() {
        [
            titleLable,
            descriptionLabel
        ]
            .forEach { contentView.addSubview($0) }
        
        titleLable.snp.makeConstraints {
            $0.top.equalToSuperview()
                .inset(10)
            $0.bottom.lessThanOrEqualToSuperview()
                .inset(10)
            $0.leading.equalToSuperview()
                .inset(10)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
                .inset(10)
            $0.trailing.equalToSuperview()
                .inset(10)
            $0.bottom.lessThanOrEqualToSuperview()
                .inset(10)
            $0.leading.equalTo(titleLable.snp.trailing)
                .offset(16)
        }
    }
    
    private func setUpState() {
        
    }
    
    private func setUpAction() {
        
    }
}
