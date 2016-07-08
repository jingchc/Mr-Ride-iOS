//
//  HomeViewController.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/5/23.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import UIKit
import Charts
import Crashlytics
import CoreData
import CoreLocation


class HomeViewController: UIViewController {
    
    // chart View
    
    @IBOutlet weak var chartView: LineChartView!
    
    
    // labels
    
    @IBOutlet weak var totalDistance: UILabel!
    @IBOutlet weak var totalDistanceData: UILabel!
    @IBOutlet weak var totalCount: UILabel!
    @IBOutlet weak var totalConutData: UILabel!
    @IBOutlet weak var averageSpeed: UILabel!
    @IBOutlet weak var averageSpeedData: UILabel!
    @IBOutlet weak var rideButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        getChartViewContent()
        restroomLoadDataFromServer()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setLabelContent()
        
    }
    
    deinit {
//        print("HomeViewController deinit")
    }
    
    
    @IBAction private func rideButtonTapped(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newRecordNavigationViewController = storyboard.instantiateViewControllerWithIdentifier("NewRecordNavigationViewController") as! NewRecordNavigationViewController
        presentViewController(newRecordNavigationViewController, animated: true, completion: nil)
        
    }
    
    private func setUp() {
        // backgroud
        view.backgroundColor = UIColor.mrLightblueColor()
        
        // navigation transparent
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.translucent = true
        
        // icon - bike
        let templateTittleIcon = UIImage(named: "icon-bike")?.imageWithRenderingMode(.AlwaysTemplate)
        let tittleImageView = UIImageView(image: templateTittleIcon)
        tittleImageView.tintColor = UIColor.mrWhiteColor()
        navigationItem.titleView = tittleImageView
        
        // icon - right button - menu
        let templateMenuIcon = UIImage(named: "icon-menu")?.imageWithRenderingMode(.AlwaysTemplate)
        navigationItem.leftBarButtonItem?.tintColor = UIColor.mrWhiteColor()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: templateMenuIcon, style: .Plain, target: nil, action: nil)
       
        //side bar
        if revealViewController() != nil {
            navigationItem.leftBarButtonItem?.target = self.revealViewController()
            navigationItem.leftBarButtonItem?.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // label - tittle
        
        totalDistance.font = UIFont.mrTextStyle12Font()
        totalDistance.textColor = UIColor.mrWhiteColor()
        totalDistance.shadowColor = UIColor.mrBlack15Color()
        totalDistance.text = "Total Distance"

        totalCount.font = UIFont.mrTextStyle12Font()
        totalCount.textColor = UIColor.mrWhiteColor()
        totalCount.shadowColor = UIColor.mrBlack15Color()
        totalCount.text = "Total Count"
        
        averageSpeed.font = UIFont.mrTextStyle12Font()
        averageSpeed.textColor = UIColor.mrWhiteColor()
        averageSpeed.shadowColor = UIColor.mrBlack15Color()
        averageSpeed.text = "Average Speed"
        
        // label - data
        
        totalDistanceData.font = UIFont.mrTextStyle14Font()
        totalDistanceData.textColor = UIColor.mrWhiteColor()
        totalDistanceData.shadowOffset.height = 2
        totalDistanceData.shadowColor = UIColor.mrBlack25Color()
        totalDistanceData.text = "0 km"
        
        totalConutData.font = UIFont.asiTextStyle15Font()
        totalConutData.textColor = UIColor.mrWhiteColor()
        totalConutData.shadowColor = UIColor.mrBlack15Color()
        totalConutData.text = "0 times"
        
        averageSpeedData.font = UIFont.asiTextStyle15Font()
        averageSpeedData.textColor = UIColor.mrWhiteColor()
        averageSpeedData.shadowColor = UIColor.mrBlack15Color()
        averageSpeedData.text = "0 km / h"
        
        // button
        
        rideButton.titleLabel?.font = UIFont.asiTextStyle16Font()
        rideButton.tintColor = UIColor.mrLightblueColor()
        rideButton.titleLabel?.shadowOffset.height = 1
        rideButton.setTitleShadowColor(UIColor.mrBlack25Color(), forState: .Normal)
        rideButton.layer.backgroundColor = UIColor.mrWhiteColor().CGColor
        rideButton.layer.cornerRadius = 30
        rideButton.layer.shadowOffset.height = 2
        rideButton.layer.shadowColor = UIColor.mrBlack25Color().CGColor
        rideButton.layer.shadowOpacity = 2
        
        // chart view
        chartView.backgroundColor = UIColor.clearColor()
        chartView.userInteractionEnabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.dragEnabled = false
        chartView.drawMarkers = false
        chartView.descriptionText = ""
        chartView.legend.enabled = false
        
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        
        chartView.xAxis.drawLabelsEnabled = false
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false

    }
    
    
    // get data label content - userdefault
    
    private func setLabelContent() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let totalCount = defaults.stringForKey(NSUserDefaultKey.TotalCount)
        let totalDistance = defaults.stringForKey(NSUserDefaultKey.TotalDistance)
        let averageSpeed = defaults.stringForKey(NSUserDefaultKey.AverageSpeed)
        
        if totalCount != nil {
            let intTotalCount = Int(totalCount!)!
            totalConutData.text = "\(intTotalCount) times"
        }
        if totalDistance != nil {
            let doubleTotalDistance = Double(totalDistance!)! / 1000
            let _totalDistance = NSString(format: "%.1f", doubleTotalDistance)
            self.totalDistanceData.text = "\(String(_totalDistance)) km"
        }
        
        if averageSpeed != nil {
            let doublAverageSpeed = Double(averageSpeed!)! * 3.6
            let _doublAverageSpeed = NSString(format: "%.1f", doublAverageSpeed)
            self.averageSpeedData.text = "\(String(_doublAverageSpeed)) km/h"
   
        }
        
    }
    
    // get chart view content - core data
    
    private func getChartViewContent() {
        
        // get core data
        let rideInfos = RideInfoModel().fetchDataFromCoreData()
        
        // date and distance array
        var dates: [String] = []
        var distances: [Double] = []
        
        for rideinfo in rideInfos {
            let date = RideInfoHelper.shared.getDateFormat(rideinfo.Date)
            let distance = rideinfo.Distance
            
            dates.append(date)
            distances.append(distance)
        }
                
        setChartViewContent(dates, values: distances)
        
    }
    
    private func setChartViewContent(dataPoints:[String], values:[Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "")
        
        // line attributes
        lineChartDataSet.drawFilledEnabled = true
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.drawValuesEnabled = false
        lineChartDataSet.mode = .CubicBezier
        lineChartDataSet.lineWidth = 0.0
        
        // chart fill attribute
        let gradientColors = [UIColor.mrLightblueColor().CGColor, UIColor.waterBlueColor().CGColor]
        let colorLocations:[CGFloat] = [0.0, 0.19]
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), gradientColors, colorLocations)
        lineChartDataSet.fill = ChartFill.fillWithLinearGradient(gradient!, angle: 90.0)
        
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        chartView.data = lineChartData
        
    }
    
    // load restroom data from server
    
    private func restroomLoadDataFromServer(){
        cleanUpCoreData()
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
            
            DataManager.shared.getRestrooms(
                success: { result in
                    
                    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
                    
                    for restroomInfoFromServer in result {
                        let restroom = NSEntityDescription.insertNewObjectForEntityForName("Restroom", inManagedObjectContext: moc) as! Restroom
                        
                        restroom.id = restroomInfoFromServer.id
                        restroom.name = restroomInfoFromServer.name
                        restroom.place = restroomInfoFromServer.place
                        restroom.address = restroomInfoFromServer.address
                        restroom.longitude = restroomInfoFromServer.coordinate.longitude
                        restroom.latitude = restroomInfoFromServer.coordinate.latitude
                        
                        do { try moc.save() } catch { fatalError(" core data error \(error)") }
                    }
                },
                failure: { result in
                    
                    // todo: error handling
                    print("no~~")
                    
                }
            )
        }
    }

    
    private func cleanUpCoreData() {
        
        let request = NSFetchRequest(entityName: "Restroom")
        let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        do {
            let results = try moc.executeFetchRequest(request) as! [Restroom]
            
            for result in results {
                moc.deleteObject(result)
            }
        } catch {
            fatalError("clean up core data error")
        }
    }

}
