//
//  YoubikeModel.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/6/28.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import CoreLocation

class YouBikeModel {
    
    let id: String
    let stationName: String
    let stationDistrict: String
    let stationAddress: String
    let stationNameEnglish: String
    let stationDistrictEnglish: String
    let stationAddressEnglish: String
    let stationLocation: CLLocationCoordinate2D
    let remainBike: String
    
    init(id: String,
         stationName: String,
         stationDistrict: String,
         stationAddress: String,
         stationNameEnglish: String,
         stationDistrictEnglish: String,
         stationAddressEnglish: String,
         stationLocation: CLLocationCoordinate2D,
         remainBike: String) {
        self.id = id
        self.stationName = stationName
        self.stationDistrict = stationDistrict
        self.stationAddress = stationAddress
        self.stationLocation = stationLocation
        self.stationNameEnglish = stationNameEnglish
        self.stationDistrictEnglish = stationDistrictEnglish
        self.stationAddressEnglish = stationAddressEnglish
        self.remainBike = remainBike
    }
    
}
