//
//  NetworkService.swift
//  FoodApp
//
//  Created by Екатерина Алексеева on 05.04.2023.
//

import Foundation

class NetworkService {
    
    // MARK: - private properties
    
    private let urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        return session
    }()
    
    
    // MARK: - public methods
    
    func loadCategories(completion: @escaping ([String]) -> Void ) {
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php")
        var categoriesForWork = [String]()
        let task = self.urlSession.dataTask(with: url!) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            guard let data = data else { return }
            let json = try? JSONSerialization.jsonObject(with: data, options:      JSONSerialization.ReadingOptions.mutableContainers)
            let jsonArray = CategoriesArray(json as! [String: Any])
            
            let categoriesArray = jsonArray.categories.map { $0.strCategory }
            
            for i in 0 ... 4 {
                categoriesForWork.append(categoriesArray[i])
            }
            completion(categoriesForWork)
        }
        task.resume()
    }
    
    func loadMeals(_ withCategories: [String], complition: @escaping([String: [Meal]]) -> Void) {
        let group = DispatchGroup()
        let runQueue = DispatchQueue.global()
        var mealsDictionary =  [String: [Meal]]()
        
        for category in withCategories {
            group.enter()
            runQueue.async {
                let url = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?%20c=" + category)
                let task = self.urlSession.dataTask(with: url!) { (data, response, error) in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    }
                    guard let data = data else { return }
                    let json = try? JSONSerialization.jsonObject(with: data, options:      JSONSerialization.ReadingOptions.mutableContainers)
                    let jsonArray = MealsArray(json as! [String: Any])
                    mealsDictionary[category] = jsonArray.meals
                    group.leave()
                }
                task.resume()
            }
        }
        
        group.notify(queue: .main) {
            complition(mealsDictionary)
        }
    }
    
}


    // MARK: - structs for JSON parsing

struct CategoriesArray {
    var categories: [Category] = []
    
    init(_ json: [String: Any] ) {
        let categoriesArray = json["categories"] as! [[String: Any]]
        self.categories = categoriesArray.map { Category(json: $0) }
    }
}

struct Category {
    var idCategory = 0
    var strCategory = ""

    init(json: [String: Any]) {
        let id = json["idCategory"] as? String ?? "0"
        self.idCategory = Int(id) ?? 0
        self.strCategory = json["strCategory"] as? String ?? ""
    }
}

struct MealsArray {
    var meals: [Meal] = []
    
    init(_ json: [String: Any] ) {
        let mealsArray = json["meals"] as! [[String: Any]]
        self.meals = mealsArray.map { Meal(json: $0) }
        //print(meals)
    }
}

struct Meal {
    var idMeal = 0
    var strMeal = ""
    var strMealThumb = ""
    
    init(json: [String: Any]) {
        let idMeal = json["idMeal"] as? String ?? ""
        self.idMeal = Int(idMeal) ?? 0
        self.strMeal = json["strMeal"] as? String ?? ""
        self.strMealThumb = json["strMealThumb"] as? String ?? ""
    }
}
