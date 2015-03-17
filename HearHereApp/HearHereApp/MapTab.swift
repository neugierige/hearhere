//
//  MapTab.swift
//  HearHereApp
//
//  Created by Luyuan Xing on 3/4/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit
import MapKit

class MapTab: UIViewController, MKMapViewDelegate {
    var mapView: MKMapView!
    var mapContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapContainerView = UIView(frame: CGRectZero)
        mapContainerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(mapContainerView)

        
        mapView = MKMapView(frame: CGRect(origin: mapContainerView.frame.origin, size: mapContainerView.frame.size))
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        mapContainerView.addSubview(mapView)

        var varBindDict = NSMutableDictionary()
        varBindDict.setValue(mapContainerView, forKey: "mapContainerView")
        varBindDict.setValue(mapView, forKey: "mapView")
        
        view.addConstraints([
            NSLayoutConstraint.constraintsWithVisualFormat("|[mapView]|", options: .allZeros, metrics: nil, views: varBindDict),
            NSLayoutConstraint.constraintsWithVisualFormat("V:|[mapView]|", options: .allZeros, metrics: nil, views: varBindDict)
        ])
        
        mapView.addConstraints([
            NSLayoutConstraint.constraintsWithVisualFormat("|[mapContainerView]|", options: .allZeros, metrics: nil, views: varBindDict),
            NSLayoutConstraint.constraintsWithVisualFormat("V:|[mapContainerView]|", options: .allZeros, metrics: nil, views: varBindDict)
        ])
        
        // This was my first try, same error
//        view.addConstraints([
//            NSLayoutConstraint.constraintsWithVisualFormat("|[mapContainerView]|", options: .allZeros, metrics: nil, views: varBindDict),
//            NSLayoutConstraint.constraintsWithVisualFormat("V:|[mapContainerView]|", options: .allZeros, metrics: nil, views: varBindDict)
//        ])
        
        let location = CLLocationCoordinate2D(
            latitude: 51.50007773,
            longitude: -0.1246402
        )
        // 2
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        //3
        let annotation = MKPointAnnotation()
        annotation.setCoordinate(location)
        annotation.title = "Big Ben"
        annotation.subtitle = "London"
        mapView.addAnnotation(annotation)
    }

}
