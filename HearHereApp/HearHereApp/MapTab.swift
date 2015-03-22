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
    
    var map: MKMapView!
    let locationManager = CLLocationManager()
    
    //***** PARSE DATA
    var eventsArray = [Event]()
    var mapItemTitle = String()
    var mapItemSubTitle = String()
    var arrayOfCoordinates = [CLLocationCoordinate2D]()
    var arrayOfAnnotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map = MKMapView()
        map.delegate = self
        map.frame = self.view.frame
        self.view.addSubview(map)
        
        
        //**** REQUEST USER LOCATION
        //self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        //*****
        
        map.showsUserLocation = true
        
        if eventsArray.isEmpty {
            DataManager.retrieveAllEvents { events in
                self.eventsArray = events
                println("there are \(self.eventsArray.count) events in the array")
                self.addAnnotations()
            }
        } else {
            self.addAnnotations()
        }
    }
    
    func addAnnotations() {
        for event in eventsArray {
            println("in the for loop now")
            var address = event.venue[0].address
            println(address)
            mapItemTitle = event.title as String
            var subTitle1 = formatDateTime(event.dateTime, type: "time")
            var subTitle2 = event.venue[0].name
            mapItemSubTitle = subTitle1 + " " + subTitle2
            
            var anno: MKPointAnnotation = MKPointAnnotation()
            convertAddressToCoordiantes(address) { location in
                anno.coordinate = location
                self.map.showAnnotations(self.arrayOfAnnotations, animated: true)
            }
            anno.title = mapItemTitle
            anno.subtitle = mapItemSubTitle
            
            arrayOfAnnotations.append(anno)
            self.map.addAnnotation(anno)
        }
    }
    
    func convertAddressToCoordiantes (address: String, completion: CLLocationCoordinate2D -> Void) {
        var location = CLLocation()
        
        var searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = address
        var search = MKLocalSearch(request: searchRequest)
        
        search.startWithCompletionHandler { (response, error) -> Void in
            if let mapItem = response.mapItems.first as? MKMapItem {
                location = mapItem.placemark.location
                completion(location.coordinate)
            }
        }
    }
    

    func formatDateTime(dt: NSDate, type: String) -> String {
        let dateFormatter = NSDateFormatter()
        
        switch type {
        case "date":
            dateFormatter.dateStyle = .FullStyle
            dateFormatter.timeStyle = .NoStyle
        case "time":
            dateFormatter.dateStyle = .NoStyle
            dateFormatter.timeStyle = .ShortStyle
        default:
            dateFormatter.dateStyle = .ShortStyle
            dateFormatter.timeStyle = .ShortStyle
        }
        
        let dtString = dateFormatter.stringFromDate(dt)
        return dtString
    }

    
    
//    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
//        var v : MKAnnotationView! = nil
//        if annotation.title == mapItemTitle {
//            let ident = "droppedPin"
//            v = mapView.dequeueReusableAnnotationViewWithIdentifier(ident)
//            if v == nil {
//                v = MKPinAnnotationView(annotation:annotation, reuseIdentifier:ident)
//                v.canShowCallout = true
//                
//                let button: UIButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton
//                
//                button.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
//                v.rightCalloutAccessoryView = button
//            }
//            v.annotation = annotation
//        }
//        return v
//    }
    
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