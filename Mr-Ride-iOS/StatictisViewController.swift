//
//  StatictisViewController.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/6/12.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import UIKit

class StatictisViewController: UIViewController {
    
    // labels
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var totalDistance: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var averageSpeed: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var calories: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var totalTime: UILabel!
    @IBOutlet weak var goodJob: UILabel!
    
    // instance
    
    // todo: 判斷從record or history 來，決定left item是什麼，以及rideInfo的內容是什麼，目前這裡只有一個選擇，也就是從record來。
    
    
    var rideInfo: RideInfo? = NewRecordViewController.rideInfo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    deinit {
        print("StatictisViewController deinit")
    }
    
    // close
    @objc func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // set up
    private func setUp() {
        
        // backgroung
        let gradient = CAGradientLayer()
        self.view.backgroundColor = UIColor.mrLightblueColor()
        let color1 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.60)
        let color2 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.40)
        gradient.frame = self.view.frame
        gradient.colors = [color1.CGColor, color2.CGColor]
        self.view.layer.insertSublayer(gradient, atIndex: 0)

        // navigation left button
        let leftItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.close))
        self.navigationItem.leftBarButtonItem = leftItem
        
        // navigation title
         self.navigationItem.title = RideInfoHelper.shared.todayDate
        
        // labels
        
        distanceLabel.font = UIFont.mrTextStyle12Font()
        distanceLabel.textColor = UIColor.whiteColor()
        distanceLabel.shadowColor = UIColor.mrBlack20Color()
        distanceLabel.text = "Distance"
        
        speedLabel.font = UIFont.mrTextStyle12Font()
        speedLabel.textColor = UIColor.whiteColor()
        speedLabel.shadowColor = UIColor.mrBlack20Color()
        speedLabel.text = "Average Speed"
        
        caloriesLabel.font = UIFont.mrTextStyle12Font()
        caloriesLabel.textColor = UIColor.whiteColor()
        caloriesLabel.shadowColor = UIColor.mrBlack20Color()
        caloriesLabel.text = "Calories"
        
        timeLabel.font = UIFont.mrTextStyle12Font()
        timeLabel.textColor = UIColor.whiteColor()
        timeLabel.shadowColor = UIColor.mrBlack20Color()
        timeLabel.text = "Total Time"
        
        totalDistance.font = UIFont.mrTextStyle9Font()
        totalDistance.textColor = UIColor.whiteColor()
        totalDistance.shadowColor = UIColor.mrBlack15Color()
        
        averageSpeed.font = UIFont.mrTextStyle9Font()
        averageSpeed.textColor = UIColor.whiteColor()
        averageSpeed.shadowColor = UIColor.mrBlack15Color()
        
        calories.font = UIFont.mrTextStyle9Font()
        calories.textColor = UIColor.whiteColor()
        calories.shadowColor = UIColor.mrBlack15Color()
        calories.text = "?? kcal"
        
        totalTime.font = UIFont.mrTextStyle9Font()
        totalTime.textColor = UIColor.whiteColor()
        totalTime.shadowColor = UIColor.mrBlack15Color()
        
        goodJob.font = UIFont.textStyle20Font()
        goodJob.textColor = UIColor.whiteColor()
        goodJob.shadowColor = UIColor.mrBlack20Color()
        goodJob.text = "Good Job"
        
        if let _rideInfo = rideInfo {
            totalTime.text = RideInfoHelper.shared.getTimeFormat(_rideInfo.SpendTime) as String
            totalDistance.text = RideInfoHelper.shared.getDistanceFormat(_rideInfo.Distance)
            averageSpeed.text =  RideInfoHelper.shared.getSpeedFormat(_rideInfo.AverageSpeed)
            
            var calorie: String {
                let _calorie = NSString(format: "%.1f",_rideInfo.Calorie)
                return _calorie as String
            }
            calories.text = "\(calorie) kcal"
        }
        
    }
    
   

}
