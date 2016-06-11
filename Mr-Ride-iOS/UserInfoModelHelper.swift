//
//  UserInfoModelHelper.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/6/10.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import SwiftyJSON

struct UserInfoModelHelper { }

// MARK: - JSONParsable

extension UserInfoModelHelper: JSONParsable
{
    struct JSONKey {
        static let Id = "id"
        static let Name = "name"
        static let Email = "email"
        static let ProfileImageURL = "picture"
        static let FacebookURL = "link"
    }
    
    enum JSONError: ErrorType { case MissingID, InvalidName }
    
    func parse(json json: JSON) throws -> UserInfoModel {
        
        guard let id = json[JSONKey.Id].string else { throw JSONError.MissingID }
        guard let name = json[JSONKey.Name].string else { throw JSONError.InvalidName }
        
        let user = UserInfoModel(id: id, name: name)
        
        user.email = json[JSONKey.Email].string
        
        if let profileImageURL = json[JSONKey.ProfileImageURL]["data"]["url"].string {
            user.facebookURL = NSURL(string: profileImageURL)
        }
        
        if let facebookURLString = json[JSONKey.FacebookURL].string {
            user.facebookURL = NSURL(string: facebookURLString)
        }
        
        return user
        
    }
    
}


// MARK: - NSUserDefaultsParsable

extension UserInfoModelHelper: UserDefaultParsable {
    
    typealias NSUserDefaultKey = UserInfoManager.NSUserDefaultKey
    
    enum NSUserDefaultError: ErrorType {
        case MissingId
        case MissingName
        case MissingEmail
        case MissHeight
        case MissingWeight
    }
    
    func parse(defaults defaults: NSUserDefaults) throws -> UserInfoModel {
        
        guard let id = defaults.stringForKey(NSUserDefaultKey.Id) else { throw NSUserDefaultError.MissingId }
        guard let name = defaults.stringForKey(NSUserDefaultKey.Name) else { throw NSUserDefaultError.MissingName }
        guard let email = defaults.stringForKey(NSUserDefaultKey.Email) else { throw NSUserDefaultError.MissingEmail }
        guard let height = defaults.stringForKey(NSUserDefaultKey.Height) else { throw NSUserDefaultError.MissHeight }
        guard let weight = defaults.stringForKey(NSUserDefaultKey.Weight) else { throw NSUserDefaultError.MissingWeight }
        
        let user = UserInfoModel(id: id, name: name)
        user.email = email
        user.height = Double(height)
        user.weight = Double(weight)
        user.facebookURL = defaults.URLForKey(NSUserDefaultKey.FacebookURL)
        user.profileImageURL = defaults.URLForKey(NSUserDefaultKey.ProfileImageURL)
        
        return user
    }
}

