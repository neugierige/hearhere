//
//  VenueDetailViewController.swift
//  HearHereApp
//
//  Created by Luyuan Xing on 4/17/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit
import MapKit

class VenueDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {
    
    let table = UITableView()
    let edvc = EventDetailViewController()
    var event: Event!
    var mapItemTitle = String()
    var mapItemSubTitle = String()
    let dateConverter = DateConverter()
    var arrayOfAnnotations: [AnyObject] = [] {
        didSet{
            self.map.removeAnnotations(self.map.annotations)
        }
    }
    
    let textView = UITextView()
    let map = MKMapView()
    let nycCenter = CLLocationCoordinate2DMake(40.7770082, -73.9624465)

    var margin: CGFloat = 10.0
    
    override func viewWillAppear(animated: Bool) {
        addAnnotations()
    }
    
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = Configuration.lightGreyUIColor
        
        if let navBarHeight = navigationController?.navigationBar.frame.height {
            //textView.frame = CGRect(x: margin/2, y: navBarHeight/2, width: view.frame.width-2*margin, height: view.frame.height)
            table.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }
        tabBarController?.tabBar.hidden = true
        hidesBottomBarWhenPushed = true
        
        table.delegate = self
        table.dataSource = self
        table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.separatorStyle = UITableViewCellSeparatorStyle.None
        view.addSubview(table)
        
        textViewSetup()
        mapSetup()
    }
    
    func textViewSetup() {
        textView.editable = false
        textView.text = "About this venue..."
        textView.frame = CGRect(x: margin, y: margin, width: table.frame.width-(margin*2), height: 40)
    }
    
    func mapSetup () {
        let mapCoordinateSpan: MKCoordinateSpan = MKCoordinateSpanMake(0.001, 0.001)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(nycCenter, mapCoordinateSpan)
        self.map.regionThatFits(region)
        map.frame = CGRect(x: margin, y: textView.frame.maxY, width: table.frame.width-(margin*2), height: 250)
    }
    
    
    func convertAddressToCoordiantes (searchTerm: String, completion: CLLocationCoordinate2D -> Void) {
        var location = CLLocation()
        
        var searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchTerm
        var search = MKLocalSearch(request: searchRequest)
        
        search.startWithCompletionHandler { (response, error) -> Void in
            if let mapItem = response.mapItems.first as? MKMapItem {
                location = mapItem.placemark.location
                completion(location.coordinate)
            }
        }
    }
    
    func addAnnotations() {
        var name = event.venue[0].name
        var address = event.venue[0].address
        var searchTerm = "\(name), \(address)"
        mapItemTitle = event.title as String
        var subTitle1 = self.dateConverter.formatTime(event.dateTime)
        var subTitle2 = event.venue[0].name
        mapItemSubTitle = subTitle1 + " " + subTitle2
        
        var anno: MapAnnotation = MapAnnotation()
        anno.event = event
        convertAddressToCoordiantes(searchTerm) { location in
            anno.coordinate = location
            self.map.showAnnotations(self.arrayOfAnnotations, animated: true)
        }
        anno.title = mapItemTitle
        anno.subtitle = mapItemSubTitle
        
        arrayOfAnnotations.append(anno)
        
        self.map.addAnnotation(anno)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation.title == "Current Location" {
            return nil
        }
        
        var v : MKAnnotationView! = nil
        let ident = "droppedPin"
        if v == nil {
            v = MKPinAnnotationView(annotation:annotation, reuseIdentifier:ident)
            v.canShowCallout = true
        }
        v.annotation = annotation
        return v
    }
    
    
    //TABLE DATA SOURCE
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.layer.borderWidth = 0.0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 11.0)
        cell.textLabel?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200)
        cell.addSubview(textView)
        cell.contentView.addSubview(map)
//        cell.addSubview(map)
        return cell
    }
    
    
    
    //DELEGATE
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = Configuration.lightBlueUIColor
        header.textLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        header.textLabel.text = "Venue Information"
    }
    
}
