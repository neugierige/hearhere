//
//  MapTab.swift
//  HearHereApp
//
//  Created by Luyuan Xing on 3/4/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapTab: UIViewController, MKMapViewDelegate, ScrollCalendarDelegate {
    
    var map = MKMapView()
    
    var collectionView: UICollectionView?
    let rowHeight: CGFloat = 60.0
    let tableY: CGFloat = 125.5
    let calUnit: CGFloat = 67.5
    
    var collectionDataSource: CalendarCollectionDataSource?
    
    //***** PARSE DATA
    var eventsArray = [Event]()
    var mapItemTitle = String()
    var mapItemSubTitle = String()
    var arrayOfCoordinates = [CLLocationCoordinate2D]()
    var arrayOfAnnotations: [MKPointAnnotation] = [] {
        didSet{
            self.map.removeAnnotations(self.map.annotations)
        }
    }
    var dt = NSDate()
    
    override func viewWillAppear(animated: Bool) {
        map.showsUserLocation = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        map.showsUserLocation = true
        
        var navBarHeight = navigationController?.navigationBar.frame.maxY ?? self.view.frame.minY
        var tabBarHeight = tabBarController?.tabBar.bounds.size.height ?? self.view.frame.maxY
        
        var flowLayout:UICollectionViewFlowLayout = StickyHeaderFlowLayout()
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.itemSize = CGSize(width: calUnit, height: calUnit)
        flowLayout.scrollDirection = .Horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.headerReferenceSize = CGSize(width: calUnit, height: calUnit)
        
        collectionView = UICollectionView(frame: CGRectMake(0, navBarHeight+2, self.view.frame.width, calUnit), collectionViewLayout: flowLayout)
        collectionView?.backgroundColor = Configuration.medBlueUIColor
        self.view.addSubview(collectionView!)
        
        map.frame = CGRect(x: 0, y: navBarHeight+calUnit+3, width: self.view.frame.width, height: self.view.frame.height-tabBarHeight)
        //-navBarHeight!) --> turns TAB BAR into a weird grey gradient color...
        self.view.addSubview(map)
        
        self.collectionDataSource = CalendarCollectionDataSource(numDays: 180, cellIdentifier: "calendarCollectionCell", cellBlock: { (cell, item) -> () in
            if let actualCell = cell as? CalendarCollectionViewCell {
                if let actualItem: AnyObject = item {
                    actualCell.configureCellData(actualItem)
                }
            }
        })
        
        // delegate to pass collectionview data back to tableview
        self.collectionDataSource?.delegate = self
        
        if let theCollectionView = collectionView {
            theCollectionView.registerClass(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: "calendarCollectionCell")
            theCollectionView.registerClass(CalendarHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "calendarCollectionHeader")
            
            theCollectionView.backgroundColor = Configuration.darkBlueUIColor
            theCollectionView.dataSource = self.collectionDataSource
            theCollectionView.delegate = self.collectionDataSource
            view.addSubview(theCollectionView)
        }
//        if eventsArray.isEmpty {
//            DataManager.retrieveAllEvents { events in
//                self.eventsArray = events
//                self.addAnnotations()
//            }
//        } else {
//            self.addAnnotations()
//        }
    }
    
    func updateList(dt: NSDate) {
        
        arrayOfAnnotations.removeAll(keepCapacity: false)
        eventsArray.removeAll(keepCapacity: false)
        
        DataManager.retrieveEventsForDate(dt) { events in
        println("date tapped: \(dt)")
            for event in events {
                var dateConverter = DateConverter()
                var dtConverted = dateConverter.formatDate(dt, type: "short")
                if dateConverter.formatDate(event.dateTime, type: "short") == dtConverted {
                    self.eventsArray.append(event)
                    self.addAnnotations()
                }
            }
            println("eventsArray: \(self.eventsArray)")
        }
    }
    
    func addAnnotations() {
        for event in eventsArray {
            var address = event.venue[0].address
            mapItemTitle = event.title as String
            var subTitle1 = formatDateTime(event.dateTime, type: "time")
            var subTitle2 = event.venue[0].name
            mapItemSubTitle = subTitle1 + " " + subTitle2
            
            var anno: MapAnnotation = MapAnnotation()
            anno.event = event
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

//    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//        DataManager.saveUserLocation(locations[0] as CLLocation)
//    }
    
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        var v : MKAnnotationView! = nil
            let ident = "droppedPin"
            v = mapView.dequeueReusableAnnotationViewWithIdentifier(ident)
            if v == nil {
                v = MKPinAnnotationView(annotation:annotation, reuseIdentifier:ident)
//                var gestureRecognizer = UITapGestureRecognizer(target: self, action: "calloutTapped:")
//                v.addGestureRecognizer(gestureRecognizer)
                v.canShowCallout = true
                
                if let button = MapButton.buttonWithType(UIButtonType.DetailDisclosure) as? MapButton {
                    button.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                    if let a = annotation as? MapAnnotation {
                        button.event = a.event
                    }
                    v.rightCalloutAccessoryView = button
                }
            }
            v.annotation = annotation
        return v
    }
    
    func buttonClicked(sender: MapButton) {
        if let event = sender.event {
            var edvc = EventDetailViewController()
            edvc.event = event
            navigationController?.showViewController(edvc, sender: event)
        }
    }
    
//    func calloutTapped(sender: UITapGestureRecognizer) {
//        if let view = sender.view as? MKAnnotationView {
//            if let annotation = view.annotation as? MapAnnotation {
//                let event = annotation.event
//                println(event?.title)
//            }
//        }
//    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientation.Portrait.rawValue
    }
    
}