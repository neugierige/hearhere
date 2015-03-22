//
//  Cache.swift
//  HearHereApp
//
//  Created by Matthew Korporaal on 3/21/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import Foundation

class Cache {

    private struct Data {
//        static var eventCache: Caches<Event> = Caches(name: "Event")
        
        static var events: [Event] = [Event]() {
            willSet {
//                newValue.map { Data.eventCache.setObject($0, forKey: $0.objectId) }
//                cache
            }
        }
        static var currentUser = User(id: "")
        static var venues = [Venue]()
        static var artists = [Artist]()
        static var categories = [Category]()
    }
    class var events: [Event] {
        get { return Data.events }
        set { Data.events = newValue }
    }
    class var currentUser: User {
        get { return Data.currentUser }
        set { Data.currentUser = newValue }
    }
    class var venues: [Venue] {
        get { return Data.venues }
        set { Data.venues = newValue }
    }
    class var artists: [Artist] {
        get { return Data.artists }
        set { Data.artists = newValue }
    }
    class var categories: [Category] {
        get { return Data.categories }
        set { Data.categories = newValue }
    }
}