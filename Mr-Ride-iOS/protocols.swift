//
//  protocols.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/6/10.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import SwiftyJSON

protocol JSONParsable {
    
    associatedtype T
    func parse(json json:JSON) throws -> T

}

protocol UserDefaultParsable {

    associatedtype T
    func parse(defaults defaults:NSUserDefaults ) throws -> T

}

enum FacebookPermission: String {
    case PublicProfile = "public_profile"
    case Email = "email"
}

protocol Facebook {
    
    var requiredReadPermossion: [FacebookPermission] { get }
    
}