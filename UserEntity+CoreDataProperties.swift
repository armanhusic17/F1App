//
//  UserEntity+CoreDataProperties.swift
//  
//
//  Created by Arman Husic on 5/18/23.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var username: String?
    @NSManaged public var favoriteDriver: String?
    @NSManaged public var favoriteTeam: String?

}
