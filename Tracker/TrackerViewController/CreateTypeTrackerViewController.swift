//
//  CreateTypeTrackerViewController.swift
//  Tracker
//
//  Created by Артем Солодовников on 07.04.2025.
//

import UIKit

final class CreateTypeTrackerViewController: UIViewController {
    
    var onCreateTracker: ((TrackerCategory) -> Void)?
    
    // MARK: - UI компоненты
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.textColor = .tBlack
        return label
    }()
    
    private let habitButton: UIButton = {
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
    
    //MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addConstraints()
        
        habitButton.addTarget(self, action: #selector(habbitTapped), for: .touchUpInside)
        eventButton.addTarget(self, action: #selector(eventTapped), for: .touchUpInside)
    }
    
    private func addConstraints() {
        [label, habitButton, eventButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            habitButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 295),
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            
            eventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
            eventButton.leadingAnchor.constraint(equalTo: habitButton.leadingAnchor),
            eventButton.trailingAnchor.constraint(equalTo: habitButton.trailingAnchor),
            eventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    //MARK: - Вспомогательные методы
    @objc private func habbitTapped() {
        let createHabitVC = CreateHabitViewController()
        createHabitVC.onCreateTracker = { [weak self] newCategory in
            self?.onCreateTracker?(newCategory)
            self?.dismissToRoot()
        }
        toRepresentAsSheet(createHabitVC)
    }
    
    @objc private func eventTapped() {
        let createEventVC = CreateEventViewController()
        createEventVC.onCreateTracker = { [weak self] newCategory in
            self?.onCreateTracker?(newCategory)
            self?.dismissToRoot()
        }
        toRepresentAsSheet(createEventVC)
    }
}
