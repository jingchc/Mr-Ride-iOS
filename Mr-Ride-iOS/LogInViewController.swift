//
//  LogInViewController.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/6/6.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var heightTitle: UILabel!
    @IBOutlet weak var heightScale: UILabel!
    @IBOutlet weak var userHeight: UITextField!
    
    @IBOutlet weak var weightView: UIView!
    @IBOutlet weak var weightTitle: UILabel!
    @IBOutlet weak var weightScale: UILabel!
    @IBOutlet weak var userWeight: UITextField!
    
    @IBOutlet weak var logInButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    @IBAction func logInFB(sender: UIButton) {
        
        // check height& weight: value, correct type, save to userdefault
        if userHeight.text != nil {
            guard let userHeight = getDoubleType(userHeight.text!) else { return }
            NSUserDefaults.standardUserDefaults().setDouble(userHeight, forKey: UserInfoManager.NSUserDefaultKey.Height)
            
        }else {
            print("no height data")
            // todo: alarm
            return
        }
        
        if userWeight.text != nil {
            guard let userWeight = getDoubleType(userWeight.text!) else { return }
            NSUserDefaults.standardUserDefaults().setDouble(userWeight, forKey: UserInfoManager.NSUserDefaultKey.Weight)
        }else {
            print("no weight data")
            // todo: alarm - can't be empty
            return
        }
                
        // log in facebook
        
        UserInfoManager.sharedManager.LogInWithFacebook(
            fromViewController: self,
            success: { user in
                
                if let swRevealViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SWRevealViewController") as? SWRevealViewController {
                    
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.window?.rootViewController = swRevealViewController
                    self.presentViewController(swRevealViewController, animated: true, completion: nil)
                }
                
            },
            failure: { error in
                // todo: alert
            }
        )
    }
    
    private func getDoubleType(text: String) -> Double? {
        guard let doubleTypeText = Double(text) else {
            // todo: alarm - type double
            userHeight.text = nil
            userWeight.text = nil
            return nil
        }
        return doubleTypeText
    }
    
    private func setUp() {
        
        // back ground
        self.view.backgroundColor = UIColor.mrLightblueColor()
        let backgroundGradientlayer = CAGradientLayer()
        backgroundGradientlayer.frame.size = backgroundImage.frame.size
        backgroundGradientlayer.colors = [UIColor.mrLightblueColor().CGColor, UIColor.pineGreen50Color().CGColor]
        backgroundImage.layer.addSublayer(backgroundGradientlayer)
        
        // App name
        self.appName.textColor = UIColor.mrWhiteColor()
        self.appName.font = UIFont.textStyle21Font()
        self.appName.shadowOffset.height = 2
        self.appName.shadowColor = UIColor.mrBlack25Color()
        self.appName.text = "Mr. Ride"
        
        // height & weight
        self.heightView.layer.cornerRadius = 4
        self.heightView.clipsToBounds = true
        self.heightTitle.textColor = UIColor.mrDarkSlateBlueColor()
        self.heightTitle.font = UIFont.textStyle22Font()
        self.heightTitle.text = "Height"
        self.heightScale.textColor = UIColor.mrDarkSlateBlueColor()
        self.heightScale.font = UIFont.textStyle23Font()
        self.heightScale.text = "cm"
        
        self.weightView.layer.cornerRadius = 4
        self.weightView.clipsToBounds = true
        self.weightTitle.textColor = UIColor.mrDarkSlateBlueColor()
        self.weightTitle.font = UIFont.textStyle22Font()
        self.weightTitle.text = "Weight"
        self.weightScale.textColor = UIColor.mrDarkSlateBlueColor()
        self.weightScale.font = UIFont.textStyle23Font()
        self.weightScale.text = "kg"
        
        // user info
        self.userHeight.delegate = self
        self.userHeight.textColor = UIColor.mrDarkSlateBlueColor()
        self.userHeight.font = UIFont.textStyle24Font()
        self.userWeight.delegate = self
        self.userWeight.textColor = UIColor.mrDarkSlateBlueColor()
        self.userWeight.font = UIFont.textStyle24Font()
        
        // logIn Button appearence
        self.logInButton.layer.cornerRadius = 30
        self.logInButton.setTitle("     Log In", forState: .Normal)
        self.logInButton.setTitleShadowColor(UIColor.mrBlack25Color(), forState: .Normal)
        self.logInButton.setTitleColor(UIColor.mrLightblueColor(), forState: .Normal)
        self.logInButton.titleLabel?.font = UIFont.asiTextStyle16Font()
        self.logInButton.titleLabel?.shadowOffset.height = -1
    }
    
    // set status bar color
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // hide keyboard
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
