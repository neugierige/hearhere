//
//  Artist.swift
//  HearHereApp
//
//  Created by Matthew Korporaal on 3/8/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import Foundation
import Parse

class Artist: Model {//: Printable {
    var name: String!
    var url: String?
    var email: String?
    var detail: String?
    
    required init(id: String) {
        super.init(id: id)
    }
    
    convenience init(name: String) {
        self.init(id: "")
        self.name = name
    }
    
    convenience required init(object: PFObject) {
        //self.init(id: "")
        self.init(name: object.objectId ?? "")
//        if let objId = object.objectId {
//            self.init(id: objId)
            if let n = object["name"] as? String { name = n }
            if let n = object["url"] as? String { name = n }
            if let n = object["email"] as? String { name = n }
            if let n = object["detail"] as? String { name = n }
//        }
    }

    // may not need
    convenience init?(json: NSDictionary) {
        
        self.init(id: json["objectId"] as! String!)
        if let n = json["name"] as? String { name = n }
    }
    
}