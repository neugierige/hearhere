//
//  DataManager.swift
//  HearHereApp
//
//  Created by Matthew Korporaal on 3/5/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit
import Parse

class DataManager {
    
    class func getObjectsInBackground(className: String, keys: [String], completion: ([PFObject]?, String?) -> Void) {
        var query = PFQuery(className: className)
        query.selectKeys(keys)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) in
            if error == nil {
                completion(objects as? [PFObject], nil)
            } else {
                completion(nil, "Error")
            }
        }
    }
    
}
