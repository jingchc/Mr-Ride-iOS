//
//  MapViewController.swift
//  Mr-Ride-iOS
//
//  Created by 莊晶涵 on 2016/6/17.
//  Copyright © 2016年 AppWorks School Jing. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController  {
    
    // map
    @IBOutlet weak var map: MKMapView!
    
    private var currentlocation: CLLocation?
    
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.activityType = .Fitness
        _locationManager.distanceFilter = 0.1
        return _locationManager
    }()
    
    // annotation status
    private enum AnnotattionStatus: String {
        case Restroom = "Toilet"
        case Youbike = "YBike Stations"
    }
    
    private var annotaionStatus: AnnotattionStatus = .Restroom {
        didSet {
            switch annotaionStatus {
            case .Restroom:
                map.removeAnnotations(map.annotations)
                restroomLoadData()
                
            case .Youbike:
                map.removeAnnotations(map.annotations)
                youbikeLoadData()
                
            }
        }
    }
    
    // info view

    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!  { didSet { timeLabel.reloadInputViews() }}
    
    // picker View
    
    var pickers = [AnnotattionStatus.Restroom.rawValue, AnnotattionStatus.Youbike.rawValue]
    
    @IBOutlet weak var pickerViewContainer: UIView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var lookForlabel: UILabel!
    @IBOutlet weak var rectView: UIImageView!
    @IBOutlet weak var pickerButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBAction func pickerButton(sender: UIButton) {
            pickerViewContainer.hidden = false
    }

    // data
    
    private var restrooms: [RestroomModel] = []
    private var youbikes: [YouBikeModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        restroomLoadData()
        setMapView()
    }
}

extension MapViewController {
    
    private func setUp() {
        
        self.view.backgroundColor = UIColor.mrLightblueColor()
        infoView.hidden = true
        pickerViewContainer.hidden = true
        
        // navigation transparent
        self.navigationItem.title = "Map"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
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
        
        // infoView
        // todo: corner radius
        infoView.backgroundColor = UIColor.mrDarkSlateBlueColor()
        typeLabel.textColor = UIColor.whiteColor()
        typeLabel.font = UIFont.textStyle26Font()
        typeLabel.layer.borderColor = UIColor.whiteColor().CGColor
        typeLabel.layer.borderWidth = 1
        
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.font = UIFont.textStyle27Font()
        
        streetLabel.textColor = UIColor.whiteColor()
        streetLabel.font = UIFont.textStyle20Font()
        
        timeLabel.textColor = UIColor.whiteColor()
        timeLabel.font = UIFont.mrTextStyle4Font()
        
        // todo: picker view labels corner radius, title
        pickerView.showsSelectionIndicator = true
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
//        toolBar.sizeToFit()
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(MapViewController.cancel))
        let middleText = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        middleText.title = "Look for"
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(self.done))
        
        toolBar.setItems([cancelButton, middleText, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
//        pickerView.addSubview(toolBar)
        
        
        // todo: rectangle color
        rectView.image = UIImage(named: "icon-arrow-down")
        
        pickerButton.backgroundColor = UIColor.whiteColor()
        pickerButton.setTitle("Toilet", forState: .Normal)
        pickerButton.titleLabel?.font = UIFont.textStyle24Font()
        pickerButton.setTitleColor(UIColor.mrDarkSlateBlueColor(), forState: .Normal)        
        
        lookForlabel.backgroundColor = UIColor.whiteColor()
        lookForlabel.textColor = UIColor.mrDarkSlateBlueColor()
        lookForlabel.font = UIFont.textStyle22Font()
        }
}

// MARK: - DATA


extension MapViewController {

    private func restroomLoadData() {
        
        // restroom
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
            
            DataManager.shared.getRestrooms(
                success: { result in
                    
                    self.restrooms = result
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        for restroom in self.restrooms {
                            let annotation = MrRidePointAnnotation()
                            annotation.coordinate = restroom.coordinate
                            annotation.title = restroom.name
                            annotation.type = " \(restroom.place) "
                            annotation.street = restroom.address
                            
                            self.map.addAnnotation(annotation)
                        }
                    }
                },
                failure: { result in
                    
                    // todo: error handling
                    print("no~~")
                    
                }
            )
            
        }
    }
    
    
    // youbike
    
    private func youbikeLoadData() {
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
            
            DataManager.shared.getYoubikes(
                success: { result in
                    
                    self.youbikes = result
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        for youbike in self.youbikes {
                            let annotation = MrRidePointAnnotation()
                            annotation.coordinate = youbike.stationLocation
                            annotation.title = youbike.stationName
                            annotation.type = " \(youbike.stationDistrict) "
                            annotation.street = youbike.stationAddress
                            
                            self.map.addAnnotation(annotation)
                            
                        }
                    }
                },
                failure: { result in
                    
                    // todo: error handling
                    print("no~~")
                    
                }
            )
        }
    }
}


