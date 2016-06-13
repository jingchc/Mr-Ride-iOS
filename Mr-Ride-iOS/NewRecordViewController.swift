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
    
    
    deinit {
        print("NewRecordViewController deinit")
    }
    
    // locationManager
    
    var distance = 0.0
    lazy var currentDistance = 0.0
    lazy var totalDistance = 0.0
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
            self.currentAnimation = .Continue
            
            // timer pause
            timer.invalidate()
            self.pausedTime = NSDate.timeIntervalSinceReferenceDate()
            
            // location update pause
            self.locationManager.stopUpdatingLocation()
            self.currentDistance += self.distance
            for location in self.locations {
                self.totalLocations.append(location)
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
        
        self.time = NSDate.timeIntervalSinceReferenceDate() - self.startTime - self.totalPausedTime        
        self.nowTime.text = String(getTimeFormat(self.time))
        
        self.nowDistance.text = getDistanceFormat(self.distance)
        
        var currentSpeed: String? {
            if locations.last != nil {
                self.currentSpeed = (self.locations.last?.speed)! * 3.6
                return "\(String(Int(self.currentSpeed))) km / h"
            } else {
                self.currentSpeed = 0.0
                return "0 km / h"
            }
        }
        self.nowSpeed.text = currentSpeed
    }
    
    // time format
    
    private func getTimeFormat(trackDuration: NSTimeInterval) -> NSString {
        let time = NSInteger(trackDuration)
        let milliseconds = Int((trackDuration % 1) * 100)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = time / 3600
        
        return NSString(format: "%0.2d:%0.2d:%0.2d.%0.2d", hours, minutes,seconds,milliseconds)
    }
    
    // distance format
    
    private func getDistanceFormat(distance:Double) -> String {
        self.totalDistance = self.currentDistance + distance
        return "\(Int(self.totalDistance)) m"
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
        self.nowCalories.text = "\(self.getCalorieBurnedData()) kcal"
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
        
        self.distanceLabel.font = UIFont.mrTextStyle12Font()
        self.distanceLabel.textColor = UIColor.whiteColor()
        self.distanceLabel.shadowColor = UIColor.mrBlack20Color()
        self.distanceLabel.text = "Distance"
        
        self.averageSpeed.font = UIFont.mrTextStyle12Font()
        self.averageSpeed.textColor = UIColor.whiteColor()
        self.averageSpeed.shadowColor = UIColor.mrBlack20Color()
        self.averageSpeed.text = "Current Speed"
        
        self.calories.font = UIFont.mrTextStyle12Font()
        self.calories.textColor = UIColor.whiteColor()
        self.calories.shadowColor = UIColor.mrBlack20Color()
        self.calories.text = "Calories"
        
        self.nowDistance.font = UIFont.mrTextStyle9Font()
        self.nowDistance.textColor = UIColor.whiteColor()
        self.nowDistance.shadowColor = UIColor.mrBlack15Color()
        self.nowDistance.text = "0 m"
        
        self.nowSpeed.font = UIFont.mrTextStyle9Font()
        self.nowSpeed.textColor = UIColor.whiteColor()
        self.nowSpeed.shadowColor = UIColor.mrBlack15Color()
        self.nowSpeed.text = "0 km / h"
        
        self.nowCalories.font = UIFont.mrTextStyle9Font()
        self.nowCalories.textColor = UIColor.whiteColor()
        self.nowCalories.shadowColor = UIColor.mrBlack15Color()
        self.nowCalories.text = "0.0 kcal"
        
        self.nowTime.font = UIFont(name: "RobotoMono-Regular", size: 30)
        self.nowTime.textColor = UIColor.mrWhiteColor().colorWithAlphaComponent(0.8)
        self.nowTime.text = "00:00:00.00"
        
        // navigation left button
        let leftItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target:self, action: #selector(self.cancel))
        self.navigationItem.leftBarButtonItem = leftItem
        
        // navigation right button
        let rightItem = UIBarButtonItem(title: "Finish", style: UIBarButtonItemStyle.Done, target: self, action: #selector(self.finish))
        self.navigationItem.rightBarButtonItem = rightItem

        
        // navigation title
        let getTodayDate = NSDateFormatter()
        getTodayDate.dateFormat = "yyyy / MM / dd"
        var todayDate: NSDate {
            get{
                return getTodayDate.dateFromString(self.navigationItem.title!)!
            }
            set {
                self.navigationItem.title = getTodayDate.stringFromDate(newValue)
            }
        }
        todayDate = NSDate()
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
    
    
    struct RideInfo {
        let ID: String
        let Date: NSDate
        let SpendTime: NSTimeInterval
        let Distance: Double
        let AverageSeppd: Double
        let Calorie: Double
        let Routes: [CLLocation]
    }
    
    private func saveThisRide() {
        
        let rideInfo = RideInfo.init(
                        ID: NSUUID.init().UUIDString,
                        Date: NSDate(),
                        SpendTime: self.time,
                        Distance: self.totalDistance,
                        AverageSeppd: self.currentSpeed ,
                        Calorie: self.calorie,
                        Routes: self.totalLocations)
        
        print(rideInfo.ID)
        print(rideInfo.Date)
        print(rideInfo.SpendTime)
        print(rideInfo.Distance)
        print(rideInfo.AverageSeppd)
        print(rideInfo.Calorie)
        print(rideInfo.Routes)
        
    }
    
    // ????
    private func getAverageSpeed() {
        self.currentSpeed = self.totalDistance / self.time * 3.6
    }
    
    
    
    
    
    private func pushToStatisticPage() {
        let statictisViewController = self.storyboard?.instantiateViewControllerWithIdentifier("StatictisViewController") as! StatictisViewController
        self.navigationController?.pushViewController(statictisViewController, animated: true)
        
        
    }
    
    
}


