//
//  NewRecordViewController.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/5/23.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import UIKit
import CoreLocation
import HealthKit
import MapKit

class NewRecordViewController: UIViewController {
    
    // rideInfo
    static var rideInfo: RideInfo? = nil
    
    // items
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var nowDistance: UILabel!
    @IBOutlet weak var averageSpeed: UILabel!
    @IBOutlet weak var nowSpeed: UILabel!
    @IBOutlet weak var calories: UILabel!
    @IBOutlet weak var nowCalories: UILabel!
    @IBOutlet weak var nowTime: UILabel!
    @IBOutlet weak var buttonBorder: UIView!
    @IBOutlet weak var rideButton: UIButton!
    let gradient = CAGradientLayer()
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        setLabels()
        setButton()
        setMapView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    override func viewDidDisappear(animated: Bool) {
        mapView = nil
    }
    
    
    deinit {
        print("NewRecordViewController deinit")
    }
    
    // locationManager
    
    var distance = 0.0
    var currentDistance = 0.0
    var totalDistance = 0.0
        { didSet
        {
            nowDistance.text = RideInfoHelper.shared.getDistanceFormat(totalDistance)
            nowSpeed.text = RideInfoHelper.shared.getSpeedFormat(currentSpeed)
            nowCalories.text = "\(self.getCalorieBurnedData()) kcal"

        }
    }
    lazy var locations = [CLLocation]()
    lazy var totalLocations = [CLLocation]()

    
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.activityType = .Fitness
        _locationManager.distanceFilter = 0.1
        return _locationManager
    }()
    
    // check location authorization
    
    private func checkLocationAuthority(status: CLAuthorizationStatus) {
        switch status {
        case .NotDetermined: locationManager.requestWhenInUseAuthorization()
        case .Denied: locationManager.requestWhenInUseAuthorization()
        case .Restricted: print("This area can't update locations")
        case .AuthorizedAlways, .AuthorizedWhenInUse: break
        }
    }

    
    // set start & pause & continue animation
    
    lazy var timer = NSTimer()
    var currentAnimation = RideButtonFunction.Start
    var time: NSTimeInterval = 0.00
        { didSet { nowTime.text = RideInfoHelper.shared.getTimeFormat(time) as String } }
    var startTime = NSDate.timeIntervalSinceReferenceDate()
    var pausedTime: NSTimeInterval = 0.00
    var continuedTime: NSTimeInterval = 0.00
    var totalPausedTime: NSTimeInterval = 0.00
    
    // current speed & calorie
    let calorieCalculator = CalorieCalculator()
    var currentSpeed: Double = 0.0
    var calorie: Double = 0.0
}

// MARK: - StartButton

extension NewRecordViewController {
    
    @IBAction private func rideButtonPressed(sender: UIButton) {
        switch currentAnimation {
    
        case .Start:
            UIView.animateWithDuration(0.6, animations: {
                self.rideButton.transform = CGAffineTransformMakeScale(0.5, 0.5)
                self.rideButton.layer.cornerRadius = 4
            })
            self.currentAnimation = .Pause
    
            // timer start
            self.startTime = NSDate.timeIntervalSinceReferenceDate()
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01,
                target: self,
                selector: #selector(NewRecordViewController.eachMillisecond(_:)),
                userInfo: nil,
                repeats: true)
            
            // location update
            distance = 0.0
            locations.removeAll()
            startLocationUpdates()

        case .Pause:
            UIView.animateWithDuration(0.6, animations: {
                self.rideButton.transform = CGAffineTransformMakeScale(1, 1)
                self.rideButton.layer.cornerRadius = self.rideButton.frame.width / 2
            })
            currentAnimation = .Continue
            
            // timer pause
            timer.invalidate()
            pausedTime = NSDate.timeIntervalSinceReferenceDate()
            
            // location update pause
            locationManager.stopUpdatingLocation()
            currentDistance += self.distance
            for location in locations {
                totalLocations.append(location)
            }
            
            // add fixed polyline
            self.totalLoadMap()
            
            // current speed
            self.nowSpeed.text = "0 km / h"
            
        case .Continue:
            UIView.animateWithDuration(0.6, animations: {
                self.rideButton.transform = CGAffineTransformMakeScale(0.5, 0.5)
                self.rideButton.layer.cornerRadius = 4
            })
            self.currentAnimation = .Pause
            
            // timer continue
            self.continuedTime = NSDate.timeIntervalSinceReferenceDate()
            self.totalPausedTime += self.continuedTime - self.pausedTime
         
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01,
                target: self,
                selector: #selector(NewRecordViewController.eachMillisecond(_:)),
                userInfo: nil,
                repeats: true)
            
