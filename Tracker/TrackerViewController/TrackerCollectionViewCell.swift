//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Артем Солодовников on 06.04.2025.
//

import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    var onPlusButtonTapped: (() -> Void)?
    
    // MARK: - UI компоненты
    let emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.textAlignment = .center
        emojiLabel.layer.cornerRadius = 12
        emojiLabel.layer.masksToBounds = true
        emojiLabel.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        return emojiLabel
    }()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.numberOfLines = 2
        return titleLabel
    }()
    
    let plusButton: UIButton = {
        let plusButton = UIButton(type: .system)
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusButton.tintColor = .white
        plusButton.backgroundColor = .tgreen
        plusButton.layer.cornerRadius = 17
        plusButton.layer.masksToBounds = true
        return plusButton
    }()
    
    let daysLabel: UILabel = {
        let daysLabel = UILabel()
        daysLabel.textColor = .tBlack
        daysLabel.font = .systemFont(ofSize: 12, weight: .medium)
        return daysLabel
    }()
    
    private let cardView: UIView = {
        let cardView = UIView()
        cardView.backgroundColor = .tgreen
        cardView.layer.cornerRadius = 16
        cardView.layer.masksToBounds = true
        return cardView
    }()
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
        addConstraints()
        
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Вспомогательные функции
    private func addViews(){
        contentView.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        [emojiLabel, titleLabel].forEach { elem in
            elem.translatesAutoresizingMaskIntoConstraints = false
            cardView.addSubview(elem)
        }
        
        [daysLabel, plusButton].forEach { elem in
            elem.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(elem)
        }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            
            daysLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 16),
            daysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            plusButton.centerYAnchor.constraint(equalTo: daysLabel.centerYAnchor),
            plusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.heightAnchor.constraint(equalToConstant: 34),
        ])
    }
    
    //MARK: - вспомогательные функции
    func configure(with tracker: Tracker, completedDays: Int, isCompletedToday: Bool) {
        emojiLabel.text = tracker.emoji
        titleLabel.text = tracker.name
        daysLabel.text = "\(completedDays) \(dayWord(for: completedDays))"
        
        cardView.backgroundColor = tracker.color
        
        let iconName = isCompletedToday ? "checkmark" : "plus"
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        let icon = UIImage(systemName: iconName, withConfiguration: config)
        plusButton.setImage(icon, for: .normal)
        plusButton.tintColor = .white
        plusButton.backgroundColor = tracker.color.withAlphaComponent(isCompletedToday ? 0.3 : 1.0)
    }
    
    private func dayWord(for count: Int) -> String {
        let remainderOfHundred = count % 100
        let remainderOfTen = count % 10
        
        if remainderOfHundred >= 11 && remainderOfHundred <= 14 {
            return "дней"
        }
        
        switch remainderOfTen {
        case 1:
            return "день"
        case 2, 3, 4:
            return "дня"
        default:
            return "дней"
        }
    }
    
    @objc private func plusButtonTapped() {
        onPlusButtonTapped?()
    }
}
