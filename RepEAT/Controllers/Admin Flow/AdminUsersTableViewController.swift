//
//  AdminUsersTableViewController.swift
//  RepEAT
//
//  Created by Kaloyan Simeonov on 15.01.22.
//

import UIKit
import CloudKit

class AdminUsersTableViewController: UITableViewController {
    
    // MARK: -CoreData
    let coreDataStack = CoreDataStack.shared
    
    // MARK: -DataSource
    lazy var users: [UserModel] = {
        coreDataStack.updateData()
        return coreDataStack.userModels ?? []
    }()
    
    // MARK: -Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        coreDataStack.updateData()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AdminUserCell")
        tableView.backgroundColor = .systemYellow
    }
    
    func presentAddUserScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addNewUserViewController = storyboard.instantiateViewController(identifier: "AddUserViewController") as AddUserViewController
        addNewUserViewController.delegate = self

        self.show(addNewUserViewController, sender: self)
    }
    
    func presentUpdateUserScreen(for user: UserModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let updateUserViewController = storyboard.instantiateViewController(identifier: "UpdateUser") as UpdateUserViewController
        updateUserViewController.user = user
        updateUserViewController.delegate = self

        self.show(updateUserViewController, sender: self)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminUserCell", for: indexPath)
        let name = users[indexPath.row].username

        cell.backgroundColor = .systemOrange
        cell.textLabel?.text = name

        return cell
    }
    @IBAction func addUserButtonPressed(_ sender: UIBarButtonItem) {
        presentAddUserScreen()
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentUpdateUserScreen(for: users[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            tableView.performBatchUpdates {
                coreDataStack.delete(user: users[indexPath.row].username, password: users[indexPath.row].password)
                users.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } completion: { _ in
                tableView.reloadData()
            }
            tableView.endUpdates()
        }
    }
}

extension AdminUsersTableViewController: UpdateDelegate {
    func didUpdateData() {
        self.users = coreDataStack.userModels ?? []
        self.tableView.reloadData()
    }
}
