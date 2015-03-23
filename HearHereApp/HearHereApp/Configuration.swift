//
//  Configuration.swift
//  HearHereApp
//
//  Created by Matthew Korporaal on 3/5/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit
//import Parse

struct Configuration {
    
    static var lightGreyUIColor = UIColor(red: 0.937, green: 0.937, blue: 0.937, alpha: 1.0)
    static var lightBlueUIColor = UIColor(red: 0.741, green: 0.831, blue: 0.871, alpha: 1.0)
    static var medBlueUIColor   = UIColor(red: 0.247, green: 0.341, blue: 0.396, alpha: 1.0)
    static var darkBlueUIColor  = UIColor(red: 0.168, green: 0.227, blue: 0.258, alpha: 1.0)
    static var orangeUIColor    = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)

    static var tagFontUIColor = UIColor.whiteColor()
    static var tagUIColorA = darkBlueUIColor
    static var tagUIColorB = medBlueUIColor
    static var tagUIColorC = orangeUIColor
    
    static var meterToMile = 0.000621371
    // Parse
    static var parseApplicationID = "c2rCBsaTy87zy20OyLmNgWubtIsvUUlM6YdXkLv6"
    static var parseClientKey = "ng4iMK7tUlbwRczOfQ4lUgvsdOGq1LEVDismykTq"
    static var parseRestAPIKey = "pThQ4JIqBkkSRN1psPqPbLF5vjaaM3H9o8UiUBwy"
    
//    static var parseApplicationID = "mTDskuO4PaaHfOKdqA2uvPyx8HqozJx8OUT9a3cL"
//    static var parseClientKey = "j4fFLe93tqZ2A5ye14MxlWh7Ovnh0L6QP6WmP2Yg"
//    static var parseRestAPIKey = "vdWPeFzyDJSfRrTVyCjqbzminfhRsczeTPCyqPso"
    
    static let queue : NSOperationQueue = {
        let q = NSOperationQueue()
        // ... further configurations can go here ...
        return q
    }()

}

