//
//  Configuration.swift
//  HearHereApp
//
//  Created by Matthew Korporaal on 3/5/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit
import Parse

struct Configuration {
    
    static var backgroundUIColor = UIColor(red:149.0/255.0, green:165.0/255.0, blue:166.0/255.0, alpha:1.0)
    static var buttonUIColor = UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0)
    static var tagFontUIColor = UIColor(red: 108/255, green: 122/255, blue: 137/255, alpha: 1.0)
    static var tagUIColorA = UIColor(red: 190/255, green: 144/255, blue: 212/255, alpha: 1.0)
    static var tagUIColorB = UIColor(red: 137/255, green: 196/255, blue: 244/255, alpha: 1.0)
    static var tagUIColorC = UIColor(red: 244/255, green: 179/255, blue: 80/255, alpha: 1.0)
    static var userSession: PFUser!
    static var applicationID = "mTDskuO4PaaHfOKdqA2uvPyx8HqozJx8OUT9a3cL"
    static var clientKey = "j4fFLe93tqZ2A5ye14MxlWh7Ovnh0L6QP6WmP2Yg"
}