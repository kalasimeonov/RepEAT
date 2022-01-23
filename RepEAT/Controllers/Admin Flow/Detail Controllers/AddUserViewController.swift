//
//  AddUserViewController.swift
//  RepEAT
//
//  Created by Kaloyan Simeonov on 21.01.22.
//

import UIKit

protocol UpdateDelegate {
    func didUpdateData()
}

class AddUserViewController: UIViewController {
    
    let coreDataStack = CoreDataStack.shared
    
    var delegate: UpdateDelegate?

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton! {
        didSet {
            submitButton.layer.cornerRadius = 10.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func presentUserExistsAlert() {
        let existingUserAlert = UIAlertController(title: "This user already exists.", message: "Try with different username.", preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Got it!", style: .cancel) { _ in
            existingUserAlert.dismiss(animated: true)
        }
        
        existingUserAlert.addAction(actionCancel)
        self.present(existingUserAlert, animated: true)
    }
    
    private func presentIsAdminAlert() {
        guard let name = usernameTextField.text,
              let password = passwordTextField.text else { return }
        
        let adminAlert = UIAlertController(title: "Is the user admin?", message: nil, preferredStyle: .alert)
        
        let actionCancel = UIAlertAction(title: "Not!", style: .cancel) { [self] _ in
            guard !coreDataStack.userExists(username: name, password: password) else {
                presentUserExistsAlert()
                return
            }
            coreDataStack.create(user: name, password: password, isAdmin: false)
            coreDataStack.updateData()
            delegate?.didUpdateData()
        }
        
        let actionEnter = UIAlertAction(title: "Yes!", style: .default, handler: { [self] _ in
                let isUserAvailable = !coreDataStack.userExists(username: name, password: password)
                if isUserAvailable {
                    coreDataStack.create(user: name, password: password, isAdmin: true)
                    coreDataStack.updateData()
                    delegate?.didUpdateData()
                } else {
                    presentUserExistsAlert()
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
