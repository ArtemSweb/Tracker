//
//  FilterCell.swift
//  Tracker
//
//  Created by Артем Солодовников on 24.05.2025.
//

import UIKit

final class FilterCell: UITableViewCell {
    lazy private var titleLabel = UILabel()
    lazy private var separator = UIView()
    lazy private var checkmarkImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .backgroundGray
        contentView.layer.masksToBounds = true
        setupUI()
    }
    
    private func setupUI() {
        titleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = .tBlack
        
        separator.backgroundColor = .tGray
        checkmarkImageView.image = UIImage(systemName: "checkmark")
        
        [titleLabel, separator, checkmarkImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            separator.heightAnchor.constraint(equalToConstant: 0.5),
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 24),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(title: String, isChecked: Bool, isFirst: Bool, isLast: Bool) {
        titleLabel.text = title
        checkmarkImageView.isHidden = !isChecked
        applyCorners(isFirst: isFirst, isLast: isLast)
        separator.isHidden = isLast
    }
    
    private func applyCorners(isFirst: Bool, isLast: Bool) {
        contentView.layer.cornerRadius = 0
        contentView.layer.maskedCorners = []
        
        switch (isFirst, isLast) {
        case (true, true):
            contentView.layer.cornerRadius = 16
            contentView.layer.maskedCorners = [
                .layerMinXMinYCorner, .layerMaxXMinYCorner,
                .layerMinXMaxYCorner, .layerMaxXMaxYCorner
            ]
        case (true, false):
            contentView.layer.cornerRadius = 16
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case (false, true):
            contentView.layer.cornerRadius = 16
            contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case (false, false):
            contentView.layer.cornerRadius = 0
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) не реализован")
    }
}
