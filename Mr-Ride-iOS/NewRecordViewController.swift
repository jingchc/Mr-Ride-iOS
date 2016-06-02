//
//  NewRecordViewController.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/5/23.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import UIKit
import CoreLocation
import HealthKit

class NewRecordViewController: UIViewController {
    
    // items
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var nowDistance: UILabel!
    @IBOutlet weak var averageSpeed: UILabel!
    @IBOutlet weak var nowSpeed: UILabel!
    @IBOutlet weak var calories: UILabel!
    @IBOutlet weak var nowCalories: UILabel!
    @IBOutlet weak var nowTime: UILabel!
    @IBOutlet weak var buttonBorder: UIView!
    @IBOutlet weak var rideButton: UIButton!
    
    let gradient = CAGradientLayer()
    
    // locationManager
    
    var distance = 0.0
    
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.activityType = .Fitness
        _locationManager.distanceFilter = 10.0
        return _locationManager
    }()

    lazy var locations = [CLLocation]()
    lazy var timer = NSTimer()

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        setLabels()
        setButton()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.requestAlwaysAuthorization()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // set start & pause & continue animation
    
    var currentAnimation = RideButtonFunction.Start
    var time: NSTimeInterval = 0.00
    var startTime = NSDate.timeIntervalSinceReferenceDate()
    var pausedTime: NSTimeInterval = 0.00
    var continuedTime: NSTimeInterval = 0.00
    var totalPausedTime: NSTimeInterval = 0.00
    
    
    @IBAction func rideButtonPressed(sender: UIButton) {
        switch currentAnimation {
        case .Start:
            UIView.animateWithDuration(0.6, animations: {
                self.rideButton.transform = CGAffineTransformMakeScale(0.5, 0.5)
                self.rideButton.layer.cornerRadius = 4
            })
            self.currentAnimation = .Pause
            
            
            // timer start
            self.startTime = NSDate.timeIntervalSinceReferenceDate()
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01,
                target: self,
                selector: #selector(NewRecordViewController.eachMillisecond(_:)),
                userInfo: nil,
                repeats: true)
            
            // location update
            startLocationUpdates()

        case .Pause:
            UIView.animateWithDuration(0.6, animations: {
                self.rideButton.transform = CGAffineTransformMakeScale(1, 1)
                self.rideButton.layer.cornerRadius = self.rideButton.frame.width / 2
            })
            self.currentAnimation = .Continue
            
            // timer pause
            timer.invalidate()
            self.pausedTime = NSDate.timeIntervalSinceReferenceDate()
          
        case .Continue:
            UIView.animateWithDuration(0.6, animations: {
                self.rideButton.transform = CGAffineTransformMakeScale(0.5, 0.5)
                self.rideButton.layer.cornerRadius = 4
            })
            self.currentAnimation = .Pause

            
            self.continuedTime = NSDate.timeIntervalSinceReferenceDate()
            self.totalPausedTime += self.continuedTime - self.pausedTime
         
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01,
                target: self,
                selector: #selector(NewRecordViewController.eachMillisecond(_:)),
                userInfo: nil,
                repeats: true)
        }
    }
    
   
    @objc func eachMillisecond(timer: NSTimer) {
        self.time = NSDate.timeIntervalSinceReferenceDate() - self.startTime - self.totalPausedTime        
        self.nowTime.text = String(getTimeFormat(self.time))
        
    }
    
    func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    // time format
    
    func getTimeFormat(trackDuration: NSTimeInterval) -> NSString {
        let time = NSInteger(trackDuration)
        let milliseconds = Int((trackDuration % 1) * 100)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = time / 3600
        
        return NSString(format: "%0.2d:%0.2d:%0.2d.%0.2d", hours, minutes,seconds,milliseconds)
        
    }
   
}

// set navigation & background & label & button

extension NewRecordViewController {
    
    override func viewDidLayoutSubviews() {
        gradient.removeFromSuperlayer()
        
        let color1 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.60)
        let color2 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.40)
        gradient.frame = self.view.frame
        gradient.colors = [color1.CGColor, color2.CGColor]
        self.view.layer.insertSublayer(gradient, atIndex: 0)
        
    }
    
    func setBackground() {
        
        self.view.backgroundColor = UIColor.mrLightblueColor()
        let color1 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.60)
        let color2 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.40)
        gradient.frame = self.view.frame
        gradient.colors = [color1.CGColor, color2.CGColor]
        self.view.layer.insertSublayer(gradient, atIndex: 0)
        
    }
    
    func setLabels() {
        
        self.distanceLabel.font = UIFont.mrTextStyle12Font()
        self.distanceLabel.textColor = UIColor.whiteColor()
        self.distanceLabel.shadowColor = UIColor.mrBlack20Color()
        self.distanceLabel.text = "Distance"
        
        self.averageSpeed.font = UIFont.mrTextStyle12Font()
        self.averageSpeed.textColor = UIColor.whiteColor()
        self.averageSpeed.shadowColor = UIColor.mrBlack20Color()
        self.averageSpeed.text = "Average Speed"
        
        self.calories.font = UIFont.mrTextStyle12Font()
        self.calories.textColor = UIColor.whiteColor()
        self.calories.shadowColor = UIColor.mrBlack20Color()
        self.calories.text = "Calories"
        
        self.nowDistance.font = UIFont.mrTextStyle9Font()
        self.nowDistance.textColor = UIColor.whiteColor()
        self.nowDistance.shadowColor = UIColor.mrBlack15Color()
        
        self.nowSpeed.font = UIFont.mrTextStyle9Font()
        self.nowSpeed.textColor = UIColor.whiteColor()
        self.nowSpeed.shadowColor = UIColor.mrBlack15Color()
        
        self.nowCalories.font = UIFont.mrTextStyle9Font()
        self.nowCalories.textColor = UIColor.whiteColor()
        self.nowCalories.shadowColor = UIColor.mrBlack15Color()
        
        self.nowTime.font = UIFont(name: "RobotoMono-Regular", size: 30)
        self.nowTime.textColor = UIColor.mrWhiteColor().colorWithAlphaComponent(0.8)
        self.nowTime.text = "00:00:00.00"
        
        // navigation left button
        let leftItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target:self, action: #selector(self.cancel))
        self.navigationItem.leftBarButtonItem = leftItem
        
        // navigation right button
        let rightItem = UIBarButtonItem(title: "Finish", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = rightItem

        
        // navigation title
        var getTodayDate = NSDateFormatter()
        var todayDate: NSDate {
            get{
                getTodayDate.dateFormat = "yyyy / MM / dd"
                return getTodayDate.dateFromString(self.navigationItem.title!)!
            }
            set {
                getTodayDate.dateFormat = "yyyy / MM / dd"
                self.navigationItem.title = getTodayDate.stringFromDate(newValue)
            }
        }
        todayDate = NSDate()
    }
    
    private func setButton() {
        
        self.buttonBorder.layer.borderColor = UIColor.whiteColor().CGColor
        self.buttonBorder.backgroundColor = UIColor.clearColor()
        self.buttonBorder.layer.borderWidth = 4
        self.buttonBorder.layer.shadowColor = UIColor.mrBlack20Color().CGColor
        self.buttonBorder.layer.cornerRadius = self.buttonBorder.frame.size.width / 2
        self.rideButton.layer.cornerRadius = self.rideButton.frame.width / 2
    }
    
    @objc func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

// MARK: - CLLocationManagerDelegate

extension NewRecordViewController: CLLocationManagerDelegate {
    
}

// button function change enum

enum RideButtonFunction {
    case Start
    case Pause
    case Continue
}


