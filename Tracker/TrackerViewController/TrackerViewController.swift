//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Артем Солодовников on 21.03.2025.
//

import UIKit

class TrackerViewController: UIViewController, UICollectionViewDelegate {
    
    private let viewModel: TrackerViewModel
    private let categoryViewModel: TrackerCategoryViewModel
    
    // MARK: - UI компоненты
    private let addTrackingButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(UIImage(resource: .plus).withRenderingMode(.alwaysOriginal), for: .normal)
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
        let imageView = UIImageView(image: UIImage(resource: .starIcon))
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
        view.backgroundColor = .white
        
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        addTrackingButton.addTarget(self, action: #selector(addTrackingButtonTapped), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addTrackingButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        viewModel.loadTrackers()
        viewModel.trackerStore.delegate = self
        
        addViews()
        addConstraints()
    }
    
    //MARK: - вспомогательные функции
    @objc private func dateChanged() {
        collectionView.reloadData()
    }
    
    private func addViews() {
        [plagStackView, headerTitleLabel, searchBar, collectionView].forEach {
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
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
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
        }
        toRepresentAsSheet(createTrackerSelection)
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
    
}

extension TrackerViewController: TrackerStoreDelegate {
    func didUpdateTrackers() {
        viewModel.loadTrackers()
        collectionView.reloadData()
    }
}
