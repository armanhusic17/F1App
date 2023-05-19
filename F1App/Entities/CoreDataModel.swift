//
//  CoreDataModel.swift
//  F1App
//
//  Created by Arman Husic on 5/18/23.
//

import Foundation
import CoreData
import UIKit

class CoreDataModel: NSManagedObject {
    @NSManaged var username: String
    @NSManaged var favoriteDriver: String
    @NSManaged var favoriteTeam: String
    
    // Add more attributes as needed
    
    // MARK: - Custom methods
    
    // Example method to create and save a new user
    static func createUser(name: String, favoriteDriver: String, favoriteConstructor: String, in context: NSManagedObjectContext) {
        
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "UserEntity", into: context) as? CoreDataModel
        newUser?.username = name
        newUser?.favoriteDriver = favoriteDriver
        newUser?.favoriteTeam = favoriteConstructor
        
        // Save the changes to Core Data
        do {
            try context.save()
            print("User saved successfully.")
        } catch {
            let nserror = error as NSError
            fatalError("Failed to save user: \(nserror), \(nserror.userInfo)")
        }
    }
    
    // Example method to fetch all users
    static func fetchAllUsers(in context: NSManagedObjectContext) -> [UserEntity]? {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        
        do {
            let users = try context.fetch(fetchRequest)
            return users
        } catch {
            let nserror = error as NSError
            print("Failed to fetch users: \(nserror), \(nserror.userInfo)")
            return nil
        }
    }
    
    func callCreateUser(){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let context = appDelegate?.persistentContainer.viewContext else {return}
        CoreDataModel.createUser(name: "Swiftduu", favoriteDriver: "Lewis Hamilton", favoriteConstructor: "Mercedes", in: context)
    }
    
    func showData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        if let users = CoreDataModel.fetchAllUsers(in: context) {
            for user in users {
                print(user)
                print("User: \(user.username ?? "")")
                print("Favorite Driver: \(user.favoriteDriver ?? "")")
                print("Favorite Constructor: \(user.favoriteTeam ?? "")")
                // Access other attributes and perform desired operations
            }
        }

    }
}
