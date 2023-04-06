//
//  MainViewController.swift
//  FoodApp
//
//  Created by Екатерина Алексеева on 03.04.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let discountImagesNames = ["discount1", "discount2", "discount3"]
    private var categoriesNames: [String] = []
    private var mealsDictionary = [String: [Meal]]()
    private var minConstraintConstant =  CGFloat()
    private let maxConstraintConstant: CGFloat = 0
    private var animatedConstraint: NSLayoutConstraint?
    private var previousContentOffsetY: CGFloat = 0
    private let networkService = NetworkService()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        loadInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        minConstraintConstant = self.cityLabel.frame.origin.y - self.categoriesCollectionView.frame.origin.y + self.cityLabel.frame.height
    }
    
    // MARK: - Private funcs
    private func loadInfo() {
        networkService.loadCategories { [weak self] names in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.categoriesNames = names
                self.categoriesCollectionView.reloadData()
                self.networkService.loadMeals(self.categoriesNames) { [weak self] meals in
                    guard let self = self else { return }
                    self.mealsDictionary = meals
                    self.menuTableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Actions
    
    @objc func changeCityButtonPressed() {
        print("changeCityButtonPressed")
    }
    
    
    // MARK: - Visual components
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Москва"
        label.font = UIFont(name: "System-Normal", size: 17)
        return label
    }()
    
    let changeCityButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "arrowDown"), for: .normal)
        button.addTarget(self, action: #selector(changeCityButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy private var discountsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect(x: 0,
                                                            y: 0,
                                                            width: 0,
                                                            height: 0),                            collectionViewLayout: setUpDiscountsFlowLayout())
        collectionView.backgroundColor = .brandGreyBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(DiscountCollectionViewCell.self,
                                forCellWithReuseIdentifier: DiscountCollectionViewCell.reuseIdentifier)
        collectionView.tag = 1
        return collectionView
    }()
    
    lazy private var categoriesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect(x: 0,
                                                            y: 0,
                                                            width: 0,
                                                            height: 0),                            collectionViewLayout: setUpCategiriesFlowLayout())
        collectionView.backgroundColor = .brandGreyBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CategoriesCollectionViewCell.self,
                                forCellWithReuseIdentifier: CategoriesCollectionViewCell.reuseIdentifier)
        collectionView.allowsMultipleSelection = false
        collectionView.tag = 2
        return collectionView
    }()
    
    private var menuTableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.reuseIdentifier)
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 20
        return tableView
    }()
    
}

// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return discountImagesNames.count
        }
        if collectionView.tag == 2 {
            return categoriesNames.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscountCollectionViewCell.reuseIdentifier, for: indexPath) as? DiscountCollectionViewCell
            else { return UICollectionViewCell() }
            cell.discountView.image = UIImage(named: discountImagesNames[indexPath.item])
            return cell
        }
        if collectionView.tag == 2 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.reuseIdentifier, for: indexPath) as? CategoriesCollectionViewCell
            else { return UICollectionViewCell() }
            cell.categoryLabel.text = categoriesNames[indexPath.item]
            if indexPath.item == 0 {
                cell.select = true
                cell.isSelected = true
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
}

// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CategoriesCollectionViewCell
        cell?.select = true
        let indexPathForTableView = IndexPath(row: 0, section: indexPath.item)
        self.menuTableView.scrollToRow(at: indexPathForTableView, at: .top, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CategoriesCollectionViewCell
        cell?.select = false
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return mealsDictionary.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealsDictionary.isEmpty ? 0 : mealsDictionary[categoriesNames[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.reuseIdentifier, for: indexPath) as? MenuTableViewCell
        else { return UITableViewCell() }
        
        let url = URL(string:mealsDictionary[categoriesNames[indexPath.section]]![indexPath.row].strMealThumb)
        if let data = try? Data(contentsOf: url!) {
            cell.menuView.image = UIImage(data: data)
        } else {
            cell.menuView.image = UIImage(named: "pizza1")
        }
        
        if !mealsDictionary.isEmpty {
            cell.titleLabel.text = mealsDictionary[categoriesNames[indexPath.section]]![indexPath.row].strMeal
            cell.descriptionLabel.text = mealsDictionary[categoriesNames[indexPath.section]]![indexPath.row].strMealThumb
        } else {
            cell.titleLabel.text = "Pizza!"
            cell.descriptionLabel.text = "FHGkjefdka;kf lifjwosij"
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentContentOffsetY = scrollView.contentOffset.y
        let scrollDiff = currentContentOffsetY - previousContentOffsetY
        
        // Верхняя граница эффекта
        let bounceBorderContentOffsetY = -scrollView.contentInset.top
        
        let contentMovesUp = scrollDiff > 0 && currentContentOffsetY > bounceBorderContentOffsetY
        let contentMovesDown = scrollDiff < 0 && currentContentOffsetY < bounceBorderContentOffsetY
        
        let currentConstraintConstant = animatedConstraint!.constant
        var newConstraintConstant = currentConstraintConstant
        
        if contentMovesUp {
            // Уменьшение константы констрейнта
            newConstraintConstant = max(currentConstraintConstant - scrollDiff, minConstraintConstant)
        } else if contentMovesDown {
            // Увеличение константы констрейнта
            newConstraintConstant = min(currentConstraintConstant - scrollDiff, maxConstraintConstant)
        }
        
        // Если константа изменена, изменение высоты и отключение прокрутки
        if newConstraintConstant != currentConstraintConstant {
            animatedConstraint?.constant = newConstraintConstant
            scrollView.contentOffset.y = previousContentOffsetY
        }
        previousContentOffsetY = scrollView.contentOffset.y
    }
}


// MARK: - View setup

extension MainViewController {
    private func setUpView() {
        view.backgroundColor = .brandGreyBackground
        addSubviews()
        setupConstraints()
    }
    
    private func setUpDiscountsFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 300, height: 112)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 5, right: 8)
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        return layout
    }
    
    private func setUpCategiriesFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 90, height: 35)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 3)
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        return layout
    }
    
    private func addSubviews() {
        view.addSubview(cityLabel)
        view.addSubview(changeCityButton)
        view.addSubview(discountsCollectionView)
        view.addSubview(categoriesCollectionView)
        view.addSubview(menuTableView)
    }
    
    private func setupConstraints() {
        discountsCollectionView.dataSource = self
        discountsCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        menuTableView.dataSource = self
        menuTableView.delegate = self
        animatedConstraint = categoriesCollectionView.topAnchor.constraint(equalTo: discountsCollectionView.bottomAnchor, constant: maxConstraintConstant)
        
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            cityLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            cityLabel.widthAnchor.constraint(equalToConstant: 80),
            cityLabel.heightAnchor.constraint(equalToConstant: 20),
            
            changeCityButton.topAnchor.constraint(equalTo: cityLabel.topAnchor),
            changeCityButton.leftAnchor.constraint(equalTo: cityLabel.rightAnchor),
            changeCityButton.widthAnchor.constraint(equalToConstant: 14),
            changeCityButton.bottomAnchor.constraint(equalTo: cityLabel.bottomAnchor),
            
            discountsCollectionView.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 24),
            discountsCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            discountsCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            discountsCollectionView.heightAnchor.constraint(equalToConstant: 125),
            
            animatedConstraint!,
            categoriesCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            categoriesCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: 60),
            
            menuTableView.topAnchor.constraint(equalTo: categoriesCollectionView.bottomAnchor, constant: 0),
            menuTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            menuTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            menuTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: 20),
        ])
    }
}
