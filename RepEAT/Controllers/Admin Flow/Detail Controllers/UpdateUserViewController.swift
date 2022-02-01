//
//  UpdateUserViewController.swift
//  RepEAT
//
//  Created by Kaloyan Simeonov on 31.01.22.
//

import UIKit

class UpdateUserViewController: UIViewController {
    
    let coreDataStack = CoreDataStack.shared
    
    var user: UserModel?
    var delegate: UpdateDelegate?

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton! {
        didSet {
            submitButton.layer.cornerRadius = 10.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func presentUserNotExistingAlert() {
        let nonExistingUserAlert = UIAlertController(title: "This user doesn't exists.", message: "Try with different username.", preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Got it!", style: .cancel) { _ in
            nonExistingUserAlert.dismiss(animated: true)
        }
        
        nonExistingUserAlert.addAction(actionCancel)
        self.present(nonExistingUserAlert, animated: true)
    }
    
    private func presentIsAdminAlert() {
        guard let name = user?.username,
              let password = passwordTextField.text else { return }
        
        let adminAlert = UIAlertController(title: "Is the user admin?", message: nil, preferredStyle: .alert)
        
        let actionCancel = UIAlertAction(title: "Not!", style: .cancel) { [self] _ in
            guard coreDataStack.userExists(username: name, password: password) else {
                presentUserNotExistingAlert()
                return
            }
            coreDataStack.update(user: name, password: password, isAdmin: false)
            coreDataStack.updateData()
            delegate?.didUpdateData()
        }
        
        let actionEnter = UIAlertAction(title: "Yes!", style: .default, handler: { [self] _ in
                let isUserAvailable = coreDataStack.userExists(username: name, password: password)
                if isUserAvailable {
                    coreDataStack.update(user: name, password: password, isAdmin: true)
                    coreDataStack.updateData()
                    delegate?.didUpdateData()
                } else {
                    presentUserNotExistingAlert()
                }
        })
        
        adminAlert.addAction(actionEnter)
        adminAlert.addAction(actionCancel)
        self.present(adminAlert, animated: true)
    }

    @IBAction func submitButtonPressed(_ sender: UIButton) {
        presentIsAdminAlert()
    }
}
