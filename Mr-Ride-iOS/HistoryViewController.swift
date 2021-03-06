//
//  HistoryViewController.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/6/15.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import UIKit
import CoreData
import Charts

class HistoryViewController: UIViewController {
    
    static var ride: Ride? = nil
    static var historyPage: String? = nil
    
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    lazy var fetchedResultsController: NSFetchedResultsController = { [unowned self] in
        
        let rideFetchRequest = NSFetchRequest(entityName: "Ride")
        let sortDescriptor = NSSortDescriptor(key:"date", ascending: false)
        rideFetchRequest.sortDescriptors = [sortDescriptor]
        
        let frc = NSFetchedResultsController(
            fetchRequest: rideFetchRequest,
            managedObjectContext: self.moc,
            sectionNameKeyPath: "dateForSection",
            cacheName: nil)
        
        frc.delegate = self
        
        return frc
        
    }()
    
    @IBOutlet weak var historyTableView: UITableView!    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var chartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        fetchData()
//        checkCoreDate()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        historyTableView.reloadData()
        getChartViewContent()
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
        
        // table view
        
        historyTableView.opaque = false
        historyTableView.backgroundColor = UIColor.clearColor()
        historyTableView.showsVerticalScrollIndicator = false
 
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
        
        // chart View
        
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
}

// core data & table view

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    private func fetchData() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("fetch core data error")
        }
        
    }
    
    // MARK: - TableView Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! HistoryTableViewCell
        let ride = fetchedResultsController.objectAtIndexPath(indexPath) as! Ride
//        cell.layoutMargins = UIEdgeInsetsMake(0, 0, 10, 0)
//        cell.separatorInset = UIEdgeInsetsMake(0, 0, 10, 0)

        let calendar = NSCalendar.currentCalendar()
        let components = calendar.component(.Day, fromDate: ride.date!)
        
        cell.date.text = String(components)
        cell.distance.text = RideInfoHelper.shared.getDistanceFormatkm(Double(ride.distance!))
        cell.time.text = RideInfoHelper.shared.getTimeFormatForHistoryPage(ride.time!)
        
        //set up
        cell.date.font = UIFont(name: "RobotoMono-Light", size: 24)
        cell.th.font = UIFont(name: "RobotoMono-Light", size: 12)
        cell.distance.font = UIFont(name: "RobotoMono-Light", size: 24)
        cell.km.font = UIFont(name: "RobotoMono-Light", size: 24)
        cell.time.font = UIFont(name: "RobotoMono-Light", size: 24)

        return cell
        
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.name
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let ridedata = fetchedResultsController.objectAtIndexPath(indexPath) as! Ride
        
        HistoryViewController.ride = ridedata
        HistoryViewController.historyPage = "HistoryPage"

        let statisticPage = self.storyboard?.instantiateViewControllerWithIdentifier("StatictisViewController") as! StatictisViewController
        
        self.navigationController?.pushViewController(statisticPage, animated: true)
        
    }
    
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//     todo: cunstom header view(cell)
//    }
    
    
    private func checkCoreDate() {
        
        let request = NSFetchRequest(entityName: "Ride")
        
        do {
            let results = try moc.executeFetchRequest(request) as! [Ride]
            for result in results {
                print("=============")
                print(result.id)
                print(result.time)
                print(result.averageSpeed)
                print(result.date)
                print(result.distance)
                print(result.calorie)
                print(result.route)
                print("=============")
                
            }
        } catch {
            fatalError("fail to fetch core data")
        }
    }
}

// chart view

extension HistoryViewController {
    
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

    
}
