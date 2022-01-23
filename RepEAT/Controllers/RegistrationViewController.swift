//
//  RegistrationViewController.swift
//  RepEAT
//
//  Created by Kaloyan Simeonov on 14.01.22.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    // MARK: - CoreData
    let coreDataStack = CoreDataStack.shared
    
    // MARK: -Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.passwordRules = UITextInputPasswordRules(descriptor: "required: upper; required: lower; required: digit; max-consecutive: 2; minlength: 6;")
        }
    }
    @IBOutlet weak var signInButton: UIButton! {
        didSet {
            signInButton.layer.cornerRadius = 10.0
        }
    }
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            signUpButton.layer.cornerRadius = 10.0
        }
    }
    
    // MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: -Presenting
    private func presentAdminPanel() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarVC = storyboard.instantiateViewController(identifier: "TabBarViewController")
        
        self.show(tabBarVC, sender: self)
    }
    
    private func presentRestaurantsViewController() {
        let restaurantsListVC = RestaurantsTableViewController()
        self.navigationController?.pushViewController(restaurantsListVC, animated: false)
    }
    
    private func presentUserExistsAlert() {
        let existingUserAlert = UIAlertController(title: "This user already exists.", message: "Try with different username.", preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Got it!", style: .cancel) { _ in
            existingUserAlert.dismiss(animated: true)
        }
        
        existingUserAlert.addAction(actionCancel)
        self.present(existingUserAlert, animated: true)
    }
    
    private func presentAdminAlert() {
        let adminAlert = UIAlertController(title: "Are you an administrator?", message: "If you are, you won't mind telling us the password?", preferredStyle: .alert)
        adminAlert.addTextField()
        
        let actionCancel = UIAlertAction(title: "I am not!", style: .cancel) { [self] _ in
            guard let username = usernameTextField.text,
                  let password = passwordTextField.text else { return }
            let isUserAvailable = !coreDataStack.userExists(username: username, password: password)
            if isUserAvailable {
                coreDataStack.create(user: username, password: password, isAdmin: false)
                coreDataStack.updateData()
                presentRestaurantsViewController()
            } else {
                presentUserExistsAlert()
            }
        }
        let actionEnter = UIAlertAction(title: "Submit", style: .default, handler: { [self] _ in
            let answer = adminAlert.textFields![0]
            
            if answer.text == "admin" {
                guard let username = usernameTextField.text,
                      let password = passwordTextField.text else { return }
                let isUserAvailable = !coreDataStack.userExists(username: username, password: password)
                if isUserAvailable {
                    coreDataStack.create(user: username, password: password, isAdmin: true)
                    coreDataStack.updateData()
                    self.presentAdminPanel()
                } else {
                    presentUserExistsAlert()
                }
            } else {
                guard let username = usernameTextField.text,
                      let password = passwordTextField.text else { return }
                let isUserAvailable = !coreDataStack.userExists(username: username, password: password)

                if isUserAvailable {
                    coreDataStack.create(user: username, password: password, isAdmin: false)
                    coreDataStack.updateData()
                    presentRestaurantsViewController()
                } else {
                    presentUserExistsAlert()
                }
            }
        })
        
        adminAlert.addAction(actionEnter)
        adminAlert.addAction(actionCancel)
        self.present(adminAlert, animated: true)
    }
    
    // MARK: -Actions
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        guard let user = coreDataStack.get(user: usernameTextField.text ?? "") else { return }
        if user.isAdmin {
            presentAdminPanel()
        } else {
            presentRestaurantsViewController()
        }
    }
    
    @IBAction func singUpButtonPressed(_ sender: Any) {
        presentAdminAlert()
    }
}
