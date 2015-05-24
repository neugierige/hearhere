//
//  User.swift
//  HearHereApp
//
//  Created by Matthew Korporaal on 3/7/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import Foundation
import Parse
import MapKit
class User: Model, Printable {
    var username: String!
    var email: String!
    var password: String!
    var location: CLLocation = CLLocation(latitude: 40.7356  , longitude: -73.9906)
    
    lazy var categories = [Category]()
    lazy var artists = [Artist]()
    lazy var venues = [Venue]()
    lazy var events = [Event]()
    lazy var users = [User]()
    
    required init(id: String) {
        super.init(id: id)
    }
    
    convenience init(username: String, password: String) {
        self.init(id: "")
        self.username = username
        self.password = password
    }
    
    convenience init(username: String, email: String, password: String) {
        self.init(id: "")
        self.username = username
        self.email = email
        self.password = password
    }
    
    convenience init(json: NSDictionary) {
        self.init(id: json["objectId"] as! String!)
        if let u = json["username"] as? String { username = u }
        if let e = json["email"] as? String { email = e }
        // add location
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
        
        if let categoryArray = json["categories"] as? NSArray {
            if let objects = DataManager.makeArrayOfObjects(categoryArray) {
                if let c = objects as? [Category] {
                    self.categories = c
                }
            }
        }
        if let artistArray = json["artists"] as? NSArray {
            if let objects = DataManager.makeArrayOfObjects(artistArray) {
                if let a = objects as? [Artist] {
                    self.artists = a
                }
            }
        }
        if let venueArray = json["venues"] as? NSArray {
            if let objects = DataManager.makeArrayOfObjects(venueArray) {
                if let v = objects as? [Venue] {
                    self.venues = v
                }
            }
        }
        if let eventArray = json["events"] as? NSArray {
            if let objects = DataManager.makeArrayOfObjects(eventArray) {
                if let e = objects as? [Event] {
                    self.events = e
                }
            }
        }
        if let userArray = json["users"] as? NSArray {
            if let objects = DataManager.makeArrayOfObjects(userArray) {
                if let u = objects as? [User] {
                    self.users = u
                }
            }
        }
        }

//        if let categoryArray = json["categories"] as? NSArray {
//            DataManager.makeArrayOfObjects(categoryArray) { objects in
//                if let c = objects as? [Category] {
//                    self.categories = c
//                }
//            }
//        }
//        if let artistArray = json["artists"] as? NSArray {
//            DataManager.makeArrayOfObjects(artistArray) { objects in
//                if let a = objects as? [Artist] {
//                    self.artists = a
//                }
//            }
//        }
//        if let venueArray = json["venues"] as? NSArray {
//            DataManager.makeArrayOfObjects(venueArray) { objects in
//                if let v = objects as? [Venue] {
//                    self.venues = v
//                }
//            }
//        }
//        if let eventArray = json["events"] as? NSArray {
//            DataManager.makeArrayOfObjects(eventArray) { objects in
//                if let e = objects as? [Event] {
//                    self.events = e
//                }
//            }
//        }
//        if let userArray = json["users"] as? NSArray {
//            DataManager.makeArrayOfObjects(userArray) { objects in
//                if let u = objects as? [User] {
//                    self.users = u
//                }
//            }
//        }
    }
    
    convenience required init(object: PFObject) {
        self.init(id: object.objectId as String!)
        username = object["username"] as! String
        email = object["email"] as! String
        location = object["location"] as! CLLocation
        let backgroundQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
        dispatch_async(backgroundQueue) {

        if let a = object.objectForKey("artists") as? [AnyObject] {
//            DataManager.retrieveArtistsForUser(a) {
            let ids = a.map { ($0 as! PFObject).objectId }
            var query = PFQuery(className: "Artist").whereKey("objectId", containedIn: ids)
            //var query = PFQuery(className: "Artist").whereKey("objectId", containedIn: ids)
            self.artists = (query.findObjects() as [PFObject]).map { (Artist(object: $0 as PFObject)) }
        }
        if let c = object.objectForKey("categories") as? [AnyObject] {
            let ids = c.map { ($0 as! PFObject).objectId }
            var query = PFQuery(className: "Category").whereKey("objectId", containedIn: ids)
            self.categories = (query.findObjects() as [PFObject]).map { (Category(object: $0 as PFObject)) }
        }
        if let v = object.objectForKey("venues") as? [AnyObject] {
            let ids = v.map { ($0 as! PFObject).objectId }
            var query = PFQuery(className: "Venue").whereKey("objectId", containedIn: ids)
            self.venues = (query.findObjects() as [PFObject]).map { (Venue(object: $0 as PFObject)) }
        }
        if let e = object.objectForKey("events") as? [AnyObject] {
            let ids = e.map { ($0 as! PFObject).objectId }
            var query = PFQuery(className: "Category").whereKey("objectId", containedIn: ids)
            self.events = (query.findObjects() as [PFObject]).map { (Event(object: $0 as PFObject)) }
        }
        if let u = object.objectForKey("users") as? [AnyObject] {
            let ids = u.map { ($0 as! PFObject).objectId }
            var query = PFQuery(className: "User").whereKey("objectId", containedIn: ids)
            self.users = (query.findObjects() as [PFObject]).map { (User(object: $0 as PFObject)) }
        }
        }
    }
    convenience init(currentUser: PFUser) {
        self.init(id: currentUser.objectId!)
        username = currentUser.username
        email = currentUser.email
        password = currentUser.password
    }
    
    var description: String {
        return "\(username) \(email)"
    }
    
    func debugQuickLookObject() -> AnyObject? {
        return "\(username)\nemail:\(email)\nobjectId:\(objectId)"
    }
    
}