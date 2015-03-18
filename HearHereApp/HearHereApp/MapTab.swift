//
//  MapTab.swift
//  HearHereApp
//
//  Created by Luyuan Xing on 3/4/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

//
//  ViewController.swift
//  MapPractice
//
//  Created by Luyuan Xing on 3/16/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapTab: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var map = MKMapView()
    var arrayOfMapItems = [MKPointAnnotation]()
    let locationManager = CLLocationManager()
    
    //***** DUMMY DATA TO BE REPLACED
    var userLocation = CLLocationCoordinate2DMake(40.74106,-73.989699)
    var mapItemTitle = "What Happens If You Have A Really Long Title That Just Goes On Forever"
    var mapItemSubTitle = "8:00 PM"
    var testButton = UIButton()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        map.frame = self.view.frame
        self.view.addSubview(map)
        
        //**** REQUEST USER LOCATION
        self.locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        
        //**** TEST BUTTON
        testButton.frame = CGRect(x: 10, y: 0, width: 10, height: 10)
        testButton.backgroundColor = UIColor.blueColor()
        
        
        let annotation1 = MKPointAnnotation()
        annotation1.coordinate = self.userLocation
        annotation1.title = mapItemTitle
        annotation1.subtitle = mapItemSubTitle
        
        let pt = MKMapPointForCoordinate(annotation1.coordinate)
        let w = MKMapPointsPerMeterAtLatitude(annotation1.coordinate.latitude) * 1200
        self.map.visibleMapRect = MKMapRectMake(pt.x - w/2.0, pt.y - w/2.0, w, w)
        self.map.addAnnotation(annotation1)
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var currentLocation: CLLocationCoordinate2D = manager.location.coordinate
        println("coordinates are: \(currentLocation.latitude), \(currentLocation.longitude)")
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        var v : MKAnnotationView! = nil
        if annotation.title == mapItemTitle {
            let ident = "droppedPin"
            v = mapView.dequeueReusableAnnotationViewWithIdentifier(ident)
            if v == nil {
                v = MKPinAnnotationView(annotation:annotation, reuseIdentifier:ident)
                v.canShowCallout = true
                
                let button: UIButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton
                
                button.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                v.rightCalloutAccessoryView = button
            }
            v.annotation = annotation
        }
        return v
    }
    
    func buttonClicked(sender: UIButton!) {
        showViewController(EventDetailViewController(), sender: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}