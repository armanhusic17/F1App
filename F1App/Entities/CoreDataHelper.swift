//
//  CoreDataHelper.swift
//  F1App
//
//  Created by Arman Husic on 5/21/23.
//

import Foundation
import CoreData

class CoreDataHelper {
    static let shared = CoreDataHelper() // Singleton instance
    
    private init() {} // Ensure only one instance is created
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BoxBoxCoreData") // Replace with your Core Data model name
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                // Handle the error appropriately
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
   

}
