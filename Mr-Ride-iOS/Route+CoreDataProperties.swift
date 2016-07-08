//
//  Route+CoreDataProperties.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/7/7.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Route {

    @NSManaged var id: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var number: NSNumber?
    @NSManaged var speed: NSNumber?
    @NSManaged var timeStamp: NSDate?
    @NSManaged var ride: Ride?

}
