//
//  CategoriesCollectionViewCell.swift
//  FoodApp
//
//  Created by Екатерина Алексеева on 03.04.2023.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static var reuseIdentifier = "CategoriesCollectionViewCell"
    var select: Bool = false {
        didSet {
            var selectedColor = UIColor()
            select ? (selectedColor = .brandPinkBackground) : (selectedColor = .brandGreyBackground)
            self.categoryLabel.backgroundColor = selectedColor
        }
    }
    
    // MARK: - Visual Components
    
    var categoryLabel = UILabel()
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setUpCell() {
        self.backgroundColor = .brandGreyBackground
        contentView.clipsToBounds = true
        contentView.addSubview(categoryLabel)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.layer.cornerRadius = 20
        categoryLabel.layer.borderWidth = 1
        categoryLabel.layer.borderColor = UIColor.brandPinkBackground.cgColor
        categoryLabel.clipsToBounds = true
        self.select ? (categoryLabel.backgroundColor = .brandPinkBackground) : (categoryLabel.backgroundColor = .brandGreyBackground)
        categoryLabel.textAlignment = .center
        categoryLabel.textColor = .brandPink
        categoryLabel.font = UIFont(name: "System-Normal", size: 13)
        
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            categoryLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            categoryLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
