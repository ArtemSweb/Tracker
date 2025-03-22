//
//  ViewController.swift
//  Tracker
//
//  Created by Артем Солодовников on 21.03.2025.
//

import UIKit

class TrackerViewController: UIViewController, UITabBarDelegate {
    
    private let addTrackingButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(addTrackingButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
    private let headerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .tBlack
        return label
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    private let plagImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "star_icon"))
        return imageView
    }()
    
    private let plagLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .tBlack
        return label
    }()
    
    private let plagStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addViews()
        addConstraints()
    }
    
    //MARK: - вспомогательные функции
    private func addViews() {
        [plagStackView, addTrackingButton, headerTitleLabel, datePicker, searchBar].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        view.addSubview(plagStackView)
        
        [plagImageView, plagLabel].forEach {
            plagStackView.addArrangedSubview($0)
        }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            addTrackingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addTrackingButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            addTrackingButton.widthAnchor.constraint(equalToConstant: 19),
            addTrackingButton.heightAnchor.constraint(equalToConstant: 18),
            
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            datePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            datePicker.widthAnchor.constraint(equalToConstant: 100),
            
            headerTitleLabel.topAnchor.constraint(equalTo: addTrackingButton.bottomAnchor, constant: 13),
            headerTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            searchBar.topAnchor.constraint(equalTo: headerTitleLabel.bottomAnchor, constant: 7),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            
            plagStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            plagStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            plagStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            plagImageView.widthAnchor.constraint(equalToConstant: 80),
            plagImageView.heightAnchor.constraint(equalToConstant: 80),
        ])
    }
    
    @objc
    private func addTrackingButtonTapped() {
        print("add Tracker")
        
    }
}
