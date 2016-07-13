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
import CoreData

class NewRecordViewController: UIViewController {
    
    // rideInfo
    static var rideInfo: RideInfo? = nil
    static var newRecordPage: String? = nil
    
    // coreData
    private let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    // location Manager
    private var locationManager = CLLocationManager()
    private lazy var locations = [LocationWithNumber]()
    private lazy var totalLocations = [LocationWithNumber]()
    private lazy var totalLocationsForPolyLine = [[LocationWithNumber]]()
    private lazy var locationNumber = 0
    
    // Status
    private var currentStatus = RideButtonFunction.Default
    private var nextStatus = RideButtonFunction.Start
    
    // distance
    private var distance = 0.0
    private var currentDistance = 0.0
    private var totalDistance = 0.0
        { didSet {
            nowDistance.text = RideInfoHelper.shared.getDistanceFormat(totalDistance)
            nowSpeed.text = RideInfoHelper.shared.getSpeedFormat(currentSpeed)
            nowCalories.text = "\(self.getCalorieBurnedData()) kcal"
        }
    }
    
    // timer
    private lazy var timer = NSTimer()
    private var time: NSTimeInterval = 0.00
        { didSet { nowTime.text = RideInfoHelper.shared.getTimeFormat(time) as String } }
    private var startTime = NSDate.timeIntervalSinceReferenceDate()
    private var pausedTime: NSTimeInterval = 0.00
    private var continuedTime: NSTimeInterval = 0.00
    private var totalPausedTime: NSTimeInterval = 0.00
    
    // current speed
    private var currentSpeed: Double = 0.0
    
    // calorie
    private let calorieCalculator = CalorieCalculator()
    private var calorie: Double = 0.0

    // items
    @IBOutlet weak var mapView: MKMapView! { didSet {
        locationManager.startUpdatingLocation()}
    }
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var nowDistance: UILabel!
    @IBOutlet weak var averageSpeed: UILabel!
    @IBOutlet weak var nowSpeed: UILabel!
    @IBOutlet weak var calories: UILabel!
    @IBOutlet weak var nowCalories: UILabel!
    @IBOutlet weak var nowTime: UILabel!
    @IBOutlet weak var buttonBorder: UIView!
    @IBOutlet weak var rideButton: UIButton!
    private let gradient = CAGradientLayer()
    private let defaults = NSUserDefaults.standardUserDefaults()
    private let alert = AlertHelper()
    
    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        setLabels()
        setButton()
        setMapView()
        setLocationManager()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
        timer.invalidate()
    }
    
    override func viewDidDisappear(animated: Bool) {
        locationManager.stopUpdatingLocation()
        mapView = nil
    }
    
    deinit {
        print("NewRecordViewController deinit")
    }
    
}

// MARK: - StartButton

extension NewRecordViewController {
    
    @IBAction private func rideButtonPressed(sender: UIButton) {
        switch nextStatus {
            
        case .Start:
    
            currentStatus = .Start
            nextStatus = .Pause
            
            // animation
            UIView.animateWithDuration(0.6, animations: {
                self.rideButton.transform = CGAffineTransformMakeScale(0.5, 0.5)
                self.rideButton.layer.cornerRadius = 4
            })
    
            // timer start
            startTime = NSDate.timeIntervalSinceReferenceDate()
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01,
                target: self,
                selector: #selector(NewRecordViewController.eachMillisecond(_:)),
                userInfo: nil,
                repeats: true)
            
            // location update
            distance = 0.0
            locations.removeAll()

        case .Pause:
            
            currentStatus = .Pause
            nextStatus = .Continue
            
            UIView.animateWithDuration(0.6, animations: {
                self.rideButton.transform = CGAffineTransformMakeScale(1, 1)
                self.rideButton.layer.cornerRadius = self.rideButton.frame.width / 2
            })
            
            // timer pause
            timer.invalidate()
            pausedTime = NSDate.timeIntervalSinceReferenceDate()
            
            // location update pause
            currentDistance += self.distance
            
            for location in locations {
                totalLocations.append(location)
            }
            totalLocationsForPolyLine.append(locations)
            drawTotalPolyLine(totalLocationsForPolyLine.last!)
            
            locations.removeAll()
            
            // current speed
            nowSpeed.text = "0 km / h"
            
        case .Continue:

            currentStatus = .Continue
            nextStatus = .Pause
            locationNumber += 1

            UIView.animateWithDuration(0.6, animations: {
                self.rideButton.transform = CGAffineTransformMakeScale(0.5, 0.5)
                self.rideButton.layer.cornerRadius = 4
            })
            
            // timer continue
            continuedTime = NSDate.timeIntervalSinceReferenceDate()
            totalPausedTime += continuedTime - pausedTime
         
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01,
                target: self,
                selector: #selector(NewRecordViewController.eachMillisecond(_:)),
                userInfo: nil,
                repeats: true)
            
