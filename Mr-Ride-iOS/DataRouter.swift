//
//  DataRouter.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/6/24.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import Alamofire

enum Router {
    case GetRestRoomData
    case GetYouBikeStationData
}

extension Router: URLRequestConvertible {
    
    var method: Alamofire.Method {
        switch self {
        case .GetRestRoomData, .GetYouBikeStationData: return .GET
        }
    }
    
    var url: NSURL {
        switch self {
        case .GetRestRoomData: return NSURL(string: "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=008ed7cf-2340-4bc4-89b0-e258a5573be2")!
        case .GetYouBikeStationData: return NSURL(string: "http://data.taipei/youbike")!
        }
    }
    
    var URLRequest: NSMutableURLRequest {
        
        let URLRequest = NSMutableURLRequest(URL: url)
        URLRequest.HTTPMethod = method.rawValue
        
        return URLRequest
    }
}

