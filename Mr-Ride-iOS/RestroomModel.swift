//
//  RestroomModel.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/6/22.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import CoreLocation

class RestroomModel {
    
    let id: String
    let place: String
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    
    init(id: String, place: String, name: String, address: String, coordinate:CLLocationCoordinate2D) {
        self.id = id
        self.place = place
        self.name = name
        self.address = address
        self.coordinate = coordinate
    }
}