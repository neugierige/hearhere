//
//  Model.swift
//  HearHereApp
//
//  Created by Matthew Korporaal on 3/16/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import Foundation
import Parse

class Model {

    var objectId: String!
    
    required init(id: String) {
        objectId = id
    }
    
    convenience required init(object: PFObject) {
        self.init(id: object.objectId!)
    }
}