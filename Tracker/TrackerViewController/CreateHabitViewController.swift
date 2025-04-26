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
    
    private var selectedCategory: TrackerCategory? = TrackerCategory(name: "Домашний уют", trackers: []) {
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
        label.text = "Новая привычка"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .tBlack
        label.textAlignment = .center
        return label
    }()
    
    private let nameField: UITextField = {
        let field = UITextField()
        field.placeholder = "Введите название трекера"
        field.textColor = .tBlack
        field.backgroundColor = .backgroundGray.withAlphaComponent(0.3)
        field.layer.cornerRadius = 16
        field.setLeftPaddingPoints(16)
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
    
    private let categoryButtonView = CreateOptionRowView(title: "Категория")
    private let scheduleButtonView = CreateOptionRowView(title: "Расписание")
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .tGray
        return view
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отменить", for: .normal)
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
        button.setTitle("Создать", for: .normal)
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
        let categoryTap = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        categoryButtonView.addGestureRecognizer(categoryTap)
        
        let scheduleTap = UITapGestureRecognizer(target: self, action: #selector(scheduleTapped))
        scheduleButtonView.addGestureRecognizer(scheduleTap)
        
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
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
        
        createButton.isEnabled = nameFilled && categoryChosen && scheduleChosen
        createButton.backgroundColor = createButton.isEnabled ? .tBlue : .gray
    }
    
    private func updateScheduleUI() {
        if selectedSchedule.isEmpty {
            scheduleButtonView.updateSubtitle(nil)
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
    
    @objc private func createTapped() {
        
        guard
            let name = nameField.text,
            let color = emojiAndColorPicker.selectedColor,
            let emoji = emojiAndColorPicker.selectedEmoji,
            let selectedCategory = selectedCategory
        else { return }
        
        let newTracker = Tracker(
            id: UUID(),
            name: nameField.text ?? "",
            color: color,
            emoji: emoji,
            schedule: selectedSchedule
        )
        
        let newCategory = TrackerCategory(
            name: selectedCategory.name,
            trackers: selectedCategory.trackers + [newTracker]
        )
        
        onCreateTracker?(newCategory)
        
        dismissToRoot()
    }
    
    @objc private func categoryTapped() {
        print("Тут должен быть переход на экран выбора категорий")
    }
    
    @objc private func scheduleTapped() {
        let scheduleVC = ScheduleViewController()
        scheduleVC.selectedDays = Set(selectedSchedule)
        
        scheduleVC.onSchedulePicked = { [weak self] selected in
            guard let self else { return }
            
            self.selectedSchedule = selected
            self.updateScheduleUI()
            self.updateCreateButtonState()
        }
        toRepresentAsSheet(scheduleVC)
    }
}

final class CreateOptionRowView: UIView {
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let arrowIconView = UIImageView(image: UIImage(named: "arrow_right"))
    
    private var centerYConstraint: NSLayoutConstraint!
    private var topTitleConstraint: NSLayoutConstraint!
    private var bottomSubtitleConstraint: NSLayoutConstraint!
    
    init(title: String) {
        super.init(frame: .zero)
        backgroundColor = .clear
        
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        titleLabel.textColor = .tBlack
        
        subtitleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        subtitleLabel.textColor = .tGray
        
        [titleLabel, subtitleLabel, arrowIconView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            arrowIconView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            arrowIconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        topTitleConstraint = titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15)
        centerYConstraint = titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        
        bottomSubtitleConstraint = subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
        
        updateLayout(animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) не реализован")
    }
    
    func updateSubtitle(_ text: String?) {
        subtitleLabel.text = text
        updateLayout(animated: true)
    }
    
    private func updateLayout(animated: Bool) {
        [topTitleConstraint, centerYConstraint, bottomSubtitleConstraint].forEach { $0.isActive = false }
        
        if let text = subtitleLabel.text, !text.isEmpty {
            topTitleConstraint.isActive = true
            bottomSubtitleConstraint.isActive = true
        } else {
            centerYConstraint.isActive = true
        }
        
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.layoutIfNeeded()
            }
        } else {
            layoutIfNeeded()
        }
    }
}


