//
//  Ride+CoreDataProperties.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/6/14.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Ride {

    @NSManaged var averageSpeed: NSNumber?
    @NSManaged var calorie: NSNumber?
    @NSManaged var date: NSDate?
    @NSManaged var distance: NSNumber?
    @NSManaged var id: String?
    @NSManaged var time: NSNumber?
    @NSManaged var route: NSOrderedSet?

}
