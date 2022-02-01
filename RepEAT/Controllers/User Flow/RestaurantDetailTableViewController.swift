//
//  RestaurantDetailTableViewController.swift
//  RepEAT
//
//  Created by Kaloyan Simeonov on 20.01.22.
//

import UIKit

class RestaurantDetailTableViewController: UIViewController {

    let coreDataStack = CoreDataStack.shared
    
    @IBOutlet weak var reviewsTableView: UITableView!
    @IBOutlet weak var restaurantNameLabel: UILabel! {
        didSet {
            restaurantNameLabel.text = restaurant?.name
        }
    }
    @IBOutlet weak var averageRatingLabel: UILabel! {
        didSet {
            averageRatingLabel.text = restaurant?.averageRating.description
        }
    }
    
    var restaurant: RestaurantModel?
    var reviews: [ReviewModel]?
    
    func setRestaurant(to restaurant: RestaurantModel) {
        self.restaurant = restaurant
        self.reviews = restaurant.reviews
    }
    
    private func presentAddRestaurantVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addNewReviewVC = storyboard.instantiateViewController(identifier: "AddReviewViewController") as AddReviewViewController
        guard let restaurant = self.restaurant else { return }
        addNewReviewVC.setRestaurant(name: restaurant.name)
        addNewReviewVC.delegate = self
        
        self.show(addNewReviewVC, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
        self.view.backgroundColor = .systemYellow
        reviewsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "RestaurantCommentCell")
        reviewsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "NewReviewCell")

    }

    @IBAction func addNewReviewButtonPressed(_ sender: UIButton) {
        presentAddRestaurantVC()
    }
}

// MARK: - Table view
extension RestaurantDetailTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let review = reviews?[indexPath.row] else { return UITableViewCell() }
        let commentCell = reviewsTableView.dequeueReusableCell(withIdentifier: "RestaurantCommentCell", for: indexPath) as! CommentTableViewCell
            
        commentCell.dateLabel.text = review.date.description
        commentCell.ratingLabel.text = String(review.rating.rawValue)
        commentCell.commentLabel.text = review.comment
            
        return commentCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}

extension RestaurantDetailTableViewController: UpdateDelegate {
    func didUpdateData() {
        self.reviews = coreDataStack.reviewModels ?? []
        self.reviewsTableView.reloadData()
    }
}
