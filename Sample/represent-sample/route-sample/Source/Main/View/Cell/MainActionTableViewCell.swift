//
//  MainActionTableViewCell.swift
//  route-sample
//
//  Created by JSilver on 2022/11/12.
//  Copyright © 2022 JSilver. All rights reserved.
//

import UIKit
import SnapKit

class MainActionTableViewCell: UITableViewCell {
    // MARK: - View
    private let titleLable: UILabel = {
        let view = UILabel()
        view.font = .preferredFont(forTextStyle: .body)
        view.textColor = view.tintColor
        
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
    }
    
    // MARK: - Public
    public func configure(title: String) {
        titleLable.text = title
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
        ]
            .forEach { contentView.addSubview($0) }
        
        titleLable.snp.makeConstraints {
            $0.top.bottom
                .equalToSuperview()
                .inset(10)
            $0.leading.trailing
                .equalToSuperview()
                .inset(16)
        }
    }
    
    private func setUpState() {
        
    }
    
    private func setUpAction() {
        
    }
}
