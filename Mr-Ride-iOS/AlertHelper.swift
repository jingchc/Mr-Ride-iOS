//
//  AlertHelper.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/7/12.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import Foundation

class AlertHelper {
    
    //MARK: - LogInViewController
    
    let enterDouble = "Please enter numbers"
    let ok = "OK"
    let enterHeight = "Please enter your height"
    let enterWeight = "Please enter your weight"
    let logInAgain = "Please logging again"
    
    func showWrongTypeAlert(on viewController: UIViewController) {
        let alert = UIAlertController(title: enterDouble, message: nil, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: ok, style: .Default, handler: nil))
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showPleaseTypeAlert(type title: String ,on viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: ok, style: .Default, handler: nil))
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showLogInAlert(on viewController: UIViewController) {
        let alert = UIAlertController(title: logInAgain, message: nil, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: ok, style: .Default, handler: nil))
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: - NewRecrodViewController
    
    let cancelTitle = "This ride haven't save yet!"
    let cancelMessage = "Are you sure want to leave without saving?"
    let stay = "Stay"
    let leave = "leave"
    let startRide = "Let's Start Ride !"
    
    func showCancelAlert(on viewController: UIViewController) {
        
        let alert = UIAlertController(title: cancelTitle, message: cancelMessage, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: stay, style: .Cancel, handler: nil ))
        alert.addAction(UIAlertAction(title: leave, style: .Default,
            handler: { (action: UIAlertAction!) in viewController.dismissViewControllerAnimated(true, completion: nil) }
            )
        )
        viewController.presentViewController(alert, animated: true, completion:nil)
    }
    
    
    func showStartAlert(on viewController: UIViewController) {
        let alert = UIAlertController(title: startRide, message: nil, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: ok, style: .Default, handler: nil))
        viewController.presentViewController(alert, animated: true, completion:nil)
    }
    
    
    //MARK: - FBError
    
    let error = "Error"
    
    func showFaceBookError(on viewController:UIViewController, error: ErrorType) {
        let alert = UIAlertController(title: self.error, message: String(error), preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: ok, style: .Default, handler: nil))
        viewController.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    
}