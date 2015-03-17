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
    var venue: Venue!
    var artists: [Artist]!
    var categories: [Category]!
    
    var title: String!
    var dateTime: NSDate!
    var program: String!
    var photoURL: String!
    var ticketSite: String!
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
        if let u = object["ticketSite"]   as? String { ticketSite = u }
        if let u = object["ticketMethod"] as? String { ticketMethod = u }
        if let u = object["priceMin"]     as? Double { priceMin = u }
        if let u = object["priceMax"]     as? Double { priceMax = u }
        
        if let v = object.objectForKey("venue") as? PFObject {
            venue = Venue(object: v)
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
        if let a = json["dateTime"]     as? NSDate { dateTime = a }
        if let p = json["program"]      as? String { program = p }
        if let u = json["ticketSite"]   as? String { ticketSite = u }
        if let u = json["ticketMethod"] as? String { ticketMethod = u }
        if let u = json["priceMin"]     as? Double { priceMin = u }
        if let u = json["priceMax"]     as? Double { priceMax = u }
        
        if let v = json.objectForKey("venue") as? PFObject {
            venue = Venue(object: v)
        }
        if let a = json.objectForKey("artists") as? [AnyObject] {
            a.map { self.artists.append(Artist(object: $0 as PFObject)) }
        }
        if let c = json.objectForKey("categories") as? [AnyObject] {
            c.map { self.categories.append(Category(object: $0 as PFObject)) }
        }
        
    }
    
}