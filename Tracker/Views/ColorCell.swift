//
//  ColorCell.swift
//  Tracker
//
//  Created by Артем Солодовников on 26.04.2025.
//

import UIKit

final class ColorCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ColorCell"
    
    private let colorView = UIView()
    private var borderLayer: CAShapeLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        colorView.layer.cornerRadius = 8
        colorView.layer.masksToBounds = true
        contentView.backgroundColor = .clear
        contentView.layer.masksToBounds = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        borderLayer?.removeFromSuperlayer()
        borderLayer = nil
    }
    
    func configure(with color: UIColor, isSelected: Bool) {
        colorView.backgroundColor = color
        addBorder(color: color, isSelect: isSelected)
    }
    
    //Метод для добавления рамки к выделенному цвету
    private func addBorder(color: UIColor, isSelect: Bool) {
        borderLayer?.removeFromSuperlayer()
        borderLayer = nil
        
        guard isSelect else { return }
        
        let inset: CGFloat = -6
        let rect = colorView.frame.insetBy(dx: inset, dy: inset)
        
        let border = CAShapeLayer()
        border.path = UIBezierPath(roundedRect: rect, cornerRadius: 8).cgPath
        border.lineWidth = 3
        border.strokeColor = color.withAlphaComponent(0.3).cgColor
        border.fillColor = UIColor.clear.cgColor
        
        contentView.layer.addSublayer(border)
        borderLayer = border
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let _ = colorView.backgroundColor, borderLayer != nil else { return }

        let inset: CGFloat = -6
        let rect = colorView.frame.insetBy(dx: inset, dy: inset)
        borderLayer?.path = UIBezierPath(roundedRect: rect, cornerRadius: 8).cgPath
    }
}