            // distance continue
            distance = 0.0
            startLocationUpdates()
        }
    }
}

// MARK: - EachMillisecond

extension NewRecordViewController {
    
    @objc private func eachMillisecond(timer: NSTimer) {
        
        time = NSDate.timeIntervalSinceReferenceDate() - startTime - totalPausedTime
        totalDistance = currentDistance + distance

        if let locationSpeed = locations.last { self.currentSpeed = locationSpeed.speed * 3.6 }
        else { self.currentSpeed = 0.0 }

    }
    
    
    // calorie
    
    private func getCalorieBurnedData() -> String {
        
        let exercise = CalorieCalculator.Exercise.Bike
        let speed = self.totalDistance / self.time * 3.6
        let weight = Double(defaults.stringForKey(NSUserDefaultKey.Weight)!)!
        let time = self.time / 3600
        let calorieBurned = self.calorieCalculator.kcalBurned(exercise, speed: speed, weight: weight, time: time)
        self.calorie = calorieBurned
        let _calorieBurned = NSString(format:"%.1f", calorieBurned)
        return _calorieBurned as String
    }
}


// MARK: - CLLocationManagerl

extension NewRecordViewController: CLLocationManagerDelegate {
    
    private func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) { checkLocationAuthority(status) }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // get distance & locations
                
        for location in locations {
            if location.horizontalAccuracy < 20 {
                if self.locations.count > 0 {
                    if location.distanceFromLocation(self.locations.last!) > 10 {
                        distance = 0.0
                        self.locations.removeAll()
                    } else {
                        distance += location.distanceFromLocation(self.locations.last!)
                    }
                }
                self.locations.append(location)
            }
        }
        
        self.showUserLocation()
        self.loadMap()
    }
    
    // show current location on the map
    private func showUserLocation() {
        let currentLocation = self.locations.last
        let center = CLLocationCoordinate2D(latitude: (currentLocation?.coordinate.latitude)!, longitude: (currentLocation?.coordinate.longitude)!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpanMake(0.001, 0.001))
        self.mapView.setRegion(region, animated: true)
    }
    
    // poly line
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = UIColor.mrBubblegumColor()
        renderer.lineWidth = 10
        return renderer
        }
    
    // temperate polyline
    
    private func polyLine() -> MKPolyline {
        var coords =  [CLLocationCoordinate2D]()
        for locaion in self.locations {
            coords.append(CLLocationCoordinate2D(latitude: locaion.coordinate.latitude, longitude: locaion.coordinate.longitude))
        }
        return MKPolyline(coordinates: &coords, count: self.locations.count)
    }
    
    private func loadMap() {
        if self.locations.count > 0 {
            mapView.removeOverlays(self.mapView.overlaysInLevel(.AboveRoads))
            mapView.insertOverlay(polyLine(), atIndex: 1, level: .AboveRoads)
        }
    }
    
     // total polyline
    
    private func totalPolyLine() -> MKPolyline {
        
        var coords =  [CLLocationCoordinate2D]()
        for locaion in self.totalLocations {
            coords.append(CLLocationCoordinate2D(latitude: locaion.coordinate.latitude, longitude: locaion.coordinate.longitude))
        }
        return MKPolyline(coordinates: &coords, count: self.totalLocations.count)
    }
    
    private func totalLoadMap() {
        if self.totalLocations.count > 0 {
            self.mapView.removeOverlays(self.mapView.overlays)
            mapView.addOverlay(totalPolyLine())
        }
    }
    
    func mapView(mapView: MKMapView, didFailToLocateUserWithError error: NSError) {
        print("didFailToLocateUserWithError: \(error.localizedDescription)")
    }
    
}

// MARK: - MKMapViewDelegate
extension NewRecordViewController: MKMapViewDelegate {
    
}


// MARK: - SetUp

extension NewRecordViewController {
    
