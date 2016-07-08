//
//  RideInfoHelper.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/7/2.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import Foundation

class RideInfoHelper {
    
    static let shared = RideInfoHelper()
    
    // today date
    var todayDate: String {
        let getTodayDate = NSDateFormatter()
        getTodayDate.dateFormat = "yyyy / MM / dd"
        
        return getTodayDate.stringFromDate(NSDate())
    }
    
    // date format
    func getDateFormat(date: NSDate) -> String {
        let getTodayDate = NSDateFormatter()
        getTodayDate.dateFormat = "MM/dd"
        
        return getTodayDate.stringFromDate(date)
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

