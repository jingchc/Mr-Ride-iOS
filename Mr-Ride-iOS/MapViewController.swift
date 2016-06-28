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
    
    // info view
    
    private enum AnnotattionStatus {
        case Restroom
        case Youbike
    }
    private var annotaionStatus: AnnotattionStatus = .Restroom
    
    // picker View
    
    private var showPickerView = false
    var pickers = ["Toilet", "YouBike Stations"]
    @IBOutlet weak var lookForlabel: UILabel!
    @IBOutlet weak var rectView: UIImageView!
    @IBOutlet weak var pickerButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBAction func pickerButton(sender: UIButton) {
        
        if showPickerView {
            pickerView.hidden = true
        } else {
            pickerView.hidden = false
        }
        
    }

    // data
    
    private var restrooms: [RestroomModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        loadData()
        setMapView()
    }
}

extension MapViewController {
    
    private func setUp() {
        
        self.view.backgroundColor = UIColor.mrLightblueColor()
        
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
        
        // labels
        // todo: corner radius
        
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

    private func loadData() {
        
        // restroom
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
            
            DataManager.shared.getRestrooms(
                success: { result in
                    
                    self.restrooms = result
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        for restroom in self.restrooms {
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = restroom.coordinate
                            annotation.title = restroom.name
                            
                            self.map.addAnnotation(annotation)
                            
                        }
                    }
                },
                failure: { result in
                    print("no~~")
                    
                }
            )

            
        }
        
        
        // youbike
        
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
    
    // annotation
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if (annotation is MKUserLocation) { return nil }
        
        let reuseID = "Restroom"
        var restroom = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
        
        if restroom != nil {
            restroom?.annotation = annotation
            restroom?.canShowCallout = true

        } else {
            restroom = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            restroom?.canShowCallout = true

        }
        
        restroom?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        restroom?.backgroundColor = UIColor.whiteColor()
        restroom?.layer.cornerRadius = 20
        let imageView = UIImageView(image: UIImage(named: "icon-toilet" ))
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        imageView.center = (restroom?.center)!
        
        restroom?.addSubview(imageView)

        return restroom
        
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
        pickerView.hidden = true
        showPickerView = false
    }
    
}


