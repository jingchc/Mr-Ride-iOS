//
//  RideInfoModel.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/6/13.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import Foundation
import CoreLocation

struct RideInfo {
    let ID: String
    let Date: NSDate
    let SpendTime: NSTimeInterval
    let Distance: Double
    let AverageSpeed: Double
    let Calorie: Double
    let Routes: [CLLocation]
}

class RideInfoHelper {
    
    static let shared = RideInfoHelper()
    
    // date
    var todayDate: String {
        let getTodayDate = NSDateFormatter()
        getTodayDate.dateFormat = "yyyy / MM / dd"
        
        return getTodayDate.stringFromDate(NSDate())
    }
    
    // time
    
    func getTimeFormat(trackDuration: NSTimeInterval) -> NSString {
        let time = NSInteger(trackDuration)
        let milliseconds = Int((trackDuration % 1) * 100)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = time / 3600
        
        return NSString(format: "%0.2d:%0.2d:%0.2d.%0.2d", hours, minutes,seconds,milliseconds)
    }
    
    func getTimeFormatForHistoryPage(trackDuration: NSNumber) -> String {
        let time = NSInteger(trackDuration)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = time / 3600
        
        return String(NSString(format: "%0.2d:%0.2d:%0.2d", hours, minutes,seconds))
    }

    
    // distance
    
    func getDistanceFormat(distance:Double) -> String {
        return "\(Int(distance)) m"
    }
    
    func getDistanceFormatkm(distance:Double) -> String {
        let distanceKm = distance / 1000
        let _distanceKm = NSString(format: "%0.2f", distanceKm)
        
        return "\(String(_distanceKm)) "
    }

    
    // current speed
    
    func getSpeedFormat(speed: Double) -> String {
        return "\(String(Int(speed))) km / h"
    }
    
    
}

