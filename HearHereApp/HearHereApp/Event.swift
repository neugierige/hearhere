//
//  Event.swift
//  HearHereApp
//
//  Created by Matthew Korporaal on 3/9/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import Foundation
import Parse

class Event: Model, NSCoding {
    lazy var venue      = [Venue]()
    lazy var artists    = [Artist]()
    lazy var categories = [Category]()
    
    var title: String!
    var artistName: String!
    var artistDetail: String!
    var dateTime: NSDate!
    var program: String!
    var photoURL: String!
    var ticketURL: String!
    var ticketMethod: String!
    var priceMin: Double!
    var priceMax: Double!
    var photo: UIImage!
    var numAttendees: Int!
    var distance = 0.0
    var venueName: String?
    var venueAddress: String?
    var venueDetail: String?
    
    
    @objc required init(coder aDecoder: NSCoder) {
        println(aDecoder)
        super.init(id: "")
    }
    
    @objc func encodeWithCoder(aCoder: NSCoder) {
        
        println(aCoder)
    }
    required init(id: String) {
        super.init(id: id)
    }
    
    convenience required init(object: PFObject) {
        self.init(id: object["objectId"] as! String!)
        if let n = object["title"]          as? String { title = n }
        if let n = object["artistName"]     as? String { artistName = n }
        if let d = object["artistDetail"]   as? String { artistDetail = d }
        if let a = object["dateTime"]       as? NSDate { dateTime = a }
        if let p = object["program"]        as? String { program = p }
        if let u = object["ticketURL"]      as? String { ticketURL = u }
        if let u = object["ticketMethod"]   as? String { ticketMethod = u }
        if let u = object["minTicketPrice"] as? Double { priceMin = u }
        if let u = object["maxTicketPrice"] as? Double { priceMax = u }
        if let u = object["numAttendees"]   as? Int    { numAttendees = u }
        if let u = object["artistDetail"]   as? String { artistDetail = u }
        if let f = object["photo"] as? PFFile {
            f.getDataInBackgroundWithBlock({ (data, error) -> Void in
                var d = NSData(data: data!)
                if let image = UIImage(data: d) {
                    self.photo = image
                }
            })
        } 
        if let v = object.objectForKey("venue") as? PFObject {
            venue.append(Venue(object: v as PFObject))
        }
        if let a = object.objectForKey("artists") as? [AnyObject] {
            a.map { self.artists.append(Artist(object: $0 as! PFObject)) }
        }
        if let c = object.objectForKey("categories") as? [AnyObject] {
            c.map { self.categories.append(Category(object: $0 as! PFObject)) }
        }
    }
    
    convenience init?(json: NSDictionary) {
        self.init(id: json["objectId"] as! String!)
        if let n = json["title"] as? String { title = n }
        if let n = json["artistName"] as? String { artistName = n }
        if let d = json["artistDetail"] as? String { artistDetail = d }
        if let a = json["dateTime"] as? NSDictionary {
            if let date = a["iso"] as? String {
                var formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                formatter.timeZone = NSTimeZone(name: "EDT")
                if let nsdate = formatter.dateFromString(date) {
                    self.dateTime = nsdate
                }
            }
        }
        
//        if let a = json["dateTime"] as? String {
//            var formatter = NSDateFormatter()
//            formatter.dateFormat = "M/d/yy HH:mm"
//            if let nsdate = formatter.dateFromString(a) {
//                self.dateTime = nsdate
//            }
//        }
        
        if let p = json["program"]        as? String { program = p }
        if let u = json["ticketURL"]      as? String { ticketURL = u }
        if let u = json["ticketMethod"]   as? String { ticketMethod = u }
        if let u = json["minTicketPrice"] as? Double { priceMin = u }
        if let u = json["maxTicketPrice"] as? Double { priceMax = u }
        if let u = json["numAttendees"]   as? Int { numAttendees = u }
        if let u = json["artistDetail"] as? String { artistDetail = u }
        if let f = json["photo"]          as? NSDictionary {
            DataManager.downloadImageWithURL(f["url"] as! String) { success, image in
                if success { self.photo = image }
            }
        }
        if let v = json["venue"] as? NSArray {
            getVenue(v){ venue in
                self.venue.append(venue)
            }
        }
        if let a = json["artists"] as? NSArray {
            getArtists(a) { artists in
                self.artists = artists
            }
        }
        if let a = json["categories"] as? NSArray {
            getCategories(a) { categories in
                self.categories = categories
            }
        }
        
    }
    
    // TODO: THis is where the long running thread comes from.
    // It is not getting executed fast enough before home page starts
    func getVenue(venues: NSArray, completion: Venue -> Void) {
        if LocalCache.venues.count == 0 {
            
            var id = venues[0].objectForKey("objectId") as! String
            var query = PFQuery(className: "Venue")
            query.whereKey("objectId", equalTo: id)
            // TODO: fix. running on main thread
            //query.findObjectsInBackgroundWithBlock { objects, error in
            var objects = query.findObjects()
            if let o = objects as? [PFObject] {
                var ven = Venue(object: o[0] as PFObject)
                completion(ven)
            }
            //}
        } else {
            completion(LocalCache.venues.filter { $0.objectId == (venues[0].objectForKey("objectId") as! String) }[0])
        }
    }
    
    func getArtists(artists: NSArray, completion: [Artist] -> Void) {
        var ids = [String]()
        var artistArray = [Artist]()
        for i in artists {
            ids.append(i.objectForKey("objectId") as! String)
        }
        if LocalCache.artists.count == 0 {
//            println("event art")
            
            var query = PFQuery(className: "Artist").whereKey("objectId", containedIn: ids)
            query.findObjectsInBackgroundWithBlock { objects, error in
                if let o = objects as? [PFObject] {
                    for artist in o {
                        var ven = Artist(object: artist as PFObject)
                        artistArray.append(ven)
                    }
                    completion(artistArray)
                }
            }
        } else {
            completion(LocalCache.artists.filter { contains(ids, $0.objectId) })
        }
    }
    
    
    func getCategories(categories: NSArray, completion: [Category] -> Void) {
        var ids = [String]()
        var categoriesArray = [Category]()
        for i in categories {
            ids.append(i.objectForKey("objectId") as! String)
        }
        if LocalCache.categories.count == 0 {
//            println("event cat")
            var query = PFQuery(className: "Category").whereKey("objectId", containedIn: ids)
            query.findObjectsInBackgroundWithBlock { objects, error in
                if let o = objects as? [PFObject] {
                    for category in o {
                        var ven = Category(object: category as PFObject)
                        categoriesArray.append(ven)
                    }
                    completion(categoriesArray)
                }
            }
        } else {
            completion(LocalCache.categories.filter { contains(ids, $0.objectId) })
        }
    }
}