//
//  UpdateRestaurantTableViewController.swift
//  RepEAT
//
//  Created by Kaloyan Simeonov on 22.01.22.
//

import UIKit

class UpdateRestaurantTableViewController: UIViewController {

    // MARK: -CoreData
    let coreDataStack = CoreDataStack.shared
    
    // MARK: -DataSource
    lazy var reviews: [ReviewModel] = {
        coreDataStack.updateData()
        return coreDataStack.reviewModels ?? []
    }()
    
    var delegate: UpdateDelegate?
    var restaurant: RestaurantModel?
    
    @IBOutlet weak var reviewsTableView: UITableView!
    @IBOutlet weak var restaurantNameTextField: UITextField!
    @IBOutlet weak var saveNameButton: UIButton! {
        didSet {
            saveNameButton.layer.cornerRadius = 10.0
        }
    }
    
    // MARK: -Presenting
    private func presentRestaurantExistsAlert() {
        let existingRestaurantAlert = UIAlertController(title: "This restaurant already exists.", message: nil, preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Got it!", style: .cancel) { _ in
            existingRestaurantAlert.dismiss(animated: true)
        }
        
        existingRestaurantAlert.addAction(actionCancel)
        self.present(existingRestaurantAlert, animated: true)
    }
    
    
    // MARK: -Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        coreDataStack.updateData()
        reviewsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewsTableView.dataSource = self
        reviewsTableView.delegate = self
        reviewsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ReviewEditCell")
        reviewsTableView.backgroundColor = .systemYellow
    }
    
    @IBAction func saveNameButtonPressed(_ sender: UIButton) {
        guard let newName = restaurantNameTextField.text else { return }
        let isRestaurantAvailable = (coreDataStack.get(restaurant: newName) == nil)
        
        if isRestaurantAvailable {
            if restaurant != nil {
                coreDataStack.update(restaurantName: restaurant?.name ?? "", toName: newName)
                coreDataStack.updateData()
                self.reviewsTableView.performBatchUpdates({
                    self.reviewsTableView.reloadData()
                }, completion: { _ in
                    self.delegate?.didUpdateData()
                })
            }
        } else {
            presentRestaurantExistsAlert()
        }
        
    }

}

// MARK: - Table view
extension UpdateRestaurantTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reviewsTableView.dequeueReusableCell(withIdentifier: "ReviewEditCell", for: indexPath)
        
        cell.backgroundColor = .systemOrange
        cell.textLabel?.text = reviews[indexPath.item].comment

        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            reviewsTableView.performBatchUpdates {
                coreDataStack.deleteReview(by: reviews[indexPath.row].id)
                reviews.remove(at: indexPath.row)
                reviewsTableView.deleteRows(at: [indexPath], with: .fade)
            } completion: { _ in
                self.reviewsTableView.reloadData()
            }
        }
    }
}
