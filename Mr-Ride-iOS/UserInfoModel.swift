//
//  UserInfoModel.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/6/9.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import Foundation

class UserInfoModel {
    let id: String
    var name: String
    var email: String?
    var profileImageURL: NSURL?
    var facebookURL: NSURL?
    var height: Double?
    var weight: Double?
    
    init(id: String, name: String){
        self.id = id
        self.name = name
    }
}
