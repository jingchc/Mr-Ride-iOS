//
//  DataManager.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/6/24.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import Alamofire
import SwiftyJSON

class DataManager {
    static let shared = DataManager()
}

// MARK: - RestroomDataManager

extension DataManager {
    
    typealias GetRestroomSuccess = (restrooms: [RestroomModel]) -> Void
    typealias GetRestroomFailure = (error: ErrorType) -> Void
    
    func getRestrooms(success success: GetRestroomSuccess, failure: GetRestroomFailure) -> Request {
                
        let URLRequest = Router.GetRestRoomData
        let request = Alamofire.request(URLRequest).validate().responseData { result in
            
            switch result.result {
            case .Success(let data):
                
                let json = JSON(data: data)
                var restrooms: [RestroomModel] = []
                for (_, subJSON) in json["result"]["results"] {
                    
                    do {
                        let restroom = try RestroomModelHelper().parse(json: subJSON)
                        restrooms.append(restroom)
                    }
                    catch {
                        print("Can't get restroom data")
                    }
                }
                
                success(restrooms: restrooms)
                
            case .Failure(let error):
                print(error)
                failure(error: error)
                
            }
        }
        
        return request
    }
    
}

// MARK: YouBikeDataManager


