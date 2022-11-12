//
//  MainStepTableViewCell.swift
//  represent-sample
//
//  Created by JSilver on 2022/11/12.
//  Copyright © 2022 JSilver. All rights reserved.
//

import UIKit
import SnapKit

class MainStepTableViewCell: UITableViewCell {
    // MARK: - View
    private let keyboardAccessoryView: UIToolbar = {
        let view = UIToolbar()
        view.sizeToFit()
        
        return view
    }()
    
    private let valueTextField: UITextField = {
        let view = UITextField()
        view.keyboardType = .numberPad
        view.font = .preferredFont(forTextStyle: .body)
        view.textAlignment = .left
        
        return view
    }()
    
    private let stepper: UIStepper = {
        let view = UIStepper()
        return view
    }()
    
    private let contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 16
        
        return view
    }()
    
    // MARK: - Property
    private var value: Int = 0 {
        didSet {
            valueChangeHandler?(value)
            setNeedsLayout()
        }
    }
    
    private var valueChangeHandler: ((Int) -> Void)?
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        stepper.value = Double(value)
        valueTextField.text = String(value)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        valueTextField.text = nil
        stepper.value = 0
    }
    
    // MARK: - Public
    public func configure(
        value: Int,
        range: Range<Int>,
        valueChanged: @escaping (Int) -> Void
    ) {
        self.value = value
        valueChangeHandler = valueChanged
        
        stepper.minimumValue = Double(range.startIndex)
        stepper.maximumValue = Double(range.endIndex)
    }
    
    // MARK: - Private
    private func setUp() {
        setUpLayout()
        setUpState()
        setUpAction()
    }
    
    private func setUpLayout() {
        [
            valueTextField,
            stepper
        ]
            .forEach { contentStackView.addArrangedSubview($0) }
        
        [
            contentStackView
        ]
            .forEach { contentView.addSubview($0) }
        
        contentStackView.snp.makeConstraints {
            $0.top.bottom
                .equalToSuperview()
                .inset(6)
            $0.leading.trailing
                .equalToSuperview()
                .inset(16)
        }
    }
    
    private func setUpState() {
        keyboardAccessoryView.items = [
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(title: "Done", primaryAction: UIAction { [weak valueTextField] _ in valueTextField?.endEditing(true) })
        ]
        
        valueTextField.inputAccessoryView = keyboardAccessoryView
    }
    
    private func setUpAction() {
        valueTextField.addAction(
            UIAction { [weak self] _ in
                guard let text = self?.valueTextField.text else { return }
                
                self?.value = Int(text) ?? 0
            },
            for: .editingChanged
        )
        
        stepper.addAction(
            UIAction { [weak self] _ in
                guard let value = self?.stepper.value else { return }
                
                self?.value = Int(exactly: value) ?? 0
            },
            for: .valueChanged
        )
    }
}
