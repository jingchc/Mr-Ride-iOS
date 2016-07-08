//
//  StatictisViewController.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/6/12.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import UIKit
import MapKit

class StatictisViewController: UIViewController {
    
    // items
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var totalDistance: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var averageSpeed: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var calories: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var totalTime: UILabel!
    @IBOutlet weak var goodJob: UILabel!
    
    var fromController: String? = NewRecordViewController.newRecordPage ?? HistoryViewController.historyPage
    
   private var rideInfo: RideInfo? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fromWichController()
       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setUp()
        loadMap()
    }
    
    deinit {
        fromController = nil
        NewRecordViewController.newRecordPage = nil
        HistoryViewController.historyPage = nil
        mapView = nil
        print("StatictisViewController deinit")
    }
}

extension StatictisViewController {
   
    // left item
    private func setCloseItem() {
        let leftItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.close))
        self.navigationItem.leftBarButtonItem = leftItem
    }
    
    @objc func close() {
//        rideInfo = nil
        fromController = nil
//        NewRecordViewController.newRecordPage = nil
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // set up
    private func setUp() {
        
        // backgroung
        
        let gradient = CAGradientLayer()
        self.view.backgroundColor = UIColor.mrLightblueColor()
        let color1 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.60)
        let color2 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.40)
        gradient.frame = self.view.frame
        gradient.colors = [color1.CGColor, color2.CGColor]
        self.view.layer.insertSublayer(gradient, atIndex: 0)

        // labels
        
        distanceLabel.font = UIFont.mrTextStyle12Font()
        distanceLabel.textColor = UIColor.whiteColor()
        distanceLabel.shadowColor = UIColor.mrBlack20Color()
        distanceLabel.text = "Distance"
        
        speedLabel.font = UIFont.mrTextStyle12Font()
        speedLabel.textColor = UIColor.whiteColor()
        speedLabel.shadowColor = UIColor.mrBlack20Color()
        speedLabel.text = "Average Speed"
        
        caloriesLabel.font = UIFont.mrTextStyle12Font()
        caloriesLabel.textColor = UIColor.whiteColor()
        caloriesLabel.shadowColor = UIColor.mrBlack20Color()
        caloriesLabel.text = "Calories"
        
        timeLabel.font = UIFont.mrTextStyle12Font()
        timeLabel.textColor = UIColor.whiteColor()
        timeLabel.shadowColor = UIColor.mrBlack20Color()
        timeLabel.text = "Total Time"
        
        totalDistance.font = UIFont.mrTextStyle9Font()
        totalDistance.textColor = UIColor.whiteColor()
        totalDistance.shadowColor = UIColor.mrBlack15Color()
        
        averageSpeed.font = UIFont.mrTextStyle9Font()
        averageSpeed.textColor = UIColor.whiteColor()
        averageSpeed.shadowColor = UIColor.mrBlack15Color()
        
        calories.font = UIFont.mrTextStyle9Font()
        calories.textColor = UIColor.whiteColor()
        calories.shadowColor = UIColor.mrBlack15Color()
        
        totalTime.font = UIFont.mrTextStyle9Font()
        totalTime.textColor = UIColor.whiteColor()
        totalTime.shadowColor = UIColor.mrBlack15Color()
        
        goodJob.font = UIFont.textStyle20Font()
        goodJob.textColor = UIColor.whiteColor()
        goodJob.shadowColor = UIColor.mrBlack20Color()
        goodJob.text = "Good Job"
        
        if let _rideInfo = rideInfo {
            totalTime.text = RideInfoHelper.shared.getTimeFormat(_rideInfo.SpendTime) as String
            totalDistance.text = RideInfoHelper.shared.getDistanceFormat(_rideInfo.Distance)
            averageSpeed.text =  RideInfoHelper.shared.getSpeedFormat(_rideInfo.AverageSpeed)
            
            var calorie: String {
                let _calorie = NSString(format: "%.1f",_rideInfo.Calorie)
                return _calorie as String
            }
            calories.text = "\(calorie) kcal"
        }
        
        // mapView
        
        mapView.layer.cornerRadius = 10
        mapView.delegate = self
    }
    
    private func fromWichController() {
        
        if let _fromController = fromController {
        
            switch _fromController {
            
            case "HistoryPage":
                var routes: [LocationWithNumber] = []
                let ride = HistoryViewController.ride
                let routeEntity = ride!.route
                
                for item in routeEntity! {
                    let route =  item as! Route
                    let location = LocationWithNumber(location: CLLocation(latitude:route.latitude as! CLLocationDegrees,longitude: route.longitude  as! CLLocationDegrees) , number: route.number as! Int)
                    routes.append(location)
                }

                rideInfo = RideInfo(
                    ID: (ride?.id!)!,
                    Date: (ride?.date)!,
                    SpendTime: NSTimeInterval((ride?.time!)!),
                    Distance: Double((ride?.distance)!),
                    AverageSpeed:  Double((ride?.averageSpeed)!),
                    Calorie:  Double((ride?.calorie)!),
                    Routes: routes)
                
                var navigationDate: String {
                    let date = NSDateFormatter()
                    date.dateFormat = "yyyy / MM / dd"
                    
                    return date.stringFromDate((ride?.date)!)
                }

                self.navigationItem.title = navigationDate
                
                print("from HistoryPage")
                
            case "NewRecordPage":
                rideInfo = NewRecordViewController.rideInfo
                setCloseItem()
                self.navigationItem.title = RideInfoHelper.shared.todayDate

                print("from NewRecordPage")
                
            
            default:
                print("I don't where I came from")
                break
            }
        }
    }
}


// map

extension StatictisViewController: MKMapViewDelegate {
    
    // polyline
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = UIColor.mrBubblegumColor()
        renderer.lineWidth = 10
        
        return renderer
    }
    
    private func polyline() -> MKPolyline {
        
        var coords = [CLLocationCoordinate2D]()
        guard let locations = rideInfo?.Routes else {
            print("no Route data")
            return MKPolyline(coordinates: &coords, count: coords.count)
        }
        
        for locationWithNumber in locations {
            let location = locationWithNumber.location
            coords.append(CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
        }
        return MKPolyline(coordinates: &coords, count: locations.count)
    }
    
    private func loadMap() {
        if rideInfo?.Routes.count > 0 {
            mapView.addOverlay(polyline())
        }
        mapView.region = showRouteRegion()
    }
    
    // show route region
    
    private func showRouteRegion() -> MKCoordinateRegion{
        
        let startLocation = rideInfo!.Routes.first!.location
        
        var minLatitude = startLocation.coordinate.latitude
        var minLongitude = startLocation.coordinate.longitude
        var maxLatitude = minLatitude
        var maxLongitude = minLongitude
        
        let locations = rideInfo!.Routes
        
        for locationWithNumber in locations {
            let location = locationWithNumber.location
            minLatitude = min(minLatitude, location.coordinate.latitude)
            minLongitude = min(minLongitude, location.coordinate.longitude)
            maxLatitude = max(maxLatitude, location.coordinate.latitude)
            maxLongitude = max(maxLongitude, location.coordinate.longitude)
        }
        
        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: (maxLatitude + minLatitude) / 2,
                longitude: (maxLongitude + minLongitude) / 2 ),
            span: MKCoordinateSpan(
                latitudeDelta: (maxLatitude - minLatitude) * 1.5 ,
                longitudeDelta: (maxLongitude - minLongitude) * 1.5))
    }
}