            // distance continue
            distance = 0.0
            
        case .Default: break
            
        }
    }
}

// MARK: - EachMillisecond

extension NewRecordViewController {
    
    @objc private func eachMillisecond(timer: NSTimer) {
        
        time = NSDate.timeIntervalSinceReferenceDate() - startTime - totalPausedTime
        totalDistance = currentDistance + distance
        
        let location = locations.last?.location

        if let locationSpeed = location { currentSpeed = locationSpeed.speed * 3.6 }
        else { currentSpeed = 0.0 }

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


// MARK: - CLLocationManager

extension NewRecordViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) { checkLocationAuthority(status) }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // check currentStatus: locations distance?
        switch currentStatus {
        case .Default: break
        case .Start: record(locations)
        case .Pause: break
        case .Continue: record(locations)
        }
        
        // show user location
        showUserLocation(locations)
    }
    
    
    
    // check location authorization
    
    private func checkLocationAuthority(status: CLAuthorizationStatus) {
        switch status {
        case .NotDetermined: locationManager.requestWhenInUseAuthorization()
        case .Denied: locationManager.requestWhenInUseAuthorization()
        case .Restricted: print("This area can't update locations")
        case .AuthorizedAlways, .AuthorizedWhenInUse: break
        }
    }
    

    
    // record route
    
    private func record(locations: [CLLocation]) {
        for location in locations {
            if location.horizontalAccuracy < 20 {
                let locationWithNumber = LocationWithNumber(location: location, number: locationNumber)
                if self.locations.last != nil {
                    distance += location.distanceFromLocation((self.locations.last?.location)!)
                }
                self.locations.append(locationWithNumber)            }
        }
        drawCurrentPolyLine(self.locations)
    }
    
    
    
    // show current location on the map
    
    private func showUserLocation(locations: [CLLocation]) {
        let currentLocation = locations.last
        if currentLocation != nil {
        let center = CLLocationCoordinate2D(latitude: (currentLocation?.coordinate.latitude)!, longitude: (currentLocation?.coordinate.longitude)!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpanMake(0.001, 0.001))
            if self.mapView != nil {
            self.mapView.setRegion(region, animated: true)
            }
        }
    }
    
    
    
    // poly line
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = UIColor.mrBubblegumColor()
        renderer.lineWidth = 10
        return renderer
        }
    
    private func drawCurrentPolyLine(route: [LocationWithNumber]) {
        mapView.removeOverlays(mapView.overlaysInLevel(.AboveRoads))
        mapView.insertOverlay(polyLine(route), atIndex: 1, level: .AboveRoads)
    }
    
    
    private func drawTotalPolyLine(route: [LocationWithNumber]) {
        mapView.addOverlay(polyLine(route))
    }
    
    private func polyLine(route: [LocationWithNumber]) -> MKPolyline {
        var coords =  [CLLocationCoordinate2D]()
        for locationWithNumber in route {
            let location = locationWithNumber.location
            coords.append(CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
        }
        return MKPolyline(coordinates: &coords, count: coords.count)
    }
    
     func mapView(mapView: MKMapView, didFailToLocateUserWithError error: NSError) {
        print("didFailToLocateUserWithError: \(error.localizedDescription)")
    }
    
}


// MARK: - SetUp

extension NewRecordViewController {
    
   override func viewDidLayoutSubviews() {
        gradient.removeFromSuperlayer()
        let color1 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.60)
        let color2 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.40)
        gradient.frame = self.view.frame
        gradient.colors = [color1.CGColor, color2.CGColor]
        view.layer.insertSublayer(gradient, atIndex: 0)
        
    }
    
    private func setBackground() {
        
        view.backgroundColor = UIColor.mrLightblueColor()
        let color1 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.60)
        let color2 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.40)
        gradient.frame = self.view.frame
        gradient.colors = [color1.CGColor, color2.CGColor]
        view.layer.insertSublayer(gradient, atIndex: 0)
        
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
        navigationItem.leftBarButtonItem = leftItem
        
        // navigation right button
        let rightItem = UIBarButtonItem(title: "Finish", style: UIBarButtonItemStyle.Done, target: self, action: #selector(self.finish))
        navigationItem.rightBarButtonItem = rightItem

        // navigation title
        navigationItem.title = RideInfoHelper.shared.todayDate
    }
    
    private func setButton() {
        buttonBorder.layer.borderColor = UIColor.whiteColor().CGColor
        buttonBorder.backgroundColor = UIColor.clearColor()
        buttonBorder.layer.borderWidth = 4
        buttonBorder.layer.shadowColor = UIColor.mrBlack20Color().CGColor
        buttonBorder.layer.cornerRadius = self.buttonBorder.frame.size.width / 2
        rideButton.layer.cornerRadius = self.rideButton.frame.width / 2
    }
    
    // set mapView
    
    private func setMapView() {
        mapView.layer.cornerRadius = 10
        mapView.showsUserLocation = true
        mapView.delegate = self
    }
    
    private func setLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.activityType = .Fitness
        locationManager.distanceFilter = 0.1
    }
    
}


