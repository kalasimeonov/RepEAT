//
//  RestaurantModel.swift
//  RepEAT
//
//  Created by Kaloyan Simeonov on 14.01.22.
//

import Foundation

struct RestaurantModel {
    var name: String
    var reviews: [ReviewModel]
    var ratingReviews: [Rating] {
        var rating: [Rating] = []
        reviews.forEach { review in
            rating.append(review.rating)
        }
        return rating
    }
    var averageRating: Double {
        var ratingsSum = 0
        ratingReviews.forEach { rating in
            ratingsSum += rating.rawValue
        }
        
        if ratingReviews.count != 0 {
            return Double(ratingsSum / ratingReviews.count)
        } else {
            return 0.0
        }
    }
    var lowestReviewRating: Int {
        var ratingNumbers: [Int] = []
        ratingReviews.forEach { rating in
            ratingNumbers.append(rating.rawValue)
        }
        return ratingNumbers.min() ?? 0
    }
    var highestReviewRating: Int {
        var ratingNumbers: [Int] = []
        ratingReviews.forEach { rating in
            ratingNumbers.append(rating.rawValue)
        }
        return ratingNumbers.max() ?? 0
    }
}


