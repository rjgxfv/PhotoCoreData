//
//  PhotoEntity+CoreDataProperties.swift
//  PhotosCoreData2
//
//  Created by Robert on 3/22/19.
//  Copyright © 2019 Robert. All rights reserved.
//
//

import Foundation
import CoreData


extension PhotoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoEntity> {
        return NSFetchRequest<PhotoEntity>(entityName: "PhotoEntity")
    }

    @NSManaged public var rawImage: NSData?
    @NSManaged public var name: String?

}
