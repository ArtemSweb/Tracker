//
//  CreateCategoryViewController.swift
//  Tracker
//
//  Created by Артем Солодовников on 11.05.2025.
//

import UIKit

final class CreateCategoryViewController: UIViewController {
    
    var onCategoryCreated: ((String) -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.categoryCreateTitle
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .tBlack
        label.textAlignment = .center
        return label
    }()
    
    private let nameField: UITextField = {
        let field = UITextField()
        field.placeholder = L10n.categoryCreatePlaceholder
        field.textColor = .tBlack
        field.backgroundColor = .backgroundGray
        field.layer.cornerRadius = 16
        field.setPadding(left: 16)
        field.clearButtonMode = .whileEditing
        return field
    }()
    
    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.doneButton, for: .normal)
        button.setTitleColor(.tWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .tGray
        button.layer.cornerRadius = 16
        button.isEnabled = false
        return button
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .tWhite
        setupLayout()
        setupActions()
        enableHideKeyboardOnTap()
    }
    
    private func setupLayout() {
        [titleLabel, nameField, createButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameField.heightAnchor.constraint(equalToConstant: 75),
            
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupActions() {
        nameField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        createButton.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
    }
    
    @objc private func textFieldChanged() {
        let isFilled = !(nameField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        createButton.isEnabled = isFilled
        createButton.backgroundColor = isFilled ? .tBlack : .tGray
    }
    
    @objc private func createTapped() {
        guard let title = nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !title.isEmpty else { return }
        onCategoryCreated?(title)
        dismiss(animated: true)
    }
}
