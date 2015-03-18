//
//  Event.swift
//  HearHereApp
//
//  Created by Matthew Korporaal on 3/9/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import Foundation
import Parse

class Event: Model {
    lazy var venue = [Venue]()
    lazy var artists = [Artist]()
    lazy var categories = [Category]()
    
    var title: String!
    var dateTime: NSDate!
    var program: String!
    var photoURL: String!
    var ticketURL: String!
    var ticketMethod: String!
    var priceMin: Double!
    var priceMax: Double!
    
    required init(id: String) {
        super.init(id: id)
    }
    
    convenience required init(object: PFObject) {
        self.init(id: object["objectId"]  as String!)
        if let n = object["title"]        as? String { title = n }
        if let a = object["dateTime"]     as? NSDate { dateTime = a }
        if let p = object["program"]      as? String { program = p }
        if let u = object["ticketURL"]   as? String { ticketURL = u }
        if let u = object["ticketMethod"] as? String { ticketMethod = u }
        if let u = object["priceMin"]     as? Double { priceMin = u }
        if let u = object["priceMax"]     as? Double { priceMax = u }
        
        if let v = object.objectForKey("venue") as? PFObject {
            venue.append(Venue(object: v as PFObject))
        }
        if let a = object.objectForKey("artists") as? [AnyObject] {
            a.map { self.artists.append(Artist(object: $0 as PFObject)) }
        }
        if let c = object.objectForKey("categories") as? [AnyObject] {
            c.map { self.categories.append(Category(object: $0 as PFObject)) }
        }
    }
    
    convenience init?(json: NSDictionary) {
        self.init(id: json["objectId"]  as String!)
        if let n = json["title"]        as? String { title = n }
        if let a = json["dateTime"] as? NSDictionary {
            if let date = a["iso"] as? String {
                var formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"
                formatter.timeZone = NSTimeZone.systemTimeZone()
                formatter.locale = NSLocale.currentLocale()
                formatter.formatterBehavior = NSDateFormatterBehavior.BehaviorDefault
                formatter.dateStyle = .MediumStyle
                formatter.timeStyle = .ShortStyle
                if let nsdate = formatter.dateFromString(date) {
                    println(nsdate)
                }
            }
        }
        if let p = json["program"]      as? String { program = p }
        if let u = json["ticketURL"]   as? String { ticketURL = u }
        if let u = json["ticketMethod"] as? String { ticketMethod = u }
        if let u = json["priceMin"]     as? Double { priceMin = u }
        if let u = json["priceMax"]     as? Double { priceMax = u }
        
//        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            if let v = json["venue"] as? NSArray {
                println(v)
                var id = v[0].objectForKey("objectId") as String
                //            var q = PFQuery(className: "Venue").whereKey(<#key: String!#>, containsString: <#String!#>)
                var query = PFQuery(className: "Venue")
                query.whereKey("objectId", equalTo: id)
                var objects = query.findObjects() //InBackgroundWithBlock { objects, error in
                if let o = objects as? [PFObject] {
                    var ven = Venue(object: o[0] as PFObject)
                    self.venue.append(ven)
                }
            }
            
            if let a = json["artists"] as? NSArray {
                var ids = [String]()
                for i in a {
                    ids.append(i.objectForKey("objectId") as String)
                }
                var query = PFQuery(className: "Artist").whereKey("objectId", containedIn: ids)
                var objects = query.findObjects() //InBackgroundWithBlock { objects, error in
                if let o = objects as? [PFObject] {
                    for artist in o {
                        var ven = Artist(object: artist as PFObject)
                        self.artists.append(ven)
                    }
                }
            }
            if let a = json["categories"] as? NSArray {
                var ids = [String]()
                for i in a {
                    ids.append(i.objectForKey("objectId") as String)
                }
                var query = PFQuery(className: "Category").whereKey("objectId", containedIn: ids)
                var objects = query.findObjects() ///InBackgroundWithBlock { objects, error in
                if let o = objects as? [PFObject] {
                    for category in o {
                        var ven = Category(object: category as PFObject)
                        self.categories.append(ven)
                    }
                }
            }
        //}
        
    }
    
}