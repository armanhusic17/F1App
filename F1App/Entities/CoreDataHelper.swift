//
//  CoreDataHelper.swift
//  F1App
//
//  Created by Arman Husic on 5/21/23.
//

import Foundation
import CoreData
import UIKit

class CoreDataHelper {
    @MainActor
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

    func saveImage(image: UIImage, completion: @escaping (Bool, Error?) -> Void){
        let context = self.context
        context.perform {
            guard let imageData = image.pngData() else {
                completion(false, NSError(domain: "", code: 0, userInfo:  [NSLocalizedDescriptionKey: "Could not convert image to Data"]))
                return
            }
            
            guard let newUserEntity = NSEntityDescription.insertNewObject(forEntityName: "UserEntity", into: context) as? BoxBoxCoreData else {
                completion(false, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error creating UserEntity"]))
                return
            }
            newUserEntity.imgData = imageData
            
            // save context
            do {
                try context.save()
                completion(true, nil)
            } catch {
                completion(false, error)
            }
        }
    }

    func getImageFromCoreData(completion: @escaping (UIImage?, Error?) -> Void) {
        let context = self.context
        context.perform {
            let fetchRequest: NSFetchRequest<BoxBoxCoreData> = BoxBoxCoreData.fetchRequest()
            
            do {
                let results = try context.fetch(fetchRequest)
                
                // Assuming you want the first image; modify as needed
                if let firstResult = results.first, let imageData = firstResult.imgData {
                    let image = UIImage(data: imageData)
                    completion(image, nil)
                } else {
                    completion(nil, nil)
                }
            } catch {
                completion(nil, error)
            }
        }
    }
}

extension Locale {
    /// Returns the flag emoji for a given country name or nil if the country is not found.
    static func flag(for countryName: String) -> String? {
        // Find the country code for the given country name.
        let countryCodes = Locale.isoRegionCodes
        var countryCode: String?
        
        for code in countryCodes {
            let identifier = Locale.identifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = Locale(identifier: identifier).localizedString(forRegionCode: code)
            if name?.lowercased() == countryName.lowercased() {
                countryCode = code
                break
            }
        }
        
        // Ensure a country code was found.
        guard let code = countryCode else { return nil }
        
        // Convert the country code to a flag emoji.
        return code
            .unicodeScalars
            .map { UnicodeScalar(127397 + $0.value)! }
            .map { String($0) }
            .joined()
    }
}
