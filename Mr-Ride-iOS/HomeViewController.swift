//
//  HomeViewController.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/5/23.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        set()
        
    }
    
    func set() {
        self.view.backgroundColor = UIColor.mrLightblueColor()
        
        let templateTittleIcon = UIImage(named: "icon-bike")?.imageWithRenderingMode(.AlwaysTemplate)
        let tittleImageView = UIImageView(image: templateTittleIcon)
        tittleImageView.tintColor = UIColor.mrWhiteColor()
        self.navigationItem.titleView = tittleImageView
        
        let templateMenuIcon = UIImage(named: "icon-menu")?.imageWithRenderingMode(.AlwaysTemplate)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.mrWhiteColor()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: templateMenuIcon, style: .Plain, target: nil, action: nil)
       
        if self.revealViewController() != nil {
            self.navigationItem.leftBarButtonItem?.target = self.revealViewController()
            self.navigationItem.leftBarButtonItem?.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        
        
    }

}
