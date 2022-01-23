//
//  ReviewModel.swift
//  RepEAT
//
//  Created by Kaloyan Simeonov on 14.01.22.
//

import Foundation

struct ReviewModel {
    var id: UUID
    var date: Date
    var rating: Rating
    var comment: String
}

enum Rating: Int {
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
}

extension Sequence {
  var first: Element? {
    first { _ in true }
  }
}

extension Sequence where Element: AdditiveArithmetic {
  var sum: Element? {
    guard let first = first else {
      return nil
    }

    return dropFirst().reduce(first, +)
  }
}
