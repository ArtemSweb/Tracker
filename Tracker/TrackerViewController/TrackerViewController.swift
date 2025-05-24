//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Артем Солодовников on 21.03.2025.
//

import UIKit

class TrackerViewController: UIViewController, UICollectionViewDelegate {
    
    let viewModel: TrackerViewModel
    private let categoryViewModel: TrackerCategoryViewModel
    
    // MARK: - UI компоненты
    private let addTrackingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(resource: .addTrackerButton).withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .tBlack
        return button
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        return datePicker
    }()
    
    private let headerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.trackers
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .tBlack
        return label
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = L10n.search
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    private let plagImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .starIcon))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let plagLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.whatShallWeTrack
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
    
    private let filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.filters, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.backgroundColor = .tBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.isHidden = true
        return button
    }()
    
    private let filterImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .notFountPlaceholder))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let filterLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.nothingFound
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .tBlack
        label.textAlignment = .center
        return label
    }()
    
    private let filterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.isHidden = true
        return stackView
    }()
    
    private var currentDate: Date {
        Calendar.current.startOfDay(for: datePicker.date)
    }
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(TrackerCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        return collectionView
    }()
    
    //MARK: - init
    init(viewModel: TrackerViewModel, categoryViewModel: TrackerCategoryViewModel) {
        self.viewModel = viewModel
        self.categoryViewModel = categoryViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) не реализован")
    }
    
    //MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .tWhite
        
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        addTrackingButton.addTarget(self, action: #selector(addTrackingButtonTapped), for: .touchUpInside)
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addTrackingButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        viewModel.loadTrackers()
        viewModel.trackerStore.delegate = self
        
        updateFilterButtonState()
        
        viewModel.onTrackersUpdated = { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.updateFilterButtonState()
                self?.updateEmptyState()
            }
        }
        
        categoryViewModel.onCategoriesUpdated = { [weak self] _ in
            self?.viewModel.loadTrackers()
        }
        
        addViews()
        addConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AnalyticsService.shared.sendEvent(event: "open", screen: "Main")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AnalyticsService.shared.sendEvent(event: "close", screen: "Main")
    }
    
    //MARK: - вспомогательные функции
    @objc private func dateChanged() {
        if viewModel.currentFilter == .today {
            viewModel.currentFilter = .all
        }
        collectionView.reloadData()
        updateFilterButtonState()
        updateEmptyState()
    }
    
    private func addViews() {
        [plagStackView, filterStackView, headerTitleLabel, searchBar, collectionView, filterButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [plagImageView, plagLabel].forEach {
            plagStackView.addArrangedSubview($0)
        }
        [filterImageView, filterLabel].forEach {
            filterStackView.addArrangedSubview($0)
        }
    }
    
    private func updateFilterButtonState() {
        filterButton.isHidden = !viewModel.hasAnyTrackers(for: currentDate)
    }
    
    private func updateEmptyState() {
        let hasAny = viewModel.hasAnyTrackers(for: currentDate)
        let visible = viewModel.totalVisibleTrackers(for: currentDate)
        
        if !hasAny {
            plagStackView.isHidden = false
            filterStackView.isHidden = true
            filterButton.isHidden = true
        }
        else if visible == 0 {
            plagStackView.isHidden = true
            filterStackView.isHidden = false
            filterButton.isHidden = false
        }
        else {
            plagStackView.isHidden = true
            filterStackView.isHidden = true
            filterButton.isHidden = false
        }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            datePicker.widthAnchor.constraint(equalToConstant: 100),
            
            headerTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
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
            
            filterStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            filterStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterStackView.widthAnchor.constraint(equalToConstant: 80),
            filterStackView.heightAnchor.constraint(equalToConstant: 80),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: filterButton.topAnchor, constant: -16),
            
            filterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 130),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -130),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc
    private func addTrackingButtonTapped() {
        let createTrackerSelection = CreateTypeTrackerViewController(
            viewModel: self.viewModel,
            categoryViewModel: self.categoryViewModel)
        
        createTrackerSelection.onCreateTracker = { [weak self] newCategory in
            guard let self = self else { return }
            for tracker in newCategory.trackers {
                self.viewModel.addTracker(tracker, toCategoryWithTitle: newCategory.name)
            }
            self.viewModel.loadTrackers()
        }
        AnalyticsService.shared.sendEvent(event: "click", screen: "Main", item: "add_track")
        toRepresentAsSheet(createTrackerSelection)
    }
    
    @objc private func filterButtonTapped() {
        let filterVC = TrackerFilterViewController(currentFilter: viewModel.currentFilter)
        filterVC.onFilterSelected = { [weak self] filter in
            guard let self = self else { return }
            self.viewModel.currentFilter = filter
            if filter == .today {
                let today = Date()
                self.datePicker.setDate(today, animated: true)
            }
            self.collectionView.reloadData()
            self.updateFilterButtonState()
            self.updateEmptyState()
        }
        AnalyticsService.shared.sendEvent(event: "click", screen: "Main", item: "filter")
        toRepresentAsSheet(filterVC)
    }
}

