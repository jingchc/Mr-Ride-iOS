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
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)
        
        if selected {
            pageName.textColor = UIColor.mrWhiteColor()
            dot.backgroundColor = UIColor.mrWhiteColor()
        } else {
            pageName.textColor = UIColor.mrWhite50Color()
            dot.backgroundColor = UIColor.mrDarkSlateBlueColor()
        }
    }
    
}
