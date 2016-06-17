//
//  MapViewController.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/6/17.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

}

extension MapViewController {
    
    private func setUp() {
        
        self.view.backgroundColor = UIColor.mrLightblueColor()
        
        // navigation transparent
        self.navigationItem.title = "Map"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
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