// MARK: - Navigation Item

extension NewRecordViewController {
    
    
    @objc func cancel() {
     alert.showCancelAlert(on: self)
    }
    
    @objc func finish() {
        
        locationManager.stopUpdatingLocation()
        
        if totalDistance == 0.0 {
            alert.showStartAlert(on: self)
            locationManager.startUpdatingLocation()
            return
        }

        getAverageSpeed()
        saveThisRideToSingleton()
        saveThisRideToCoreData()
        saveHomepageInfoToUserDefault()
        pushToStatisticPage()
        
        /* only use for develope testing
        cleanUpCoreData()
        checkCoreDate() */
    }

}


// button function change enum

enum RideButtonFunction {
    case Default
    case Start
    case Pause
    case Continue
}

// MARK: - MethodsForFinish


extension NewRecordViewController {
    
    private func saveThisRideToSingleton() {
        
        let rideInfo = RideInfo.init(
                        ID: NSUUID.init().UUIDString,
                        Date: NSDate.init(),
                        SpendTime: self.time,
                        Distance: self.totalDistance,
                        AverageSpeed: self.currentSpeed ,
                        Calorie: self.calorie,
                        Routes: self.totalLocations)
        
        NewRecordViewController.rideInfo = rideInfo
        NewRecordViewController.newRecordPage = "NewRecordPage"
        
    }
    
    private func getAverageSpeed() {
        self.currentSpeed = self.totalDistance / self.time * 3.6
    }
    
    
    private func pushToStatisticPage() {
        let statictisViewController = self.storyboard?.instantiateViewControllerWithIdentifier("StatictisViewController") as! StatictisViewController
        self.navigationController?.pushViewController(statictisViewController, animated: true)
    }
    
    private func saveThisRideToCoreData() {
        
        let ride = NSEntityDescription.insertNewObjectForEntityForName("Ride", inManagedObjectContext: self.moc) as! Ride
        
        let _rideInfo = NewRecordViewController.rideInfo
        
        if _rideInfo != nil {
            ride.id = _rideInfo?.ID
            ride.date = _rideInfo?.Date
            ride.distance = _rideInfo?.Distance
            ride.time = _rideInfo?.SpendTime
            ride.averageSpeed = _rideInfo?.AverageSpeed
            ride.calorie = _rideInfo?.Calorie
            }
        
        var routes = [Route]()
        
        for locationWithNumbers in (_rideInfo?.Routes)! {
            
            let location = locationWithNumbers.location
            
            let route = NSEntityDescription.insertNewObjectForEntityForName("Route", inManagedObjectContext: self.moc) as! Route
            
            route.id = _rideInfo?.ID
            route.latitude = location.coordinate.latitude
            route.longitude = location.coordinate.longitude
            route.timeStamp = location.timestamp
            route.speed = location.speed
            route.number = locationWithNumbers.number
            routes.append(route)
        }
        
        ride.route = NSOrderedSet(array: routes)
        
        do { try moc.save() } catch { fatalError(" core data error \(error)") }
        
    }
    
    private func saveHomepageInfoToUserDefault() {
        
        let request = NSFetchRequest(entityName: "Ride")
        var totalCounts = 0
        var totalDistance = 0.0
        var totalTime = 0.0
        var averageSpeed = 0.0
        
        do {
            let results = try moc.executeFetchRequest(request) as! [Ride]
            totalCounts = results.count
            
            for result in results {
                
                guard result.distance != nil else { return }
                totalDistance += Double(result.distance!)
                
                guard result.time != nil else { return }
                totalTime += Double(result.time!)
                
            }
        } catch {
            fatalError("fail to fetch core data")
        }
        
        averageSpeed = totalDistance / totalTime
        
        NSUserDefaults.standardUserDefaults().setInteger(totalCounts, forKey: NSUserDefaultKey.TotalCount)
        NSUserDefaults.standardUserDefaults().setDouble(totalDistance, forKey: NSUserDefaultKey.TotalDistance)
        NSUserDefaults.standardUserDefaults().setDouble(averageSpeed, forKey: NSUserDefaultKey.AverageSpeed)
        
    }
    
}



// Mark: - method for develope testing

extension NewRecordViewController {
    
    // help func - check data
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
                print(result.route?.firstObject!.number)
                print("=============")
            }
        } catch {
            fatalError("fail to fetch core data")
        }
    }
    
    // help func - delete data

    private func cleanUpCoreData() {
        
        let request = NSFetchRequest(entityName: "Ride")
        
        do {
            let results = try moc.executeFetchRequest(request) as! [Ride]
            
            for result in results {
                moc.deleteObject(result)
            }
        } catch {
            fatalError("clean up core data error")
        }
    }
}
