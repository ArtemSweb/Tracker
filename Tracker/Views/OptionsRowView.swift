//
//  OptionsRowView.swift
//  Tracker
//
//  Created by Артем Солодовников on 05.05.2025.
//

import UIKit

final class OptionsRowView: UIView {
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let arrowIconView = UIImageView(image: UIImage(resource: .arrowRight))
    
    private var centerYConstraint: NSLayoutConstraint!
    private var topTitleConstraint: NSLayoutConstraint!
    private var bottomSubtitleConstraint: NSLayoutConstraint!
    
    init(title: String) {
        super.init(frame: .zero)
        backgroundColor = .backgroundGray.withAlphaComponent(0.3)
        
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
