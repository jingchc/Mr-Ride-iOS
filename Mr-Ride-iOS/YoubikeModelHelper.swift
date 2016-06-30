//
//  YoubikeModelHelper.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/6/28.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import CoreLocation
import SwiftyJSON

struct YoubikeModelHelper { }

// MARK: - JSONParble

extension YoubikeModelHelper {
    
    struct JSONKey {
        static let id = "sno"
        static let stationName = "sna"
        static let stationDistrict = "sarea"
        static let stationAddress = "ar"
        static let stationNameEnglish = "snaen"
        static let stationDistrictEnglish = "sareaen"
        static let stationAddressEnglish = "aren"
        static let latitude = "lat"
        static let longitude = "lng"
        static let remainBike = "sbi"
    }
    
    enum JSONError: ErrorType { case MissingId, MissingStationName, MissingStationDistrict,  MissingStationAddress, MissingStationNameEnglish, MissingStationDistrictEnglish,  MissingStationAddressEnglish,  MissingLatitude,  MissingLongitude,  MissingRemainBike}
    
    func parse(json json: JSON) throws -> YouBikeModel {
        
        guard let id = json[JSONKey.id].string else { throw JSONError.MissingId }
        guard let stationName = json[JSONKey.stationName].string else { throw JSONError.MissingStationName }
        guard let stationDistrict = json[JSONKey.stationDistrict].string else { throw JSONError.MissingStationDistrict }
        guard let stationAddress = json[JSONKey.stationAddress].string else { throw JSONError.MissingStationAddress }
        guard let stationNameEnglish = json[JSONKey.stationNameEnglish].string else { throw JSONError.MissingStationNameEnglish }
        guard let stationDistrictEnglish = json[JSONKey.stationDistrictEnglish].string else { throw JSONError.MissingStationDistrictEnglish }
        guard let stationAddressEnglish = json[JSONKey.stationAddressEnglish].string else { throw JSONError.MissingStationAddressEnglish }
        guard let remainBike = json[JSONKey.remainBike].string else { throw JSONError.MissingRemainBike }
        
        let numberFormatter = NSNumberFormatter()
        
        guard let latitudeString = json[JSONKey.latitude].string else { throw JSONError.MissingLatitude }
        let latitude = numberFormatter.numberFromString(latitudeString) as? Double ?? 0.0
        
        guard let longitudeString = json[JSONKey.longitude].string else { throw JSONError.MissingLongitude }
        let longitude = numberFormatter.numberFromString(longitudeString) as? Double ?? 0.0
        
        let youbike = YouBikeModel(
            id: id,
            stationName: stationName,
            stationDistrict: stationDistrict,
            stationAddress: stationAddress,
            stationNameEnglish: stationNameEnglish,
            stationDistrictEnglish: stationDistrictEnglish,
            stationAddressEnglish: stationAddressEnglish,
            stationLocation: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            remainBike: remainBike)
        
        return youbike
        
    }
    
    
}
