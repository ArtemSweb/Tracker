//
//  EmojiAndColorPickerView.swift
//  Tracker
//
//  Created by Артем Солодовников on 26.04.2025.
//

import UIKit

enum EmojiAndColorData {
    static let colors: [UIColor] = [
        UIColor(hex: "#FD4C49"),
        UIColor(hex: "#FF881E"),
        UIColor(hex: "#007BFA"),
        UIColor(hex: "#6E44FE"),
        UIColor(hex: "#33CF69"),
        UIColor(hex: "#E66DD4"),
        
        UIColor(hex: "#F9D4D4"),
        UIColor(hex: "#34A7FE"),
        UIColor(hex: "#46E69D"),
        UIColor(hex: "#35347C"),
        UIColor(hex: "#FF674D"),
        UIColor(hex: "#FF99CC"),
        
        UIColor(hex: "#F6C48B"),
        UIColor(hex: "#7994F5"),
        UIColor(hex: "#832CF1"),
        UIColor(hex: "#AD56DA"),
        UIColor(hex: "#8D72E6"),
        UIColor(hex: "#2FD058")
    ]
    
    static let emojis: [String] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                                   "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                                   "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"]
}

final class EmojiAndColorPickerView: UIView {
    var selectedEmoji: String?
    var selectedColor: UIColor?
    var onChange: (() -> Void)?
    
    private let emojis = EmojiAndColorData.emojis
    private let colors = EmojiAndColorData.colors
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = .tBlack
        label.textAlignment = .center
        label.text = "emoji"
        return label
    }()
    
    private let colorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = .tBlack
        label.textAlignment = .center
        label.text = L10n.color
        return label
    }()
    
    private lazy var emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = .zero
        return collectionView
    }()
    
    private lazy var colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) не реализован")
    }
    
    // MARK: - Setup
    private func setupUI() {
        [emojiLabel, emojiCollectionView, colorLabel, colorCollectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: topAnchor),
            emojiLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            
            emojiCollectionView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 24),
            emojiCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            emojiCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -19),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 204),
            
            colorLabel.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor),
            colorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            
            colorCollectionView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 24),
            colorCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            colorCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -19),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 204),
            colorCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - CollectionView
extension EmojiAndColorPickerView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == emojiCollectionView ? emojis.count : colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.reuseIdentifier, for: indexPath) as? EmojiCell else { return UICollectionViewCell() }
            let emoji = emojis[indexPath.item]
            cell.configure(with: emoji, isSelect: emoji.isEqual(selectedEmoji))
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.reuseIdentifier, for: indexPath) as? ColorCell else { return UICollectionViewCell() }
            let color = colors[indexPath.item]
            cell.configure(with: color, isSelected: color.isEqual(selectedColor))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            selectedEmoji = emojis[indexPath.item]
            emojiCollectionView.reloadData()
        } else {
            selectedColor = colors[indexPath.item]
        }
        
        colorCollectionView.reloadData()
        onChange?()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemSize: CGFloat = 52
        let itemsPerRow: CGFloat = 6
        let spacing: CGFloat = 5
        let totalSpacing = spacing * (itemsPerRow - 1)
        let totalContentWidth = itemSize * itemsPerRow + totalSpacing
        
        let availableWidth = collectionView.bounds.width - 36
        let scale = availableWidth / totalContentWidth
        let adjustedItemSize = itemSize * scale
        
        return CGSize(width: adjustedItemSize, height: adjustedItemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 2, bottom: 0, right: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
