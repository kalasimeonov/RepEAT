//
//  AdminRestaurantsTableViewController.swift
//  RepEAT
//
//  Created by Kaloyan Simeonov on 15.01.22.
//

import UIKit

class AdminRestaurantsTableViewController: UITableViewController {
    
    // MARK: -CoreData
    let coreDataStack = CoreDataStack.shared
    
    // MARK: -DataSource
    lazy var restaurants: [RestaurantModel] = {
        coreDataStack.updateData()
        return coreDataStack.restaurantModels ?? []
    }()
    
    // MARK: -Presenting
    private func presentRestaurantExistsAlert() {
        let existingRestaurantAlert = UIAlertController(title: "This restaurant already exists.", message: nil, preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Got it!", style: .cancel) { _ in
            existingRestaurantAlert.dismiss(animated: true)
        }
        
        existingRestaurantAlert.addAction(actionCancel)
        self.present(existingRestaurantAlert, animated: true)
    }
    
    private func presentAddRestaurantAlert() {
        let restaurantAlert = UIAlertController(title: "Enter restaurant name:", message: nil, preferredStyle: .alert)
        restaurantAlert.addTextField()
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            restaurantAlert.dismiss(animated: true)
        }
        
        let actionEnter = UIAlertAction(title: "Submit", style: .default, handler: { [self] _ in
            guard let answer = restaurantAlert.textFields?[0].text else { return }
            let isRestaurantAvailable = (coreDataStack.get(restaurant: answer) == nil)
            if isRestaurantAvailable {
                restaurants.append(RestaurantModel(name: answer, reviews: []))
                coreDataStack.create(restaurant: answer, reviews: [])
                self.tableView.performBatchUpdates({
                    self.tableView.insertRows(at: [IndexPath(row: self.restaurants.count - 1,
                                                             section: 0)],
                                              with: .automatic)
                }, completion: nil)
            } else {
                presentRestaurantExistsAlert()
            }
        })
        
        restaurantAlert.addAction(actionEnter)
        restaurantAlert.addAction(actionCancel)
        self.present(restaurantAlert, animated: true)
    }
    
    // MARK: -Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        coreDataStack.updateData()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AdminRestaurantCell")
        tableView.backgroundColor = .systemYellow
    }
    
    @IBAction func addRestaurantButtonPressed(_ sender: UIBarButtonItem) {
        presentAddRestaurantAlert()
    }
}

// MARK: - Table view data source
extension AdminRestaurantsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminRestaurantCell", for: indexPath)
        let name = restaurants[indexPath.row].name
        
        cell.backgroundColor = .systemOrange

        cell.textLabel?.text = name

        return cell
    }
}


// MARK: - Table view delegate
extension AdminRestaurantsTableViewController {
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            tableView.performBatchUpdates {
                coreDataStack.delete(restaurant: restaurants[indexPath.row].name)
                restaurants.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } completion: { _ in
                tableView.reloadData()
            }
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let updateRestaurantViewController = storyboard.instantiateViewController(identifier: "UpdateRestaurantTableViewController") as UpdateRestaurantTableViewController
        updateRestaurantViewController.restaurant = restaurants[indexPath.row]
        updateRestaurantViewController.delegate = self

        self.show(updateRestaurantViewController, sender: self)
    }
}
extension AdminRestaurantsTableViewController: UpdateDelegate {
    func didUpdateData() {
        self.restaurants = coreDataStack.restaurantModels ?? []
        self.tableView.reloadData()
    }
}
