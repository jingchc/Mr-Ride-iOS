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
            facebook.requiredReadPermossion.map { return $0.rawValue },
            fromViewController: fromViewController,
            handler: { result, error in
                
                // #1 - got error
                if error != nil {
                    let _error: LogInWithFacebookError = .FacebookError(error: error)
                    failure(error: _error)
                    // it's a closure，把error丟進去執行這個closure，執行內容寫在呼叫這個method的viewController裡
                    print(_error)

                    return
                }
                
                // #2 - no result
                
                if result == nil {
                    let _error: LogInWithFacebookError = .NoResults
                    failure(error: _error)

                    print(_error)

                    return
                }
                
                // #3 - result - cancelled
                
                if result.isCancelled {
                    let _error: LogInWithFacebookError = .Cancelled
                    failure(error: _error)
                    
                    print(_error)

                    return
                }
                
                // #4 - result - permissionError
                
                let permissionError = facebook.checkRequiredReadPermission(grantedPermission: result.grantedPermissions)
                if let _error = permissionError.first {
                    FBSDKLoginManager().logOut()
                    failure(error: _error)
                    
                    print(_error)

                    return
                }
                
                 // 取得使用者資料
                
                self.getFacebookProfile(
                    success: { json in
                        do {
                             let user = try UserInfoModelHelper().parse(json: json)
                            self.user = user  // save to userDefault
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
            failure(error: _error)
            
            print(_error)

            return
        }
        
        FBSDKGraphRequest(
            graphPath: "me",
            parameters: [ "fields": "name, picture.type(large), link, email" ]
            ).startWithCompletionHandler { _, result, error in
                
                if error != nil {
                    let _error = GetFacebookProfileError.FacebookError(error: error)
                    failure(error: _error)
                    
                    print(_error)
                    
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
        
        NSUserDefaults.standardUserDefaults().synchronize()
        
    }
}

// MARK: - restore user info

extension UserInfoManager {
    private func restoreUserInfo() {
        do { user = try UserInfoModelHelper().parse(defaults: NSUserDefaults.standardUserDefaults())
        }
        catch {
            FBSDKLoginManager().logOut()
            fatalError("FBLogIn-init-restoreUserInfo")
        }
    }
}

// MARK: - log out

extension UserInfoManager {
    func logOut() {
        FBSDKLoginManager().logOut()
        user = nil
    }
}




