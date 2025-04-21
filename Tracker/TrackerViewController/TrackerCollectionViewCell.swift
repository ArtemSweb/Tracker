//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Артем Солодовников on 06.04.2025.
//

import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    let emojiLable: UILabel = {
        let emojiLable = UILabel()
        emojiLable.textAlignment = .center
        emojiLable.layer.cornerRadius = 12
        emojiLable.layer.masksToBounds = true
        emojiLable.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        return emojiLable
    }()
    
    let titleLable: UILabel = {
        let titleLable = UILabel()
        titleLable.textColor = .white
        titleLable.font = .systemFont(ofSize: 12, weight: .medium)
        titleLable.numberOfLines = 2
        return titleLable
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
    
    let daysLable: UILabel = {
        let daysLable = UILabel()
        daysLable.textColor = .tBlack
        daysLable.font = .systemFont(ofSize: 12, weight: .medium)
        return daysLable
    }()
    
    private let cardView: UIView = {
        let cardView = UIView()
        cardView.backgroundColor = .tgreen
        cardView.layer.cornerRadius = 16
        cardView.layer.masksToBounds = true
        return cardView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addViews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Вспомогательные функции
    private func addViews(){
        contentView.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        [emojiLable, titleLable].forEach { elem in
            elem.translatesAutoresizingMaskIntoConstraints = false
            cardView.addSubview(elem)
        }
        
        [daysLable, plusButton].forEach { elem in
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
            
            emojiLable.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            emojiLable.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            emojiLable.widthAnchor.constraint(equalToConstant: 24),
            emojiLable.heightAnchor.constraint(equalToConstant: 24),
            
            titleLable.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            titleLable.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            titleLable.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            
            daysLable.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 16),
            daysLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            plusButton.centerYAnchor.constraint(equalTo: daysLable.centerYAnchor),
            plusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.heightAnchor.constraint(equalToConstant: 34),
        ])
    }
}
