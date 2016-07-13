//
//  FBLogInPermission.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/6/11.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import Foundation

struct MRFacebook: Facebook {
    var requiredReadPermossion: [FacebookPermission] { return [ .PublicProfile, .Email ] }
}

enum FacebookPermission: String {
    case PublicProfile = "public_profile"
    case Email = "email"
}

extension MRFacebook {
    
    enum CheckPermissionError: ErrorType {
        case PermissionRequired(permission: FacebookPermission)
    }
    
    func checkRequiredReadPermission(grantedPermission grantedPermission: Set<NSObject>) -> [ErrorType] {
        return checkPermission(requiredReadPermossion, grantedPermission: grantedPermission) }
    
    func checkPermission(permission:[FacebookPermission], grantedPermission: Set<NSObject> ) -> [ErrorType] {
        
        var errors: [ErrorType] = []
        
        for _permission in permission {
            if !grantedPermission.contains(_permission.rawValue) {
                let error: CheckPermissionError = .PermissionRequired(permission: _permission)
                errors.append(error)
            }
        }
        return errors
    }
    
}