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
    let locationManager = CLLocationManager()
    
    //***** DUMMY DATA TO BE REPLACED
    var center = CLLocationCoordinate2DMake(40.7543065, -73.9733295)
    
    var mapItemTitle = "What Happens If You Have A Really Long Title That Just Goes On Forever"
    var mapItemSubTitle = "8:00 PM General Assembly"
    
    var arrayOfCoordinates = [CLLocationCoordinate2D]()
    var parseObjects: [[String: AnyObject]] = [
        [
            "name": "Miller Theater",
            "subtitle": "Tonight at 9PM",
            "coordinate": CLLocation(latitude: 40.808078, longitude: -73.963373)
        ],
        [
            "name": "Trinity Church",
            "subtitle": "Tonight at 9PM",
            "coordinate": CLLocation(latitude: 40.708062, longitude: -74.012185)
        ],
        [
            "name": "Carnegie Hall",
            "subtitle": "Tonight at 9PM",
            "coordinate": CLLocation(latitude: 40.765126, longitude: -73.979924)
        ],
        [
            "name": "BAM",
            "subtitle": "Tonight at 9PM",
            "coordinate": CLLocation(latitude: 40.686456, longitude: -73.977676)
        ],
        [
            "name": "SubCulture",
            "subtitle": "Tonight at 9PM",
            "coordinate": CLLocation(latitude: 40.725863, longitude: -73.994291)
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        map.frame = self.view.frame
        self.view.addSubview(map)
        
        
        //**** REQUEST USER LOCATION
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        //*****
        
        map.showsUserLocation = true
        
        
        for parseObject in parseObjects {
            var location = parseObject["coordinate"] as CLLocation  //CLLocationCoordinate2DMake(40.808078, -73.963373) // TODO: REPLACE WITH PARSE DATA
            var title = parseObject["name"] as String  //"some title here"   // TODO: REPLACE WITH PARSE DATA
            var subTitle = parseObject["subtitle"] as String  //"some subtitle here"     // TODO: REPLACE WITH PARSE DATA
            
            
            var anno: MKPointAnnotation = MKPointAnnotation()
            anno.coordinate = location.coordinate
            anno.title = title
            anno.subtitle = subTitle
            
            self.map.addAnnotation(anno)
        }
        
        let point = MKMapPointForCoordinate(center)
        let width = MKMapPointsPerMeterAtLatitude(center.latitude) * 7000
        self.map.visibleMapRect = MKMapRectMake(point.x - width/2.0, point.y - width/2.0, width, width)
        
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
    
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientation.Portrait.rawValue
    }
    
    
}