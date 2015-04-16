//
//  Venue.swift
//  HearHereApp
//
//  Created by Matthew Korporaal on 3/8/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import Foundation
import Parse

class Venue: Model, Printable {
    var name: String!
    var detail: String?
    var address: String!
    var phone: String!
    var url: String!
    
    required init(id: String) {
        super.init(id: id)
        name = ""
        address = "New York, NY 10013"
        phone = ""
        url = ""
    }
    
    convenience required init(object: PFObject) {
        self.init(id: object.objectId)
        if let n = object["name"]    as? String { name = n }
        if let a = object["address"] as? String { address = a }
        if let p = object["phone"]   as? String { phone = p }
        if let u = object["url"]     as? String { url = u }
        
    }
    
    convenience init?(json: NSDictionary) {
        self.init(id: json["objectId"] as String!)
        if let n = json["name"]     as? String { name = n }
        if let a = json["address"]  as? String { address = a }
        if let p = json["phone"]    as? String { phone = p }
        if let u = json["url"]      as? String { url = u }
    }

    var description: String {
        return "\(name)"
    }
}