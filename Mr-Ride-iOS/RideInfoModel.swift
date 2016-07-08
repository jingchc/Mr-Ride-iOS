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
    let Routes: [LocationWithNumber]
    
}

class LocationWithNumber {
    var location: CLLocation
    var number: Int
    
    init(location: CLLocation, number: Int){
        self.location = location
        self.number = number
    }
}

class RideInfoModel {
    
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var rideInfo: [RideInfo] = []
    
    
    func fetchDataFromCoreData() -> [RideInfo]{
        let request = NSFetchRequest(entityName: "Ride")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sortDescriptor]

        do {
            
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
                    Routes: data.valueForKey("route")!.array as! [LocationWithNumber])
                
                rideInfo.append(ride)
                
            }
            
            return rideInfo
            
        } catch {
            fatalError("error - fetching rideInfo from CoreData")
        }
     }
    
}