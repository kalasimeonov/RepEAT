//
//  Review+CoreDataProperties.swift
//  RepEAT
//
//  Created by Kaloyan Simeonov on 20.01.22.
//
//

import Foundation
import CoreData


extension Review {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Review> {
        return NSFetchRequest<Review>(entityName: "Review")
    }

    @NSManaged public var comment: String?
    @NSManaged public var date: Date
    @NSManaged public var id: UUID
    @NSManaged public var rating: Int16
    @NSManaged public var restaurant: Restaurant?

}
