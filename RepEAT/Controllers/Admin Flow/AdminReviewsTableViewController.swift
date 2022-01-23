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
