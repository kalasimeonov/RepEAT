//
//  AddReviewViewController.swift
//  RepEAT
//
//  Created by Kaloyan Simeonov on 23.01.22.
//

import UIKit

class AddReviewViewController: UIViewController {
    
    let coreData = CoreDataStack.shared
    
    var rating: Rating?
    var comment: String?
    var date: Date?
    
    
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker! {
        didSet {
            datePicker.datePickerMode = .date
        }
    }
    
    func setRestaurant(name: String) {
        restaurantNameLabel.text = name
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
        coreData.createReview(rating: rating!, comment: comment, date: date!, restaurant: restaurant)
        coreData.updateData()
    }
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        date = datePicker.date
    }
}
