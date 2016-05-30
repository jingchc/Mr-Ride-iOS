//
//  NavigationController.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/5/23.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import UIKit

class HomeNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        set()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func set(){
        self.navigationBar.barTintColor = UIColor.mrLightblueColor()
        self.navigationBar.tintColor = UIColor.mrWhiteColor()
        self.navigationBar.barStyle = UIBarStyle.Black
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.mrWhiteColor(), NSFontAttributeName: UIFont.mrTextStyle13Font()]
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        
        let templateImage = UIImage(named: "icon-bike")?.imageWithRenderingMode(.AlwaysTemplate)
        
        imageView.contentMode = .ScaleAspectFill
        imageView.tintColor = UIColor.mrWhiteColor()
        imageView.image = templateImage
        self.navigationItem.titleView = imageView
        
        
        
        
    }
}
