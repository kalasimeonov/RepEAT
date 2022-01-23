//
//  CoreDataStack.swift
//  RepEAT
//
//  Created by Kaloyan Simeonov on 19.01.22.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    var restaurants: [Restaurant]?
    var reviews: [Review]?
    var users: [User]?
    
    var restaurantModels: [RestaurantModel]?
    var userModels: [UserModel]?
    var reviewModels: [ReviewModel]?
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RepEAT")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: -Update
    func updateData() {
        self.reviews = fetchReviews()
        self.users = fetchUsers()
        self.restaurants = fetchRestaurants()
        saveContext()
        updateUserModels()
        updateReviewModels()
        updateRestaurantModels()
    }
    
    func updateUserModels() {
        var parsedUsers: [UserModel] = []
        self.users?.forEach({ user in
            parsedUsers.append(UserModel(username: user.name, password: user.password, isAdmin: user.isAdmin))
        })
        self.userModels = parsedUsers
    }
    
    func updateRestaurantModels() {
        var parsedRestaurants: [RestaurantModel] = []
        guard let fetchedRestaurants = restaurants else { return }
        for restaurant in fetchedRestaurants {
            if restaurant.reviews != nil {
                var parsedReviews: [ReviewModel] = []
                restaurant.reviews?.forEach({ review in
                    if let parsedReview = (review as? Review) {
                        let parsedRating: Rating = {
                            switch parsedReview.rating {
                            case 1:
                                return .one
                            case 2:
                                return .two
                            case 3:
                                return .three
                            case 4:
                                return .four
                            case 5:
                                return .five
                            default:
                                return .one
                            }
                        }()
                        parsedReviews.append(ReviewModel(id: UUID(), date: parsedReview.date , rating: parsedRating, comment: parsedReview.comment ?? ""))
                    }
                })
                parsedRestaurants.append(RestaurantModel(name: restaurant.name, reviews: parsedReviews))
            } else {
                parsedRestaurants.append(RestaurantModel(name: restaurant.name, reviews: []))
            }
        }
        self.restaurantModels = parsedRestaurants
    }
    
    func updateReviewModels() {
        var parsedReviews: [ReviewModel] = []
        self.reviews?.forEach { review in
            let parsedRating: Rating = {
                switch review.rating {
                case 1:
                    return .one
                case 2:
                    return .two
                case 3:
                    return .three
                case 4:
                    return .four
                case 5:
                    return .five
                default:
                    return .one
                }
            }()
            parsedReviews.append(ReviewModel(id: UUID(), date: review.date, rating: parsedRating, comment: review.comment ?? ""))
        }
        self.reviewModels = parsedReviews
    }
    // MARK: -Init
    private init() {}
}

// MARK: -Users
extension CoreDataStack {
    
    func fetchUsers() -> [User] {
        do {
            self.users = try managedContext.fetch(User.fetchRequest())
        }
        catch(let error) {
            print(error)
        }
        return self.users ?? []
    }
    
    func get(user: String) -> User? {
        updateData()
        guard let filteredUsers = self.users?.filter({ $0.name == user }),
              let user = filteredUsers.first else { return nil }
        return user
    }
    
    func create(user: String, password: String, isAdmin: Bool) {
        guard !userExists(username: user, password: password) else { return }
        let newUser = User(context: self.managedContext)
        newUser.name = user
        newUser.isAdmin = isAdmin
        newUser.password = password
        
        updateData()
    }
    
    func update(user: String, password: String, isAdmin: Bool) {
        users?.forEach({ fetchedUser in
            guard fetchedUser.name == user else { return }
            fetchedUser.isAdmin = isAdmin
        })
        updateData()
    }
    
    func delete(user: String, password: String) {
        guard let foundUser = get(user: user) else { return }
        managedContext.delete(foundUser)
        updateData()
    }
    
    func isUserAdmin(user: String) -> Bool {
        guard let user = get(user: user) else { return false }
        return user.isAdmin
    }
    
    func userExists(username: String, password: String) -> Bool {
        let existingUser: User? = get(user: username)
        return existingUser != nil
    }
}

// MARK: -Restaurants
extension CoreDataStack {
    func fetchRestaurants() -> [Restaurant] {
        do {
            self.restaurants = try managedContext.fetch(Restaurant.fetchRequest())
        }
        catch(let error) {
            print(error)
        }
        
        return self.restaurants ?? []
    }
    
    func get(restaurant: String) -> Restaurant? {
        updateData()
        guard let filteredRestaurants = self.restaurants?.filter({ $0.name == restaurant }),
              let restaurant = filteredRestaurants.first else { return nil }
        return restaurant
    }
    
    func create(restaurant: String, reviews: [Review]? = nil) {
        let newRestaurant = Restaurant(context: self.managedContext)
        newRestaurant.name = restaurant
        if reviews != nil {
            newRestaurant.reviews = NSSet(array: reviews!)
        }
        updateData()
    }
    
    func update(restaurantName: String, toName: String) {
        restaurants?.forEach({ fetchedRestaurant in
            guard fetchedRestaurant.name == restaurantName else { return }
            fetchedRestaurant.name = toName
        })
        updateData()
    }
    
    func delete(restaurant: String) {
        guard let foundRestaurant = get(restaurant: restaurant) else { return }
        managedContext.delete(foundRestaurant)
        updateData()
    }
}

// MARK: -Reviews
extension CoreDataStack {
    func fetchReviews() -> [Review] {
        do {
            self.reviews = try managedContext.fetch(Review.fetchRequest())
        }
        catch(let error) {
            print(error)
        }
        
        return self.reviews ?? []
    }
    
    func getReview(by id: UUID) -> Review? {
        updateData()
        guard let filteredReviews = self.reviews?.filter({ $0.id == id }),
              let review = filteredReviews.first else { return nil }
        return review
    }
    
    func createReview(rating: Rating, comment: String? = nil, date: Date, restaurant: Restaurant) {
        let newReview = Review(context: self.managedContext)
        newReview.restaurant = restaurant
        newReview.rating = Int16(rating.rawValue)
        newReview.comment = comment
        newReview.date = date
        newReview.id = UUID()
        updateData()
    }
    
    func updateReview(for id: UUID, comment: String? = nil, rating: Rating? = nil, date: Date? = nil) {
        reviews?.forEach({ fetchedReview in
            if comment != nil {
                fetchedReview.comment = comment
            }
            if rating != nil {
                fetchedReview.rating = Int16(rating!.rawValue)
            }
            if date != nil {
                fetchedReview.date = date!
            }
        })
        updateData()
    }
    
    func deleteReview(by id: UUID) {
        guard let foundReview = getReview(by: id) else { return }
        managedContext.delete(foundReview)
        updateData()
    }
}
