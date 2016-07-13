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

    let alert = AlertHelper()

    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkHaveLoggedIn()
    }
    
    // check have logged in or not
    
    private func checkHaveLoggedIn() {
        if UserInfoManager.sharedManager.isLoggedIn {
            let swRevealViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SWRevealViewController") as! SWRevealViewController
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.window?.rootViewController = swRevealViewController
            self.presentViewController(swRevealViewController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func logInFB(sender: UIButton) {
        
        // check user height & weight
        
        guard let userHeightText = userHeight.text where !userHeightText.isEmpty else {
            alert.showPleaseTypeAlert(type: alert.enterHeight, on: self)
            return
        }
        
        guard let userHeightDouble = Double(userHeightText) else {
            userHeight.text = nil
            alert.showWrongTypeAlert(on: self)
            return
        }
        
        guard let userWeightText = userWeight.text where !userWeightText.isEmpty else {
            alert.showPleaseTypeAlert(type: alert.enterWeight, on: self)
            return
        }
        
        guard let userWeightDouble = Double(userWeightText) else {
            userWeight.text = nil
            alert.showWrongTypeAlert(on: self)
            return
        }

        
        NSUserDefaults.standardUserDefaults().setDouble(userHeightDouble, forKey: NSUserDefaultKey.Height)
        NSUserDefaults.standardUserDefaults().setDouble(userWeightDouble, forKey: NSUserDefaultKey.Weight)
        
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
            failure: { [weak self] error in
                guard let weakSelf = self else { return }
                weakSelf.alert.showFaceBookError(on: weakSelf, error: error)
                print("error - logInViewcontroller - FBLogIng - \(error)")

            }
        )
    }
    
    
    // MARK: - SetUp
    
    private func setUp() {
        
        // back ground
        view.backgroundColor = UIColor.mrLightblueColor()
        let backgroundGradientlayer = CAGradientLayer()
        backgroundGradientlayer.frame.size = backgroundImage.frame.size
        backgroundGradientlayer.colors = [UIColor.mrLightblueColor().CGColor, UIColor.pineGreen50Color().CGColor]
        backgroundImage.layer.addSublayer(backgroundGradientlayer)
        
        // App name
        appName.textColor = UIColor.mrWhiteColor()
        appName.font = UIFont.textStyle21Font()
        appName.shadowOffset.height = 2
        appName.shadowColor = UIColor.mrBlack25Color()
        appName.text = "Mr. Ride"
        
        // height & weight
        heightView.layer.cornerRadius = 4
        heightView.clipsToBounds = true
        heightTitle.textColor = UIColor.mrDarkSlateBlueColor()
        heightTitle.font = UIFont.textStyle22Font()
        heightTitle.text = "Height"
        heightScale.textColor = UIColor.mrDarkSlateBlueColor()
        heightScale.font = UIFont.textStyle23Font()
        heightScale.text = "cm"
        
        weightView.layer.cornerRadius = 4
        weightView.clipsToBounds = true
        weightTitle.textColor = UIColor.mrDarkSlateBlueColor()
        weightTitle.font = UIFont.textStyle22Font()
        weightTitle.text = "Weight"
        weightScale.textColor = UIColor.mrDarkSlateBlueColor()
        weightScale.font = UIFont.textStyle23Font()
        weightScale.text = "kg"
        
        // user info
        userHeight.delegate = self
        userHeight.textColor = UIColor.mrDarkSlateBlueColor()
        userHeight.font = UIFont.textStyle24Font()
        userWeight.delegate = self
        userWeight.textColor = UIColor.mrDarkSlateBlueColor()
        userWeight.font = UIFont.textStyle24Font()
        
        // logIn Button appearence
        logInButton.layer.cornerRadius = 30
        logInButton.setTitle("     Log In", forState: .Normal)
        logInButton.setTitleShadowColor(UIColor.mrBlack25Color(), forState: .Normal)
        logInButton.setTitleColor(UIColor.mrLightblueColor(), forState: .Normal)
        logInButton.titleLabel?.font = UIFont.asiTextStyle16Font()
        logInButton.titleLabel?.shadowOffset.height = -1
    }
    
    // set status bar color
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    //MARK: - HideKeyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
}
