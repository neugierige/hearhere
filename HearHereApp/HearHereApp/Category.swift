//
//  Category.swift
//  HearHereApp
//
//  Created by Matthew Korporaal on 3/8/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import Foundation
import Parse

class Category: Model {
    var name: String!
    
    required init(id: String) {
        super.init(id: id)
        name = ""
    }

    convenience required init(object: PFObject) {
        self.init(id: object.objectId!)
        if let n = object["name"] as? String { name = n }
    }

    convenience init?(json: NSDictionary) {
        self.init(id: json["objectId"] as! String!)
        if let n = json["name"]     as? String { name = n }
    }

}