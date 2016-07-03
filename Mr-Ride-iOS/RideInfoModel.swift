//
//  RideInfoModel.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/6/13.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import CoreLocation
import CoreData

struct RideInfo {
    
    let ID: String
    let Date: NSDate
    let SpendTime: NSTimeInterval
    let Distance: Double
    let AverageSpeed: Double
    let Calorie: Double
    let Routes: [CLLocation]
    
}

class RideInfoModel {
    
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var rideInfo: [RideInfo] = []
    
    
    func fetchDataFromCoreData() -> [RideInfo]{
        do {
            let request = NSFetchRequest(entityName: "Ride")
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
            request.sortDescriptors = [sortDescriptor]
            
            let datas = try moc.executeFetchRequest(request)
            rideInfo = []
            
            for data in datas {
                let ride = RideInfo(
                    ID: data.valueForKey("id") as! String,
                    Date: data.valueForKey("date") as! NSDate,
                    SpendTime: data.valueForKey("time") as! NSTimeInterval,
                    Distance: data.valueForKey("distance") as! Double,
                    AverageSpeed: data.valueForKey("averageSpeed") as! Double,
                    Calorie: data.valueForKey("calorie") as! Double,
                    Routes: data.valueForKey("route")!.array as! [CLLocation])
                
                rideInfo.append(ride)
                
            }
            
            return rideInfo
            
        } catch {
            fatalError("error - fetching rideInfo from CoreData")
        }
     }
    
}