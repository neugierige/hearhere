//
//  Artist.swift
//  HearHereApp
//
//  Created by Matthew Korporaal on 3/8/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//
// test
import Foundation
import Parse

class Artist: Model {//: Printable {
    var name: String!

    required init(id: String) {
        super.init(id: id)
    }
    
    convenience init(name: String) {
        self.init(id: "")
        self.name = name
    }
    
    convenience required init(object: PFObject) {
        self.init(id: object.objectId)
        if let n = object["name"] as? String { name = n }
    }
    
    convenience init?(json: NSDictionary) {
        self.init(id: json["objectId"] as String!)
        if let n = json["name"] as? String { name = n }
    }
    
}