//
//  HistoryViewController.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/6/15.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    
    @IBOutlet weak var backgroundImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

extension HistoryViewController {
    
    private func setUp() {
        
        // backbround
        self.view.backgroundColor = UIColor.mrLightblueColor()
        let backgroundGradientlayer = CAGradientLayer()
        backgroundGradientlayer.frame.size = backgroundImage.frame.size
        backgroundGradientlayer.colors = [UIColor.mrLightblueColor().CGColor, UIColor.pineGreen50Color().CGColor]
        backgroundImage.layer.addSublayer(backgroundGradientlayer)
        
        // navigation transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        //navigation title
        self.navigationItem.title = "History"
        
        // icon - right button - menu
        let templateMenuIcon = UIImage(named: "icon-menu")?.imageWithRenderingMode(.AlwaysTemplate)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.mrWhiteColor()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: templateMenuIcon, style: .Plain, target: nil, action: nil)
        
        // side bar
        if self.revealViewController() != nil {
            self.navigationItem.leftBarButtonItem?.target = self.revealViewController()
            self.navigationItem.leftBarButtonItem?.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
}
