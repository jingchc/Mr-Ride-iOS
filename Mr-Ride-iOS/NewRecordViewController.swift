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
    
    // locationManager
    
//    var timeFormat = NSDateFormatter().dateFormat
//    var seconds = 0.01
    var distance = 0.0
    var time: NSTimeInterval = 0.00
    var startTime = NSDate.timeIntervalSinceReferenceDate()
    
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
    
    var currentAnimation = 0
    
    @IBAction func rideButtonPressed(sender: UIButton) {
        
        guard let rideButtonFunction = RideButtonFunction(rawValue: currentAnimation) else { return }
        switch rideButtonFunction {
        case .Start:
            UIView.animateWithDuration(0.6, animations: {
                self.rideButton.transform = CGAffineTransformMakeScale(0.5, 0.5)
                self.rideButton.layer.cornerRadius = 4
            })
            self.currentAnimation = self.currentAnimation + 1
            
            // timer start
            timer = NSTimer.scheduledTimerWithTimeInterval(0.02,
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
            self.currentAnimation = self.currentAnimation + 1
            
            
          
        case .Continue:
            UIView.animateWithDuration(0.6, animations: {
                self.rideButton.transform = CGAffineTransformMakeScale(0.5, 0.5)
                self.rideButton.layer.cornerRadius = 4
            })
            self.currentAnimation = self.currentAnimation - 1
            
        }
        
    }
    
    
    @objc func eachMillisecond(timer: NSTimer) {
        
        self.time = NSDate.timeIntervalSinceReferenceDate() - startTime
        self.nowTime.text = String(getTimeFormat(self.time))
//        print(self.startTime)
//        print(self.time)
        
//        seconds += 0.01
//        let secondsQuantity = HKQuantity(unit: HKUnit.secondUnit(), doubleValue: seconds)
//        nowTime.text = secondsQuantity.description
//        let distanceQuantity = HKQuantity(unit: HKUnit.meterUnit(), doubleValue: distance)
//        nowDistance.text = distanceQuantity.description
//        
//        let paceUnit = HKUnit.hourUnit().unitDividedByUnit(HKUnit.meterUnit())
//        let paceQuantity = HKQuantity(unit: paceUnit, doubleValue: seconds / distance)
//        nowSpeed.text = paceQuantity.description
        
    }
    
    func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    // time format
    
    func getTimeFormat(trackDuration: NSTimeInterval) -> NSString {
        
        let time = NSInteger(trackDuration)
        let milliseconds = Int((trackDuration % 1) * 100)
        let seconds = time % 60
        let minutes = seconds % 60
        let hours = time / 3600
        
        return NSString(format: "%0.2d:%0.2d:%0.2d.%0.2d", hours, minutes,seconds,milliseconds)
        
    }
   
}

// set navigation & background & label & button

extension NewRecordViewController {
    
    // title = totay date
    
    // background
    
    func setBackground() {
        
        self.view.backgroundColor = UIColor.mrLightblueColor()
        let color1 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.60)
        let color2 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.40)
        let gradient = CAGradientLayer()
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
        
        self.nowTime.font = UIFont.mrTextStyle14Font()
        self.nowTime.textColor = UIColor.mrWhiteColor().colorWithAlphaComponent(0.8)
        self.nowTime.text = "00:00:00.00"
        
    }
    
    func setButton() {
        
        self.buttonBorder.layer.borderColor = UIColor.whiteColor().CGColor
        self.buttonBorder.backgroundColor = UIColor.clearColor()
        self.buttonBorder.layer.borderWidth = 4
        self.buttonBorder.layer.shadowColor = UIColor.mrBlack20Color().CGColor
        self.buttonBorder.layer.cornerRadius = self.buttonBorder.frame.size.width / 2
        self.rideButton.layer.cornerRadius = self.rideButton.frame.width / 2
        
    }
    
}

// MARK: - CLLocationManagerDelegate

extension NewRecordViewController: CLLocationManagerDelegate {
    
}

// button function change enum

enum RideButtonFunction: Int {
    case Start = 0
    case Pause
    case Continue
}


