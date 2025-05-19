//
//  CreateEventViewController.swift
//  Tracker
//
//  Created by Артем Солодовников on 21.04.2025.
//

import UIKit

final class CreateEventViewController: UIViewController {
    
    var onCreateTracker: ((TrackerCategory) -> Void)?
    var viewModel: TrackerViewModel?
    var categoryViewModel: TrackerCategoryViewModel?
    
    private var selectedCategory: TrackerCategory? {
        didSet {
            updateCategoryUI()
            updateCreateButtonState()
        }
    }
    
    private let emojiAndColorPicker = EmojiAndColorPickerView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // MARK: - UI компоненты
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.newEventButton
        label.textColor = .tBlack
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let nameField: UITextField = {
        let field = UITextField()
        field.placeholder = L10n.trackerNamePlaceholder
        field.textColor = .tBlack
        field.font = UIFont.systemFont(ofSize: 17)
        field.backgroundColor = .backgroundGray.withAlphaComponent(0.3)
        field.layer.cornerRadius = 16
        field.setPadding(left: 16)
        field.clearButtonMode = .whileEditing
        return field
    }()
    
    private let categoryButtonView = OptionsRowView(title: L10n.categoryLabel)
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.cancelButton, for: .normal)
        button.setTitleColor(.tred, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.tred.cgColor
        button.layer.cornerRadius = 16
        button.backgroundColor = .clear
        return button
    }()
    
    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.categoryCreateButton, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.backgroundColor = .tGray
        button.isEnabled = false
        return button
    }()
    
    //MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setup()
        updateCategoryUI()
        updateCreateButtonState()
        
        nameField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(createEventTracker), for: .touchUpInside)
        
        enableHideKeyboardOnTap()
        
        scrollView.keyboardDismissMode = .onDrag
        emojiAndColorPicker.onChange = { [weak self] in
            self?.updateCreateButtonState()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: - вспомогательные функции
    private func setup() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        [titleLabel, nameField, categoryButtonView, emojiAndColorPicker, cancelButton, createButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            nameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            nameField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameField.heightAnchor.constraint(equalToConstant: 75),
            
            categoryButtonView.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 24),
            categoryButtonView.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            categoryButtonView.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
            categoryButtonView.heightAnchor.constraint(equalToConstant: 75),
            
            emojiAndColorPicker.topAnchor.constraint(equalTo: categoryButtonView.bottomAnchor, constant: 32),
            emojiAndColorPicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emojiAndColorPicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            cancelButton.topAnchor.constraint(equalTo: emojiAndColorPicker.bottomAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -4),
            
            createButton.topAnchor.constraint(equalTo: emojiAndColorPicker.bottomAnchor),
            createButton.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 4),
            createButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(moveToCategoryView))
        categoryButtonView.addGestureRecognizer(tapGesture)
    }
    
    private func updateCategoryUI() {
        categoryButtonView.updateSubtitle(selectedCategory?.name ?? "")
    }
    
    @objc private func moveToCategoryView() {
        guard let viewModel = categoryViewModel else { return }
        let categoryVC = CategoryViewController(viewModel: viewModel)
        categoryVC.onCategorySelected = { [weak self] selectedCategory in
            self?.selectedCategory = TrackerCategory(name: selectedCategory.title ?? L10n.trackerNameMissing, trackers: [])
            self?.updateCategoryUI()
            self?.updateCreateButtonState()
        }
        toRepresentAsSheet(categoryVC)
    }
    
    private func updateCreateButtonState() {
        let nameFilled = !(nameField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let categoryChosen = selectedCategory != nil
        let emojiChosen = emojiAndColorPicker.selectedEmoji != nil
        let colorChosen = emojiAndColorPicker.selectedColor != nil
        
        createButton.isEnabled = nameFilled && categoryChosen && emojiChosen && colorChosen
        createButton.backgroundColor = createButton.isEnabled ? .tBlack : .gray
    }
    
    @objc private func textFieldDidChange() {
        updateCreateButtonState()
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    //MARK: - Создание трекера
    @objc private func createEventTracker() {
        guard
            let name = nameField.text,
            let color = emojiAndColorPicker.selectedColor,
            let emoji = emojiAndColorPicker.selectedEmoji,
            let selectedCategory = selectedCategory
        else {
            return
        }
        
        guard
            let coreDataCategory = viewModel?.categoryStore.createCategoryIfNeeded(title: selectedCategory.name)
        else { return }
        
        viewModel?.createTracker(
            name: name,
            emoji: emoji,
            color: color,
            schedule: [],
            categoryTitle: selectedCategory.name,
            coreDataCategory: coreDataCategory
        )
        dismissToRoot()
    }
}
