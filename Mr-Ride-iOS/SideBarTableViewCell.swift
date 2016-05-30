//
//  SideBarTableViewCell.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/5/30.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import UIKit

class SideBarTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dot: UIView!
    @IBOutlet weak var pageName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        set()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
//        self.dot.backgroundColor = UIColor.mrWhiteColor()
        self.layer.backgroundColor = UIColor.mrDarkSlateBlueColor().CGColor
        self.pageName.textColor = UIColor.mrWhite50Color()
        

        // Configure the view for the selected state
    }
    
    func set() {
        
        self.layer.backgroundColor = UIColor.mrDarkSlateBlueColor().CGColor
        
        self.dot.layer.cornerRadius = self.dot.frame.size.width / 2
        self.dot.backgroundColor = UIColor.mrDarkSlateBlueColor()
        self.dot.layer.shadowColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.25).CGColor
        self.pageName.font = UIFont.mrTextStyle7Font()
        self.pageName.textColor = UIColor.mrWhite50Color()
        self.pageName.shadowColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.25)
    }

}
