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
    
    
    // locationManager
    
    var seconds = 0.0
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
        // Dispose of any resources that can be recreated.
    }
    
    
    func eachSecond(timer: NSTimer) {
        
        seconds += 1
        let secondsQuantity = HKQuantity(unit: HKUnit.secondUnit(), doubleValue: seconds)
        nowTime.text = secondsQuantity.description
        let distanceQuantity = HKQuantity(unit: HKUnit.meterUnit(), doubleValue: distance)
        nowDistance.text = distanceQuantity.description
        
//        let paceUnit = HKUnit.hourUnit().unitDividedByUnit(HKUnit.kilometerUnit())
        
        
        
        
    }
   
}

// set navigation & background & label

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
        
    }
    
}

// MARK: - CLLocationManagerDelegate

extension NewRecordViewController: CLLocationManagerDelegate {
    
    
    
}




