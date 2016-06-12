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
        
        // labels
        
        self.distanceLabel.font = UIFont.mrTextStyle12Font()
        self.distanceLabel.textColor = UIColor.whiteColor()
        self.distanceLabel.shadowColor = UIColor.mrBlack20Color()
        self.distanceLabel.text = "Distance"
        
        self.speedLabel.font = UIFont.mrTextStyle12Font()
        self.speedLabel.textColor = UIColor.whiteColor()
        self.speedLabel.shadowColor = UIColor.mrBlack20Color()
        self.speedLabel.text = "Average Speed"
        
        self.caloriesLabel.font = UIFont.mrTextStyle12Font()
        self.caloriesLabel.textColor = UIColor.whiteColor()
        self.caloriesLabel.shadowColor = UIColor.mrBlack20Color()
        self.caloriesLabel.text = "Calories"
        
        self.timeLabel.font = UIFont.mrTextStyle12Font()
        self.timeLabel.textColor = UIColor.whiteColor()
        self.timeLabel.shadowColor = UIColor.mrBlack20Color()
        self.timeLabel.text = "Total Time"
        
        self.totalDistance.font = UIFont.mrTextStyle9Font()
        self.totalDistance.textColor = UIColor.whiteColor()
        self.totalDistance.shadowColor = UIColor.mrBlack15Color()
        self.totalDistance.text = "0 m"
        
        self.averageSpeed.font = UIFont.mrTextStyle9Font()
        self.averageSpeed.textColor = UIColor.whiteColor()
        self.averageSpeed.shadowColor = UIColor.mrBlack15Color()
        self.averageSpeed.text = "0 km / h"
        
        self.calories.font = UIFont.mrTextStyle9Font()
        self.calories.textColor = UIColor.whiteColor()
        self.calories.shadowColor = UIColor.mrBlack15Color()
        self.calories.text = "?? kcal"

        self.totalTime.font = UIFont.mrTextStyle9Font()
        self.totalTime.textColor = UIColor.whiteColor()
        self.totalTime.shadowColor = UIColor.mrBlack15Color()
        self.totalTime.text = "00:00:00.00"
        
        self.goodJob.font = UIFont.textStyle20Font()
        self.goodJob.textColor = UIColor.whiteColor()
        self.goodJob.shadowColor = UIColor.mrBlack20Color()
        self.goodJob.text = "Good Job"
        
    }
    
   

}
