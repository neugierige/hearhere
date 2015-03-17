//
//  Event.swift
//  HearHereApp
//
//  Created by Prima Prasertrat on 3/13/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import Foundation

class Event {
    let eventID: String
    let name: String
    let dateTime: NSDate
    let venue:String
    let image: String
    
    init(eventID: String, name: String, dateTime: NSDate, venue: String, image: String) {
        self.eventID = eventID
        self.name = name
        self.dateTime = dateTime
        self.venue = venue
        self.image = image
    }
}