//
//  NavigationController.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/5/23.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barTintColor = UIColor.mrLightblueColor()
        self.navigationBar.tintColor = UIColor.mrWhiteColor()
        self.navigationBar.barStyle = UIBarStyle.Black
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.mrWhiteColor(), NSFontAttributeName: UIFont.mrTextStyle13Font()]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
