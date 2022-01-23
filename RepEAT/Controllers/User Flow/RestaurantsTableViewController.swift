//
//  RestaurantsTableViewController.swift
//  RepEAT
//
//  Created by Kaloyan Simeonov on 14.01.22.
//

import UIKit

class RestaurantsTableViewController: UITableViewController {
    
    // MARK: -CoreData
    let coreDataStack = CoreDataStack.shared
    
    // MARK: -DataSource
    lazy var restaurants: [RestaurantModel] = {
        coreDataStack.updateData()
        return coreDataStack.restaurantModels ?? []
    }()
    
    // MARK: -Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        coreDataStack.updateData()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RestaurantCommentCell")
        tableView.backgroundColor = .systemYellow
    }
}


// MARK: - Table view data source
extension RestaurantsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCommentCell", for: indexPath)
        let name = restaurants[indexPath.row].name
        
        cell.backgroundColor = .systemOrange

        cell.textLabel?.text = name

        return cell
    }
}

// MARK: -Table View Delegate
extension RestaurantsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let restaurant = restaurants[indexPath.row]
        let restaurantDetailViewController = storyboard.instantiateViewController(identifier: "RestaurantDetail") as RestaurantDetailTableViewController
        restaurantDetailViewController.setRestaurant(to: restaurant)

        self.show(restaurantDetailViewController, sender: self)
    }
}
