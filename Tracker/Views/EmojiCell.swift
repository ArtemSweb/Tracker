//
//  EmojiCell.swift
//  Tracker
//
//  Created by Артем Солодовников on 26.04.2025.
//

import UIKit

final class EmojiCell: UICollectionViewCell {
    static let reuseIdentifier = "EmojiCell"
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(emojiLabel)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with emoji: String, isSelect: Bool) {
        emojiLabel.text = emoji
        contentView.backgroundColor = isSelect ? .tGray.withAlphaComponent(0.3) : .clear
    }
}
