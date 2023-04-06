//
//  DiscountCollectionViewCell.swift
//  FoodApp
//
//  Created by Екатерина Алексеева on 03.04.2023.
//

import UIKit

class DiscountCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    
    static var reuseIdentifier = "DiscountCollectionViewCell"
    
    // MARK: - Visual Components
    
    var discountView = UIImageView()
    
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
        contentView.addSubview(discountView)
        discountView.translatesAutoresizingMaskIntoConstraints = false
        discountView.layer.cornerRadius = 10
        discountView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            discountView.topAnchor.constraint(equalTo: contentView.topAnchor),
            discountView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            discountView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            discountView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