   override func viewDidLayoutSubviews() {
        gradient.removeFromSuperlayer()
        let color1 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.60)
        let color2 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.40)
        gradient.frame = self.view.frame
        gradient.colors = [color1.CGColor, color2.CGColor]
        self.view.layer.insertSublayer(gradient, atIndex: 0)
        
    }
    
    private func setBackground() {
        
        self.view.backgroundColor = UIColor.mrLightblueColor()
        let color1 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.60)
        let color2 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.40)
        gradient.frame = self.view.frame
        gradient.colors = [color1.CGColor, color2.CGColor]
        self.view.layer.insertSublayer(gradient, atIndex: 0)
        
    }
    
    private func setLabels() {
        
        distanceLabel.font = UIFont.mrTextStyle12Font()
        distanceLabel.textColor = UIColor.whiteColor()
        distanceLabel.shadowColor = UIColor.mrBlack20Color()
        distanceLabel.text = "Distance"
        
        averageSpeed.font = UIFont.mrTextStyle12Font()
        averageSpeed.textColor = UIColor.whiteColor()
        averageSpeed.shadowColor = UIColor.mrBlack20Color()
        averageSpeed.text = "Current Speed"
        
        calories.font = UIFont.mrTextStyle12Font()
        calories.textColor = UIColor.whiteColor()
        calories.shadowColor = UIColor.mrBlack20Color()
        calories.text = "Calories"
        
        nowDistance.font = UIFont.mrTextStyle9Font()
        nowDistance.textColor = UIColor.whiteColor()
        nowDistance.shadowColor = UIColor.mrBlack15Color()
        nowDistance.text = "0 m"
        
        nowSpeed.font = UIFont.mrTextStyle9Font()
        nowSpeed.textColor = UIColor.whiteColor()
        nowSpeed.shadowColor = UIColor.mrBlack15Color()
        nowSpeed.text = "0 km / h"
        
        nowCalories.font = UIFont.mrTextStyle9Font()
        nowCalories.textColor = UIColor.whiteColor()
        nowCalories.shadowColor = UIColor.mrBlack15Color()
        nowCalories.text = "0.0 kcal"
        
        nowTime.font = UIFont(name: "RobotoMono-Regular", size: 30)
        nowTime.textColor = UIColor.mrWhiteColor().colorWithAlphaComponent(0.8)
        nowTime.text = "00:00:00.00"
        
        // navigation left button
        let leftItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target:self, action: #selector(self.cancel))
        self.navigationItem.leftBarButtonItem = leftItem
        
        // navigation right button
        let rightItem = UIBarButtonItem(title: "Finish", style: UIBarButtonItemStyle.Done, target: self, action: #selector(self.finish))
        self.navigationItem.rightBarButtonItem = rightItem

        
        // navigation title
        self.navigationItem.title = RideInfoHelper.shared.todayDate
    }
    
    private func setButton() {
        self.buttonBorder.layer.borderColor = UIColor.whiteColor().CGColor
        self.buttonBorder.backgroundColor = UIColor.clearColor()
        self.buttonBorder.layer.borderWidth = 4
        self.buttonBorder.layer.shadowColor = UIColor.mrBlack20Color().CGColor
        self.buttonBorder.layer.cornerRadius = self.buttonBorder.frame.size.width / 2
        self.rideButton.layer.cornerRadius = self.rideButton.frame.width / 2
    }
    
    // set mapView
    
    private func setMapView() {
        self.mapView.layer.cornerRadius = 10
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
    }
    
}


// MARK: - Navigation Item

extension NewRecordViewController {
    
    
    @objc func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc func finish() {
        
        // check data
        if totalDistance == 0.0 {
            // todo: alert
            print("no data")
            return
        }
        
        locationManager.stopUpdatingLocation()
        
        // get averagespeed
        getAverageSpeed()
        
        // save data to coredata & (update  history page and chart)
        saveThisRide()
        
        // trans data to statistic page
        pushToStatisticPage()
    }

}


// button function change enum

enum RideButtonFunction {
    case Start
    case Pause
    case Continue
}

// MARK: - MethodsForFinish


extension NewRecordViewController {
    private func saveThisRide() {
        let rideInfo = RideInfo.init(
                        ID: NSUUID.init().UUIDString,
                        Date: NSDate(),
                        SpendTime: self.time,
                        Distance: self.totalDistance,
                        AverageSpeed: self.currentSpeed ,
                        Calorie: self.calorie,
                        Routes: self.totalLocations)
        
        NewRecordViewController.rideInfo = rideInfo
        
        // todo: 存入code data
       
        
    }
    
    private func getAverageSpeed() {
        self.currentSpeed = self.totalDistance / self.time * 3.6
    }
    
    
    private func pushToStatisticPage() {
        let statictisViewController = self.storyboard?.instantiateViewControllerWithIdentifier("StatictisViewController") as! StatictisViewController
        self.navigationController?.pushViewController(statictisViewController, animated: true)
        
        
    }
    
    
}