//MARK: - CurrentLocation&Annotation

extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    // set mapView
    
    private func setMapView() {
        
        locationManager.startUpdatingLocation()
        
        map.layer.cornerRadius = 10
        map.showsUserLocation = true
        map.delegate = self
    
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentlocation = locations.last!
        showUserLocation()
    }
    
    private func showUserLocation() {
        let currentLocation = currentlocation
        let center = CLLocationCoordinate2D(latitude: (currentLocation!.coordinate.latitude), longitude: (currentLocation!.coordinate.longitude))
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpanMake(0.005, 0.005))
        map.setRegion(region, animated: true)
    }
    
    // annotation & infoView
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if (annotation is MKUserLocation) { return nil }
        
        let reuseID = "whiteCircle"
        var marker = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
        
        if marker != nil {
            marker?.annotation = annotation
            marker?.canShowCallout = true
            let subviews = marker?.subviews
            for subview in subviews! {
                subview.removeFromSuperview()
            }
        } else {
            marker = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            marker?.canShowCallout = true

        }
        
        marker?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        marker?.backgroundColor = UIColor.whiteColor()
        marker?.layer.cornerRadius = 20
        // todo: shadow, tintblue
//        marker?.layer.shadowColor = UIColor.black50Color().CGColor
//        marker?.layer.shadowOffset = CGSize(width: 0, height: 4)
    
        
        var icontype: String {
            if annotaionStatus == .Restroom { return "icon-toilet" }
            else { return "icon-station" }
        }
        let imageView = UIImageView(image: UIImage(named: icontype))
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        imageView.center = (marker?.center)!
        
        marker?.addSubview(imageView)

        return marker
        
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        if (view.annotation is MKUserLocation) { return }
            
        else if view.annotation is MrRidePointAnnotation {
            let annotaion = view.annotation as! MrRidePointAnnotation
            nameLabel.text = annotaion.title
            typeLabel.text = annotaion.type
            streetLabel.text = annotaion.street
            timeLabel.text = "Counting"
            view.backgroundColor = UIColor.mrLightblueColor()
            infoView.hidden = false
            getExpectedTravelTime(destination: annotaion.coordinate)
        }
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        if (view.annotation is MKUserLocation) {
            return
        } else {
            view.backgroundColor = UIColor.whiteColor()
            infoView.hidden = true
            pickerViewContainer.hidden = true
        }
    }
    
    // expected travel time
    private func getExpectedTravelTime(destination destination: CLLocationCoordinate2D) {
        
        let userLocation = MKMapItem(placemark: MKPlacemark(coordinate: self.currentlocation!.coordinate, addressDictionary: nil))
        let _destination = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
        let request = MKDirectionsRequest()
        request.source = userLocation
        request.destination = _destination
        request.transportType = MKDirectionsTransportType.Walking
        request.requestsAlternateRoutes = false
        
        let direction = MKDirections(request: request)
        direction.calculateDirectionsWithCompletionHandler{ response, error in
            if let route = response?.routes.first {
                let time = String(Int(route.expectedTravelTime / 60))
                self.timeLabel.text = "\(time) min"
            }
        }
    }
}

// MARK: - PickerView

extension MapViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // data source
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickers.count
    }
    
    // delegate
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickers[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerButton.setTitle(pickers[row], forState: .Normal)
        
        switch pickers[row] {
        case AnnotattionStatus.Restroom.rawValue: annotaionStatus = .Restroom
        case AnnotattionStatus.Youbike.rawValue: annotaionStatus = .Youbike
        default: print("Can't recognized picker button title")
        }
        pickerViewContainer.hidden = true
    }
    
    // toolBar item function
    
    func cancel() {
        pickerViewContainer.hidden = true
    }
    
    func done() {
        pickerViewContainer.hidden = true
    }
    
}


