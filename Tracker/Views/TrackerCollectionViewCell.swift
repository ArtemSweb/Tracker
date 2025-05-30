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
    
    private let pinImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "pin.fill"))
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
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
        
        [emojiLabel, titleLabel, pinImageView].forEach { elem in
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
            
            pinImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 18),
            pinImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            pinImageView.widthAnchor.constraint(equalToConstant: 8),
            pinImageView.heightAnchor.constraint(equalToConstant: 12),
            
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
        let format = NSLocalizedString("numberOfDays", comment: "")
        let result = String.localizedStringWithFormat(format, completedDays)
        daysLabel.text = result
        
        cardView.backgroundColor = tracker.color
        
        let iconName = isCompletedToday ? "checkmark" : "plus"
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        let icon = UIImage(systemName: iconName, withConfiguration: config)
        plusButton.setImage(icon, for: .normal)
        plusButton.tintColor = .white
        plusButton.backgroundColor = tracker.color.withAlphaComponent(isCompletedToday ? 0.3 : 1.0)
        
        pinImageView.isHidden = !tracker.isPinned
    }
    
    @objc private func plusButtonTapped() {
        onPlusButtonTapped?()
    }
    
    func targetedPreview() -> UITargetedPreview {
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        parameters.visiblePath = UIBezierPath(
            roundedRect: cardView.bounds,
            cornerRadius: cardView.layer.cornerRadius
        )
        return UITargetedPreview(view: cardView, parameters: parameters)
    }
}
