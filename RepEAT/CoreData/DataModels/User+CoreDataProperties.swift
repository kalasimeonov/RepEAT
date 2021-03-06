//
//  User+CoreDataProperties.swift
//  RepEAT
//
//  Created by Kaloyan Simeonov on 20.01.22.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var isAdmin: Bool
    @NSManaged public var name: String
    @NSManaged public var password: String

}

extension User : Identifiable {

}
