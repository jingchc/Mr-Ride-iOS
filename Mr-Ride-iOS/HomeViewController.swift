//
//  HomeViewController.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/5/23.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // labels
    
    
    @IBOutlet weak var totalDistance: UILabel!
    @IBOutlet weak var totalDistanceData: UILabel!
    @IBOutlet weak var totalCount: UILabel!
    @IBOutlet weak var totalConutData: UILabel!
    @IBOutlet weak var averageSpeed: UILabel!
    @IBOutlet weak var averageSpeedData: UILabel!
    @IBOutlet weak var rideButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setLabelContent()

    }
    
    deinit {
//        print("HomeViewController deinit")
    }
    
    
    @IBAction private func rideButtonTapped(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newRecordNavigationViewController = storyboard.instantiateViewControllerWithIdentifier("NewRecordNavigationViewController") as! NewRecordNavigationViewController
        self.presentViewController(newRecordNavigationViewController, animated: true, completion: nil)
        
    }
    
    
    
    private func setUp() {
        // backgroud
        self.view.backgroundColor = UIColor.mrLightblueColor()
        
        // navigation transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        // icon - bike
        let templateTittleIcon = UIImage(named: "icon-bike")?.imageWithRenderingMode(.AlwaysTemplate)
        let tittleImageView = UIImageView(image: templateTittleIcon)
        tittleImageView.tintColor = UIColor.mrWhiteColor()
        self.navigationItem.titleView = tittleImageView
        
        // icon - right button - menu
        let templateMenuIcon = UIImage(named: "icon-menu")?.imageWithRenderingMode(.AlwaysTemplate)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.mrWhiteColor()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: templateMenuIcon, style: .Plain, target: nil, action: nil)
       
        //side bar
        if self.revealViewController() != nil {
            self.navigationItem.leftBarButtonItem?.target = self.revealViewController()
            self.navigationItem.leftBarButtonItem?.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // label - tittle
        
        self.totalDistance.font = UIFont.mrTextStyle12Font()
        self.totalDistance.textColor = UIColor.mrWhiteColor()
        self.totalDistance.shadowColor = UIColor.mrBlack15Color()
        self.totalDistance.text = "Total Distance"

        self.totalCount.font = UIFont.mrTextStyle12Font()
        self.totalCount.textColor = UIColor.mrWhiteColor()
        self.totalCount.shadowColor = UIColor.mrBlack15Color()
        self.totalCount.text = "Total Count"
        
        self.averageSpeed.font = UIFont.mrTextStyle12Font()
        self.averageSpeed.textColor = UIColor.mrWhiteColor()
        self.averageSpeed.shadowColor = UIColor.mrBlack15Color()
        self.averageSpeed.text = "Average Speed"
        
        // label - data
        
        self.totalDistanceData.font = UIFont.mrTextStyle14Font()
        self.totalDistanceData.textColor = UIColor.mrWhiteColor()
        self.totalDistanceData.shadowOffset.height = 2
        self.totalDistanceData.shadowColor = UIColor.mrBlack25Color()
        self.totalDistanceData.text = "0 km"
        
        self.totalConutData.font = UIFont.asiTextStyle15Font()
        self.totalConutData.textColor = UIColor.mrWhiteColor()
        self.totalConutData.shadowColor = UIColor.mrBlack15Color()
        self.totalConutData.text = "0 times"
        
        self.averageSpeedData.font = UIFont.asiTextStyle15Font()
        self.averageSpeedData.textColor = UIColor.mrWhiteColor()
        self.averageSpeedData.shadowColor = UIColor.mrBlack15Color()
        self.averageSpeedData.text = "0 km / h"
        
        // button
        
        self.rideButton.titleLabel?.font = UIFont.asiTextStyle16Font()
        self.rideButton.tintColor = UIColor.mrLightblueColor()
        self.rideButton.titleLabel?.shadowOffset.height = 1
        self.rideButton.setTitleShadowColor(UIColor.mrBlack25Color(), forState: .Normal)
        self.rideButton.layer.backgroundColor = UIColor.mrWhiteColor().CGColor
        self.rideButton.layer.cornerRadius = 30
        self.rideButton.layer.shadowOffset.height = 2
        self.rideButton.layer.shadowColor = UIColor.mrBlack25Color().CGColor
        self.rideButton.layer.shadowOpacity = 2
        
    }
    
    private func setLabelContent() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let totalCount = defaults.stringForKey(NSUserDefaultKey.TotalCount)
        let totalDistance = defaults.stringForKey(NSUserDefaultKey.TotalDistance)
        let averageSpeed = defaults.stringForKey(NSUserDefaultKey.AverageSpeed)
        
        if totalCount != nil {
            let intTotalCount = Int(totalCount!)!
            totalConutData.text = "\(intTotalCount) times"
        }
        if totalDistance != nil {
            let doubleTotalDistance = Double(totalDistance!)! / 1000
            let _totalDistance = NSString(format: "%.1f", doubleTotalDistance)
            self.totalDistanceData.text = "\(String(_totalDistance)) km"
        }
        
        if averageSpeed != nil {
            let doublAverageSpeed = Double(averageSpeed!)! * 3.6
            let _doublAverageSpeed = NSString(format: "%.1f", doublAverageSpeed)
            self.averageSpeedData.text = "\(String(_doublAverageSpeed)) km/h"
   
        }
        
    }

}
