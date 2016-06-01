//
//  SideBarTableViewController.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/5/30.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import UIKit

class SideBarTableViewController: UITableViewController {
    
    let pageName = ["Home", "History"]
    var selectedIndexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    
    enum ToController: Int {
        case Home
        case History
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.mrDarkSlateBlueColor()
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageName.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! SideBarTableViewCell
        
        cell.backgroundColor = UIColor.mrDarkSlateBlueColor()
        cell.dot.backgroundColor = UIColor.mrDarkSlateBlueColor()
        cell.dot.layer.cornerRadius = cell.dot.frame.size.width / 2
        cell.dot.layer.shadowColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.25).CGColor
        cell.pageName.font = UIFont.mrTextStyle7Font()
        cell.pageName.textColor = UIColor.mrWhite50Color()
        cell.pageName.shadowColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.25)
        cell.pageName.text = pageName[indexPath.row]
        
        tableView.selectRowAtIndexPath(selectedIndexPath, animated: false, scrollPosition: .None)
        cell.selectionStyle = .None
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedIndexPath = indexPath
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        guard let toController = ToController(rawValue: indexPath.row) else { return }

        switch toController {
        case .Home:
            let destination = storyboard.instantiateViewControllerWithIdentifier("HomeNavigationController") as! HomeNavigationController
            SWRevealViewControllerSeguePushController.init(identifier: "HomeNavigationController", source: self, destination: destination).perform()
        case .History:
            let destination = storyboard.instantiateViewControllerWithIdentifier("HistoryNavigationController") as! HistoryNavigationController
            SWRevealViewControllerSeguePushController.init(identifier: "HistoryNavigationController", source: self, destination: destination).perform()
        }
    }
    


    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
}
