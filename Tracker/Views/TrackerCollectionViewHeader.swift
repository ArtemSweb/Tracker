//
//  TrackerCollectionViewHeader.swift
//  Tracker
//
//  Created by Артем Солодовников on 07.04.2025.
//

import UIKit

final class TrackerCollectionViewHeader: UICollectionReusableView {
    
    lazy private var titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 19, weight: .bold)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            titleLabel.heightAnchor.constraint(equalToConstant: 21)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) не реализован")
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
