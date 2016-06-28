//
//  RestroomModelHelper.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/6/22.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import CoreLocation
import SwiftyJSON

struct RestroomModelHelper { }

// MARK: - JSONParble

extension RestroomModelHelper: JSONParsable {
    
    struct JSONKey {
        static let Id = "_id"
        static let Place = "類別"
        static let Name = "單位名稱"
        static let Address = "地址"
        static let Latitude = "緯度"
        static let Longitude = "經度"
    }
    
    enum JSONError: ErrorType { case MissingId, MissingPlace,  MissingName,  MissingAddress,  MissingLatitude,  MissingLongitude }
    
    func parse(json json: JSON) throws -> RestroomModel {
        
        guard let id = json[JSONKey.Id].string else { throw JSONError.MissingId }
        guard let place = json[JSONKey.Place].string else { throw JSONError.MissingPlace }
        guard let name = json[JSONKey.Name].string else { throw JSONError.MissingName }
        guard let address = json[JSONKey.Address].string else { throw JSONError.MissingAddress }
        
        let numberFormatter = NSNumberFormatter()
        
        guard let latitudeString = json[JSONKey.Latitude].string else { throw JSONError.MissingLatitude }
        let latitude = numberFormatter.numberFromString(latitudeString) as? Double ?? 0.0
        
        guard let longitudeString = json[JSONKey.Longitude].string else { throw JSONError.MissingLongitude }
        let longitude = numberFormatter.numberFromString(longitudeString) as? Double ?? 0.0
        
        let restRoom = RestroomModel(
            id: id,
            place: place,
            name: name,
            address: address,
            coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        
        return restRoom
    }
    
}

