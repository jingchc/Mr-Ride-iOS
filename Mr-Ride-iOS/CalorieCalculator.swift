//
//  CalorieCalculator.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/6/13.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import Foundation

class CalorieCalculator {
    
    private var kCalPerKm_Hour : Dictionary <Exercise,Double> = [
        .Bike: 0.4
    ]
    
    enum  Exercise {
        case Bike
    }
    
    // unit
    // speed : km/h
    // weight: kg
    // time: hr
    // return : kcal
    
    func kcalBurned(exerxiseType: Exercise, speed: Double, weight: Double, time: Double) -> Double {
        
        if let kcalUnit = kCalPerKm_Hour[exerxiseType] {
            return speed * weight * time * kcalUnit
        } else {
            return 0.0
        }
    }
}