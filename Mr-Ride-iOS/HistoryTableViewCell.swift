//
//  HistoryTableViewCell.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/6/16.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var th: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var km: UILabel!
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
   
        //        self.layer.borderWidth = 5
//                self.layer.borderColor = UIColor.clearColor().CGColor
//                self.layoutMargins = UIEdgeInsetsMake(50, 50, 10, 50)
//                self.separatorInset = UIEdgeInsets(top: 50, left: 50, bottom: 10, right: 50)
//        
//                self.separatorInset = UIEdgeInsetsMake(50 , 50, 10, 50)
//        

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
          }
    
    private func setUp(){
        selectionStyle = .None
        backgroundView?.opaque = false
        
    }

}
