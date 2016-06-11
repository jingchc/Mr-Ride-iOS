//
//  SideBarTableViewController.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/5/30.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class SideBarTableViewController: UITableViewController {
    
    let pageName = ["Home", "History", "Map"]
    var selectedIndexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
//    let buttonView:UIView = UIView( frame: CGRect(x: 0, y: 0, width: 150, height: 30) )
    let logOutButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 30))

    
    enum ToController: Int {
        case Home
        case History
        case Map
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.mrDarkSlateBlueColor()
        addLogOutButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.selectRowAtIndexPath(selectedIndexPath, animated: false, scrollPosition: .None)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        reLocationLogOutButton()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageName.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! SideBarTableViewCell
        
        cell.backgroundColor = UIColor.mrDarkSlateBlueColor()
        cell.dot.backgroundColor = UIColor.mrDarkSlateBlueColor()
        cell.dot.layer.cornerRadius = cell.dot.frame.size.width / 2
        cell.dot.layer.shadowColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.25).CGColor
        cell.pageName.font = UIFont.mrTextStyle7Font()
        cell.pageName.textColor = UIColor.mrWhite50Color()
        cell.pageName.shadowColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.25)
        cell.pageName.text = pageName[indexPath.row]
        cell.selectionStyle = .None
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedIndexPath = indexPath
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        guard let toController = ToController(rawValue: indexPath.row) else { return }

        switch toController {
        case .Home:
            let destination = storyboard.instantiateViewControllerWithIdentifier("HomeNavigationController") as! HomeNavigationController
            SWRevealViewControllerSeguePushController.init(identifier: "HomeNavigationController", source: self, destination: destination).perform()
        case .History:
            let destination = storyboard.instantiateViewControllerWithIdentifier("HistoryNavigationController") as! HistoryNavigationController
            SWRevealViewControllerSeguePushController.init(identifier: "HistoryNavigationController", source: self, destination: destination).perform()
        case .Map:
            print("mapViewController")
            
        }
    }
    
    
    private func addLogOutButton() {
        self.logOutButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        self.logOutButton.layer.cornerRadius = 4
        self.logOutButton.setTitle("Log Out", forState: .Normal)
        self.logOutButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.logOutButton.titleLabel?.font = UIFont.textStyle23Font()
        self.logOutButton.addTarget(self, action: #selector(goToLogInPage), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(logOutButton)

    }
    
    private func reLocationLogOutButton() {
        
        let revealViewController = self.revealViewController()
        
        self.logOutButton.frame.origin.y = tableView.contentOffset.y + tableView.frame.size.height - self.logOutButton.frame.size.height - 50
        self.logOutButton.frame.origin.x = tableView.contentOffset.x + ((self.view.frame.width - revealViewController.rearViewRevealOverdraw - self.logOutButton.frame.width) / 2)
        
        self.view.bringSubviewToFront(logOutButton)
    }
    
     @objc private func goToLogInPage() {
        
        if let logInViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LogInViewController") as? LogInViewController {
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.window?.rootViewController = logInViewController
            self.presentViewController(logInViewController, animated: true, completion: nil)
        }
        
        UserInfoManager.sharedManager.logOut()

    }
    
    
    
}
