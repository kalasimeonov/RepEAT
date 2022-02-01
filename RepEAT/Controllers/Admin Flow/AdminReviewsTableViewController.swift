//
//  AdminReviewsTableViewController.swift
//  RepEAT
//
//  Created by Kaloyan Simeonov on 15.01.22.
//

import UIKit

class AdminReviewsTableViewController: UITableViewController {
    
    // MARK: -CoreData
    let coreDataStack = CoreDataStack.shared
    
    // MARK: -DataSource
    lazy var reviews: [ReviewModel] = {
        coreDataStack.updateData()
        return coreDataStack.reviewModels ?? []
    }()
    
    // MARK: -Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        coreDataStack.updateData()
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AdminReviewCell")
        tableView.backgroundColor = .systemYellow
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminReviewCell", for: indexPath)
        
        cell.backgroundColor = .systemOrange
        cell.textLabel?.text = reviews[indexPath.item].comment

        return cell
    }

}
// MARK: - Table view delegate
extension AdminReviewsTableViewController {
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            tableView.performBatchUpdates {
                coreDataStack.deleteReview(by: reviews[indexPath.row].id)
                reviews.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } completion: { _ in
                tableView.reloadData()
            }
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let updateReviewViewController = storyboard.instantiateViewController(identifier: "AddReviewViewController") as AddReviewViewController
        updateReviewViewController.isUpdate = true
        updateReviewViewController.setRestaurant(name: reviews[indexPath.row].restaurantName)
        updateReviewViewController.id = reviews[indexPath.row].id

        self.show(updateReviewViewController, sender: self)
    }
}
extension AdminReviewsTableViewController: UpdateDelegate {
    func didUpdateData() {
        self.reviews = coreDataStack.reviewModels ?? []
        self.tableView.reloadData()
    }
}
