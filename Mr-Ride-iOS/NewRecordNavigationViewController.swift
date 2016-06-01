//
//  NewRecordNavigationViewController.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/6/1.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import UIKit

class NewRecordNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp(){
        self.navigationBar.barTintColor = UIColor.mrLightblueColor()
        self.navigationBar.tintColor = UIColor.mrWhiteColor()
        self.navigationBar.barStyle = UIBarStyle.Black
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.mrWhiteColor(), NSFontAttributeName: UIFont.mrTextStyle13Font()]
        
    }
    
//    private var displayValue: Double {
//        get {
//            return Double(display.text!)!
//        }
//        set {
//            display.text = String(newValue)
//        }
//    }



}
