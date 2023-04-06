//
//  MenuTableViewCell.swift
//  FoodApp
//
//  Created by Екатерина Алексеева on 04.04.2023.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    static var reuseIdentifier = "MenuViewCell"
    
    // MARK: - Visual Components
    
    var menuView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let priceLabel = UILabel()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setUpCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Methods
    
    private func setUpCell() {
        self.backgroundColor = UIColor.white
        contentView.clipsToBounds = true
 
        contentView.addSubview(menuView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(priceLabel)
        
        menuView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        menuView.clipsToBounds = true
        
        titleLabel.font = UIFont(name: "System", size: 17)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .menuName
        titleLabel.text = "Galalxy Note 20 Ultra"
        
        descriptionLabel.font = UIFont(name: "System", size: 13)
        descriptionLabel.textAlignment = .left
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byTruncatingTail
        descriptionLabel.textColor = .menuDescription
        descriptionLabel.baselineAdjustment = .none
        descriptionLabel.text = "Galalxy Note 20 Ultra"
        
        priceLabel.font = UIFont(name: "System", size: 13)
        priceLabel.layer.cornerRadius = 5
        priceLabel.layer.borderWidth = 1
        priceLabel.layer.borderColor = UIColor.brandPink.cgColor
        priceLabel.clipsToBounds = true
        priceLabel.textColor = .brandPink
        priceLabel.textAlignment = .center
        priceLabel.textColor = .brandPink
        priceLabel.text = " 3300.00"
        
        NSLayoutConstraint.activate([
            menuView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            menuView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            menuView.widthAnchor.constraint(equalToConstant: 132),
            menuView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            titleLabel.leftAnchor.constraint(equalTo: menuView.rightAnchor, constant: 32),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -24),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor),
           
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            priceLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor),
            priceLabel.heightAnchor.constraint(equalToConstant: 32),
            priceLabel.widthAnchor.constraint(equalToConstant: 87),
        ])
    }

}
