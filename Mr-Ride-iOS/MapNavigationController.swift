//
//  MapNavigationController.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/6/17.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import UIKit

class MapNavigationController: UINavigationController {

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
    

}
