//
//  Restroom+CoreDataProperties.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/7/3.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Restroom {

    @NSManaged var id: String?
    @NSManaged var place: String?
    @NSManaged var name: String?
    @NSManaged var address: String?
    @NSManaged var longitude: NSNumber?
    @NSManaged var latitude: NSNumber?

}
