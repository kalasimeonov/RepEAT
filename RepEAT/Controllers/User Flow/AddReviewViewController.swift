//
//  AddReviewViewController.swift
//  RepEAT
//
//  Created by Kaloyan Simeonov on 23.01.22.
//

import UIKit

class AddReviewViewController: UIViewController {
    
    let coreData = CoreDataStack.shared
    
    var name: String?
    var rating: Rating?
    var comment: String?
    var date: Date?
    var id: UUID?
    var isUpdate: Bool = false
    
    var delegate: UpdateDelegate?
    
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker! {
        didSet {
            datePicker.datePickerMode = .date
        }
    }
    
    func setRestaurant(name: String) {
        self.name = name
    }
    
    private func presentReviewNotFilledAlert() {
        let presentReviewNotFilledAlert = UIAlertController(title: "You are missing some information.", message: "Only the comment is not mandatory!", preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Got it!", style: .cancel) { _ in
            presentReviewNotFilledAlert.dismiss(animated: true)
        }
        
        presentReviewNotFilledAlert.addAction(actionCancel)
        self.present(presentReviewNotFilledAlert, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard self.name != nil else { return }
        restaurantNameLabel.text = self.name
    }
    
    @IBAction func oneButtonPressed(_ sender: UIButton) {
        rating = .one
    }
    @IBAction func twoButtonPressed(_ sender: UIButton) {
        rating = .two
    }
    @IBAction func threeButtonPressed(_ sender: UIButton) {
        rating = .three
    }
    @IBAction func fourButtonPressed(_ sender: UIButton) {
        rating = .four
    }
    @IBAction func fiveButtonPressed(_ sender: UIButton) {
        rating = .five
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        guard let restaurant = coreData.get(restaurant: restaurantNameLabel.text ?? ""),
              rating != nil,
              date != nil
        else {
            presentReviewNotFilledAlert()
            return
        }
        guard !isUpdate else {
            coreData.updateReview(for: id!, comment: commentTextField.text, rating: rating!, date: date!)
            coreData.updateData()
            return
        }
        coreData.createReview(rating: rating!, comment: commentTextField.text, date: date!, restaurant: restaurant)
        coreData.updateData()
        delegate?.didUpdateData()
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        date = datePicker.date
    }
}
