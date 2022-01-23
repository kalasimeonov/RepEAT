//
//  RestaurantDetailTableViewController.swift
//  RepEAT
//
//  Created by Kaloyan Simeonov on 20.01.22.
//

import UIKit

class RestaurantDetailTableViewController: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
        self.view.backgroundColor = .systemYellow
        reviewsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "RestaurantCommentCell")
        reviewsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "NewReviewCell")

    }

}

// MARK: - Table view
extension RestaurantDetailTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellCount = (reviews?.count ?? 0) + 1
        return cellCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if reviews?.count == 0 {
            let addNewCommentCell = reviewsTableView.dequeueReusableCell(withIdentifier: "NewReviewCell", for: indexPath)
            addNewCommentCell.largeContentTitle = "Add new comment"
            addNewCommentCell.backgroundColor = .systemYellow
            addNewCommentCell.tintColor = .label
            return addNewCommentCell
        }
        
        if reviews?.count != 0 {
            let cellCount = (reviews?.count ?? 0) + 1
            if indexPath.row == cellCount {
                let addNewCommentCell = reviewsTableView.dequeueReusableCell(withIdentifier: "NewReviewCell", for: indexPath)
                addNewCommentCell.largeContentTitle = "Add new comment"
                addNewCommentCell.backgroundColor = .systemYellow
                addNewCommentCell.tintColor = .label
                return addNewCommentCell
            }
            
            guard let review = reviews?[indexPath.row] else { return UITableViewCell() }
            let commentCell = reviewsTableView.dequeueReusableCell(withIdentifier: "RestaurantCommentCell", for: indexPath) as! CommentTableViewCell
            
            commentCell.dateLabel.text = review.date.description
            commentCell.ratingLabel.text = String(review.rating.rawValue)
            commentCell.commentLabel.text = review.comment
            
            return commentCell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let reviewsCount = reviews?.count else { return }
        let cellCount = reviewsCount + 1
        
        if indexPath.row == cellCount {
            
        }
    }

}
