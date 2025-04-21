//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Артем Солодовников on 07.04.2025.
//

import UIKit

final class CreateTrackerViewController: UIViewController {
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.textColor = .tBlack
        return label
    }()
    
    private let habbitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Привычка", for: .normal)
        button.backgroundColor = .tBlack
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        return button
    }()
    
    private let eventButton: UIButton = {
        let button = UIButton()
        button.setTitle("Нерегулярное событие", for: .normal)
        button.backgroundColor = .tBlack
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        return button
    }()
    
    override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            setupLayout()
        }
        
        private func setupLayout() {
            [label, habbitButton, eventButton].forEach {
                view.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
            
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                habbitButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 295),
                habbitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                habbitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                habbitButton.heightAnchor.constraint(equalToConstant: 60),
                
                eventButton.topAnchor.constraint(equalTo: habbitButton.bottomAnchor, constant: 16),
                eventButton.leadingAnchor.constraint(equalTo: habbitButton.leadingAnchor),
                eventButton.trailingAnchor.constraint(equalTo: habbitButton.trailingAnchor),
                eventButton.heightAnchor.constraint(equalToConstant: 60)
            ])
        }
}
