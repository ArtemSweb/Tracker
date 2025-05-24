//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Артем Солодовников on 22.03.2025.
//
import UIKit

final class StatisticViewController: UIViewController {
    
    private var viewModel: StatisticViewModel
    private var statCards: [StatisticSectionView] = []
    private var statStackView: UIStackView!
    private var statsTopConstraint: NSLayoutConstraint!
    private var placeholderTopConstraint: NSLayoutConstraint!
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.text = L10n.statistic
        title.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        title.textColor = .tBlack
        return title
    }()
    
    private let backgroundLogo: UIImageView = {
        UIImageView(image: UIImage(resource: .statisticPlaceholder))
    }()
    
    private let underLogoLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.nothingToAnalyze
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .tBlack
        return label
    }()

    init(viewModel: StatisticViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) не реализован")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .tWhite
        setupElements()
        setupConstraints()
        update(with: viewModel)
    }
    
    func update(with viewModel: StatisticViewModel) {
        self.viewModel = viewModel
        guard isViewLoaded else { return }
        updateCards()
        updateViews()
    }

    private func setupElements() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backgroundLogo)
        backgroundLogo.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(underLogoLabel)
        underLogoLabel.translatesAutoresizingMaskIntoConstraints = false

        statCards = [
            StatisticSectionView(number: viewModel.bestPeriod, description: L10n.bestPeriod),
            StatisticSectionView(number: viewModel.idealDays, description: L10n.idealDays),
            StatisticSectionView(number: viewModel.completedTrackers, description: L10n.trackersCompleted),
            StatisticSectionView(number: viewModel.averageValue, description: L10n.averageValue)
        ]

        statStackView = UIStackView(arrangedSubviews: statCards)
        statStackView.axis = .vertical
        statStackView.spacing = 12
        statStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statStackView)
    }
    
    private func updateCards() {
        guard statCards.count == 4 else { return }
        
        let cardData = [
            viewModel.bestPeriod,
            viewModel.idealDays,
            viewModel.completedTrackers,
            viewModel.averageValue
        ]
        
        statCards.enumerated().forEach { index, card in
            card.configure(number: cardData[index])
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])

        statsTopConstraint = statStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 77)
        NSLayoutConstraint.activate([
            statsTopConstraint,
            statStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        placeholderTopConstraint = backgroundLogo.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 246)
        NSLayoutConstraint.activate([
            backgroundLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundLogo.heightAnchor.constraint(equalToConstant: 80),
            backgroundLogo.widthAnchor.constraint(equalToConstant: 80),
            placeholderTopConstraint,
            underLogoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            underLogoLabel.topAnchor.constraint(equalTo: backgroundLogo.bottomAnchor, constant: 8)
        ])
    }

    private func updateViews() {
        let hasStats = viewModel.hasStatistics
        statStackView.isHidden = !hasStats
        backgroundLogo.isHidden = hasStats
        underLogoLabel.isHidden = hasStats
    }
    
}