//MARK: - Extensions
extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numberOfSections(for: currentDate)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let total = viewModel.totalVisibleTrackers(for: currentDate)
        
        plagStackView.isHidden = total > 0
        
        return viewModel.numberOfItems(in: section, for: currentDate)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let tracker = viewModel.tracker(at: indexPath, for: currentDate)
        let completedDays = viewModel.completedDays(for: tracker.id)
        let isCompleted = viewModel.isTrackerCompleted(tracker.id, on: currentDate)
        
        cell.configure(with: tracker, completedDays: completedDays, isCompletedToday: isCompleted)
        
        cell.onPlusButtonTapped = { [weak self] in
            guard let self = self else { return }
            
            let today = Calendar.current.startOfDay(for: Date())
            guard self.currentDate <= today else { return }
            
            AnalyticsService.shared.sendEvent(event: "click", screen: "Main", item: "track")
            
            self.viewModel.toggleTrackerCompletion(trackerID: tracker.id, on: self.currentDate)
            if let cell = self.collectionView.cellForItem(at: indexPath) as? TrackerCollectionViewCell {
                let updatedCompletedDays = self.viewModel.completedDays(for: tracker.id)
                let updatedIsCompleted = self.viewModel.isTrackerCompleted(tracker.id, on: self.currentDate)
                cell.configure(with: tracker, completedDays: updatedCompletedDays, isCompletedToday: updatedIsCompleted)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "Header",
            for: indexPath
        ) as? TrackerCollectionViewHeader else {
            fatalError("Не удалось загрузить Header с идентификатором 'Header'")
        }
        
        let title = viewModel.sectionTitle(for: indexPath.section, date: currentDate)
        header.configure(with: title)
        return header
    }
}


extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 8
        let width = (collectionView.bounds.width - spacing) / 2
        return CGSize(width: width, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard
            let indexPath = configuration.identifier as? IndexPath,
            let cell = collectionView.cellForItem(at: indexPath) as? TrackerCollectionViewCell
        else {
            return nil
        }
        
        return cell.targetedPreview()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard
            let indexPath = configuration.identifier as? IndexPath,
            let cell = collectionView.cellForItem(at: indexPath) as? TrackerCollectionViewCell
        else {
            return nil
        }
        
        return cell.targetedPreview()
    }
    
}

extension TrackerViewController: TrackerStoreDelegate {
    func didUpdateTrackers() {
        viewModel.loadTrackers()
        collectionView.reloadData()
    }
}


extension TrackerViewController {
    
    // MARK: - Контекстное меню для трекера
    func collectionView(_ collectionView: UICollectionView,
                        contextMenuConfigurationForItemAt indexPath: IndexPath,
                        point: CGPoint) -> UIContextMenuConfiguration? {
        let tracker = viewModel.tracker(at: indexPath, for: currentDate)
        let isPinned = tracker.isPinned
        
        return UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil) { [weak self] _ in
            let pinAction = UIAction(title: isPinned ? L10n.unpin : L10n.pin) { _ in
                self?.viewModel.togglePin(for: tracker)
            }
            let editAction = UIAction(title: L10n.edit) { [weak self] _ in
                self?.startEditFlow(for: tracker)
                AnalyticsService.shared.sendEvent(event: "click", screen: "Main", item: "edit")
            }
            let deleteAction = UIAction(title: L10n.delete, attributes: .destructive) { [weak self] _ in
                self?.showDeleteConfirmation(for: tracker)
                AnalyticsService.shared.sendEvent(event: "click", screen: "Main", item: "delete")
            }
            return UIMenu(title: "", children: [pinAction, editAction, deleteAction])
        }
    }
    
    func startEditFlow(for tracker: Tracker) {
        guard findCategoryFor(tracker: tracker) != nil else { return }
        
        let editVC = EditHabitViewController()
        editVC.viewModel = viewModel
        editVC.categoryViewModel = categoryViewModel
        editVC.editingTracker = tracker
        
        toRepresentAsSheet(editVC)
    }
    
    private func findCategoryFor(tracker: Tracker) -> TrackerCategory? {
        return viewModel.categories.first { category in
            category.trackers.contains(where: { $0.id == tracker.id })
        }
    }
    
    func showDeleteConfirmation(for tracker: Tracker) {
        let alert = UIAlertController(
            title: "",
            message: L10n.titleDeleteTracker,
            preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(title: L10n.delete, style: .destructive, handler: { [weak self] _ in
            self?.viewModel.deleteTracker(for: tracker)
        }))
        alert.addAction(UIAlertAction(title: L10n.cancelButton, style: .cancel))
        present(alert, animated: true)
    }
}

