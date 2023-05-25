//
//  BoxBoxCoreData+CoreDataProperties.swift
//  
//
//  Created by Arman Husic on 5/21/23.
//
//

import Foundation
import CoreData


extension BoxBoxCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BoxBoxCoreData> {
        return NSFetchRequest<BoxBoxCoreData>(entityName: "UserEntity")
    }

    @NSManaged public var favoriteDriver: String?
    @NSManaged public var favoriteTeam: String?
    @NSManaged public var username: String?

}
