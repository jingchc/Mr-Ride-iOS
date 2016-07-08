//
//  UserInfoManager.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/6/9.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import SwiftyJSON

class UserInfoManager {

    static let sharedManager = UserInfoManager()
    
    private(set) var user: UserInfoModel? { didSet { setUser() } }
    
    // isLoggedIN?
    
    var isLoggedIn: Bool { return (user != nil) }
    
    // MARK: - Init
    
    private init() {
        setup()
        
    }
    
}

extension UserInfoManager {
    
    private func setup() { restoreUserInfo() }
    
}


// MARK: - Facebook LogIn

extension UserInfoManager {
    
    enum LogInWithFacebookError: ErrorType {
        case FacebookError(error: NSError)
        case NoResults
        case Cancelled
    }

    typealias LogInWithFacebookSuccess = (user: UserInfoModel) -> Void
    typealias LogInWithFacebookFailure = (error: ErrorType) -> Void
    
    func LogInWithFacebook(fromViewController fromViewController: UIViewController, success: LogInWithFacebookSuccess, failure: LogInWithFacebookFailure) {
    
        let facebook = MRFacebook()
        
        // 取得權限
        FBSDKLoginManager().logInWithReadPermissions(
            facebook.requiredReadPermossion.map{ return $0.rawValue },
            fromViewController: fromViewController,
            handler: { result, error in
        
                // 如果有error
                
                if error != nil {
                    let _error: LogInWithFacebookError = .FacebookError(error: error)
                    print(_error)
                    
                    failure(error: _error) // 這是一個cosure，把error丟進去執行這個closure，至於要執行什麼，寫在viewController裡面
                    
                    return
                }
                // 如果沒有結果
                
                if result == nil {
                    let _error: LogInWithFacebookError = .NoResults
                    print(_error)
                    
                    failure(error: _error)
                    
                    return
                }
                
                // 如果結果是isCancelled
                
                if result.isCancelled {
                    let _error: LogInWithFacebookError = .Cancelled
                    print(_error)
                    
                    failure(error: _error)
                    return
                }
                
                // 檢查 permissionError
                
                let permissionError = facebook.checkRequiredReadPermission(grantedPermission: result.grantedPermissions)
                if let _error = permissionError.first {
                    FBSDKLoginManager().logOut()
                    print(_error)
                    
                    failure(error: _error)
                    return
                }
                
                 // 取得使用者資料
                
                self.getFacebookProfile(
                    success: { json in
                        do {
                             let user = try UserInfoModelHelper().parse(json: json)
                            self.user = user
                            
                            success(user: user)
                        }
                        catch(let error) {
                            
                            FBSDKLoginManager().logOut()
                            failure(error: error)
                        }
                        
                    }
                    , failure: { error in
                        
                        FBSDKLoginManager().logOut()
                        failure(error: error)
                        
                    }
                )
            }
        )
    }
    
    
    // get facebook profile
    
    enum GetFacebookProfileError: ErrorType {
        case FacebookError(error: NSError)
        case NoAccessToken
    }
    
    typealias GetFacebookProfileSuccess = (json: JSON) -> Void
    typealias GetFacebookProfileFailure = (error: ErrorType) -> Void
    
    func getFacebookProfile(success success: GetFacebookProfileSuccess, failure: GetFacebookProfileFailure) {
        
        guard FBSDKAccessToken.currentAccessToken() != nil else {
            
            FBSDKLoginManager().logOut()
            let _error = GetFacebookProfileError.NoAccessToken
            print(_error)
            
            failure(error: _error)
            return
        }
        
        FBSDKGraphRequest(
            graphPath: "me",
            parameters: [ "fields": "name, picture.type(large), link, email" ]
            ).startWithCompletionHandler { _, result, error in
                
                if error != nil {
                    
                    let _error = GetFacebookProfileError.FacebookError(error: error)
                    print(_error)
                    failure(error: _error)
                    
                    return
                    
                }
                
                success(json: JSON(result))
        }
        
    }
    
}


// MARK: - Save data to userdefault

struct NSUserDefaultKey {
    static let Id = "NSUserDefaultKey.Id"
    static let Name = "NSUserDefaultKey.Name"
    static let Email = "NSUserDefaultKey.Email"
    static let ProfileImageURL = "NSUserDefaultKey.ProfileImageURL"
    static let FacebookURL = "NSUserDefaultKey.FacebookURL"
    static let Height = "NSUserDefaultKey.Height"
    static let Weight = "NSUserDefaultKey.Weight"
    static let TotalDistance = "NSUserDefaultKey.TotalDistance"
    static let TotalCount = "NSUserDefaultKey.TotalCount"
    static let AverageSpeed = "NSUserDefaultKey.AverageSpeed"
}

extension UserInfoManager {
    
    private func setUser() {
        
        if let user = user {
            
            NSUserDefaults.standardUserDefaults().setObject(user.id, forKey: NSUserDefaultKey.Id)
            NSUserDefaults.standardUserDefaults().setObject(user.name, forKey: NSUserDefaultKey.Name)
            
            if let email = user.email {
                NSUserDefaults.standardUserDefaults().setObject(email, forKey: NSUserDefaultKey.Email)
            }
            
            if let profileImageURL = user.profileImageURL {
                NSUserDefaults.standardUserDefaults().setURL(profileImageURL, forKey: NSUserDefaultKey.ProfileImageURL)
            }
            
            if let facebookURL = user.facebookURL {
                NSUserDefaults.standardUserDefaults().setURL(facebookURL, forKey: NSUserDefaultKey.FacebookURL)
            }
            
        } else {
            
            NSUserDefaults.standardUserDefaults().removeObjectForKey(NSUserDefaultKey.Id)
            NSUserDefaults.standardUserDefaults().removeObjectForKey(NSUserDefaultKey.Name)
            NSUserDefaults.standardUserDefaults().removeObjectForKey(NSUserDefaultKey.Email)
            NSUserDefaults.standardUserDefaults().removeObjectForKey(NSUserDefaultKey.ProfileImageURL)
            NSUserDefaults.standardUserDefaults().removeObjectForKey(NSUserDefaultKey.FacebookURL)
            
        }
        
//        NSUserDefaults.standardUserDefaults().synchronize()
        
    }
}

// MARK: - restore user info

extension UserInfoManager {
    private func restoreUserInfo() {
        do { user = try UserInfoModelHelper().parse(defaults: NSUserDefaults.standardUserDefaults()) } catch { FBSDKLoginManager().logOut() }
    }
}

// MARK: - log out

extension UserInfoManager {
    func logOut() {
        FBSDKLoginManager().logOut()
        user = nil
    }
}




