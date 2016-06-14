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
    let AverageSeppd: Double
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

    
    // distance
    
    func getDistanceFormat(distance:Double) -> String {
        return "\(Int(distance)) m"
    }
    
    // current speed
    
    func getSpeedFormat(speed: Double) -> String {
        return "\(String(Int(speed))) km / h"
    }
    
    
}

