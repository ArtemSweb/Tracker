//
//  CreateHabitViewController.swift
//  Tracker
//
//  Created by Артем Солодовников on 21.04.2025.
//

import UIKit


final class CreateHabitViewController: UIViewController {
    
    var onCreateTracker: ((TrackerCategory) -> Void)?
    var viewModel: TrackerViewModel?
    var categoryViewModel: TrackerCategoryViewModel?
    
    private var selectedCategory: TrackerCategory? {
        didSet {
            updateCategoryUI()
            updateCreateButtonState()
        }
    }
    
    private var selectedSchedule: [DayOfWeek] = [] {
        didSet {
            updateScheduleUI()
            updateCreateButtonState()
        }
    }
    
    private let emojiAndColorPicker = EmojiAndColorPickerView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // MARK: - UI компоненты
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.newHabitButton
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .tBlack
        label.textAlignment = .center
        return label
    }()
    
    private let nameField: UITextField = {
        let field = UITextField()
        field.placeholder = L10n.trackerNamePlaceholder
        field.textColor = .tBlack
        field.backgroundColor = .backgroundGray.withAlphaComponent(0.3)
        field.layer.cornerRadius = 16
        field.setPadding(left: 16)
        field.clearButtonMode = .whileEditing
        return field
    }()
    
    private let optionContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundGray.withAlphaComponent(0.3)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    private let categoryButtonView = OptionsRowView(title: L10n.categoryLabel)
    private let scheduleButtonView = OptionsRowView(title: L10n.schedule)
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .tGray
        return view
    }()
    
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
        setupActions()
        
        updateCategoryUI()
        updateCreateButtonState()
        nameField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        enableHideKeyboardOnTap()
        scrollView.keyboardDismissMode = .onDrag
        emojiAndColorPicker.onChange = { [weak self] in
            self?.updateCreateButtonState()
        }
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
        
        [titleLabel, nameField, optionContainerView, emojiAndColorPicker, cancelButton, createButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        [categoryButtonView, dividerView, scheduleButtonView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            optionContainerView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            nameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            nameField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameField.heightAnchor.constraint(equalToConstant: 75),
            
            optionContainerView.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 24),
            optionContainerView.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            optionContainerView.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
            
            categoryButtonView.topAnchor.constraint(equalTo: optionContainerView.topAnchor),
            categoryButtonView.leadingAnchor.constraint(equalTo: optionContainerView.leadingAnchor),
            categoryButtonView.trailingAnchor.constraint(equalTo: optionContainerView.trailingAnchor),
            categoryButtonView.heightAnchor.constraint(equalToConstant: 75),
            
            dividerView.topAnchor.constraint(equalTo: categoryButtonView.bottomAnchor),
            dividerView.leadingAnchor.constraint(equalTo: optionContainerView.leadingAnchor, constant: 16),
            dividerView.trailingAnchor.constraint(equalTo: optionContainerView.trailingAnchor, constant: -16),
            dividerView.heightAnchor.constraint(equalToConstant: 0.5),
            
            scheduleButtonView.topAnchor.constraint(equalTo: dividerView.bottomAnchor),
            scheduleButtonView.leadingAnchor.constraint(equalTo: optionContainerView.leadingAnchor),
            scheduleButtonView.trailingAnchor.constraint(equalTo: optionContainerView.trailingAnchor),
            scheduleButtonView.heightAnchor.constraint(equalToConstant: 75),
            scheduleButtonView.bottomAnchor.constraint(equalTo: optionContainerView.bottomAnchor),
            
            emojiAndColorPicker.topAnchor.constraint(equalTo: optionContainerView.bottomAnchor, constant: 32),
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
    }
    
    private func setupActions() {
        let categoryTap = UITapGestureRecognizer(target: self, action: #selector(moveToCategoryView))
        categoryButtonView.addGestureRecognizer(categoryTap)
        
        let scheduleTap = UITapGestureRecognizer(target: self, action: #selector(scheduleTapped))
        scheduleButtonView.addGestureRecognizer(scheduleTap)
        
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(createHabitTracker), for: .touchUpInside)
    }
    
    private func updateCategoryUI() {
        categoryButtonView.updateSubtitle(selectedCategory?.name ?? "")
    }
    
    private func updateCreateButtonState() {
        let nameFilled = !(nameField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let categoryChosen = selectedCategory != nil
        let scheduleChosen = !selectedSchedule.isEmpty
        let emojiChosen = emojiAndColorPicker.selectedEmoji != nil
        let colorChosen = emojiAndColorPicker.selectedColor != nil
        
        createButton.isEnabled = nameFilled && categoryChosen && scheduleChosen && emojiChosen && colorChosen
        createButton.backgroundColor = createButton.isEnabled ? .tBlack : .gray
    }
    
    private func updateScheduleUI() {
        if selectedSchedule.isEmpty {
            scheduleButtonView.updateSubtitle(nil)
        } else if selectedSchedule.count == DayOfWeek.allCases.count {
            scheduleButtonView.updateSubtitle(L10n.everyDay)
        } else {
            let days = selectedSchedule
                .map { $0.shortDayName }
                .joined(separator: ", ")
            scheduleButtonView.updateSubtitle(days)
        }
    }
    
    // MARK: - Действия
    @objc private func textFieldDidChange() {
        updateCreateButtonState()
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    //Выбор категории
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
    
    //MARK: - Создание трекера
    @objc private func createHabitTracker() {
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
            schedule: selectedSchedule,
            categoryTitle: selectedCategory.name,
            coreDataCategory: coreDataCategory
        )
        
        dismissToRoot()
    }
    
    @objc private func scheduleTapped() {
        let scheduleVC = ScheduleViewController()
        scheduleVC.selectedDays = Set(selectedSchedule)
        
        scheduleVC.onSchedulePicked = { [weak self] selected in
            self?.selectedSchedule = selected
            self?.updateScheduleUI()
            self?.updateCreateButtonState()
        }
        toRepresentAsSheet(scheduleVC)
    }
}
