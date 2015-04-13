
//
//  DataManager.swift
//  HearHereApp
//
//  Created by Matthew Korporaal on 3/5/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit
import Parse
import Alamofire
import MapKit

var cache: Cache<NSData> = Shared.dataCache

class DataManager {
    init() {  }
}

// MARK: User data methods
extension DataManager {
    class func loadCriticalData(completion: () -> ()) {
        
        // Should probably separate these and have a completion for each, but it works for now
        func retrieveACV(completion: () -> ()) {
            retrieveAllArtists { artists in
                if let a = artists { LocalCache.artists = a }
            }
            retrieveAllCategories { categories in
                if let c = categories { LocalCache.categories = c }
            }
            retrieveAllVenues { venues in
                if let v = venues { LocalCache.venues = v }
                completion()
            }
            
        }
        
        retrieveACV {
            self.retrieveAllEvents() { events in
                LocalCache.events = events
                completion()
            }
        }
    }
    class func signUpUser(user: User, completion: String? -> Void) {
        //        encodeParam
        let userString = NSString(format: "%@", user.username)
        let passString = NSString(format: "%@", user.password)
        let userData: NSData = userString.dataUsingEncoding(NSUTF8StringEncoding)!
        let passData: NSData = passString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64UserString = userData.base64EncodedStringWithOptions(nil)
        let base64PassString = passData.base64EncodedStringWithOptions(nil)
        
        var parameters = ["username": user.username, "email": user.email, "password": user.password]
        
        let request: URLRequestConvertible = UserRouter.SignUpUser(parameters)
        Alamofire.request(request).responseJSON { request, response, data, error in
            var errorString: String!
            if let e = error {
                errorString = e.localizedDescription
            }
            if let data = data as? NSDictionary {
                if data["sessionToken"] != nil {
                    LocalCache.currentUser = user
                    UserRouter.sessionToken = data["sessionToken"] as? String
                    if let objectId = data["objectId"] as? String {
                        LocalCache.currentUser.objectId = objectId
                    }
                    let backgroundQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
                    dispatch_async(backgroundQueue) {
                        PFUser.become(data["sessionToken"] as? String)
                        return
                    }
                } else {
                    errorString = data["error"] as String
                }
            }
            completion(errorString)
        }
    }
    
    class func signInUser(user: User, completion: (String?, User?) -> Void) {
//        cache.fetch(key: "sessionToken", formatName: "", failure: <#Failer?##(NSError?) -> ()#>, success: <#T -> ()?##T -> ()#>)
        var parameters = ["username": user.username, "password": user.password]
        let request: URLRequestConvertible = UserRouter.SignInUser(parameters)
        Alamofire.request(request).responseJSON { _, _, data, error in
            var errorString: String!
            if let e = error {
                // e.userInfo!.debugDescription
                completion(e.localizedDescription, nil)
            }
            if let data = data as? NSDictionary {
                if data["sessionToken"] != nil {
                    LocalCache.currentUser = user
                    UserRouter.sessionToken = data["sessionToken"] as? String
                    if let token = NSData(base64EncodedString: UserRouter.sessionToken!, options: .allZeros) {
                        cache.set(value: token, key: "sessionToken", formatName: "", success: nil)
                    }
                    var user = User(json: data)
                    LocalCache.currentUser = user
                    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
                        PFUser.become(data["sessionToken"] as? String)
                        dispatch_async(dispatch_get_main_queue()){
                            completion(nil, user)
                        }
                    }
                } else {
                    completion(data["error"] as? String, nil)
                }
            }
        }
    }
    class func userLoggedIn() -> Bool {
        return(UserRouter.sessionToken != nil ? true : false)
    }
    class func getCurrentUserModel(completion: User? -> Void) {
        if UserRouter.sessionToken != nil {
            if LocalCache.currentUser.objectId == "" {
                var user: User?
                let request = UserRouter.GetUser()
                Alamofire.request(request).responseJSON { _,_, data, error in
                    if let data = data as? NSDictionary {
                        user = User(json: data)
                        if let user = user {
                            LocalCache.currentUser = user
                        }
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(user)
                    }
                }
            } else {
                completion(LocalCache.currentUser)
            }
        } else {
            completion(nil)
        }
    }
    
    class func retrieveUsersWithEmail(emails: [String], completion: [User]? -> Void) {
        var parameters = ["where": ["email":["$in":emails]]]
        var request = UserRouter.GetFriends(parameters)
        Alamofire.request(request).responseJSON { _, _, data, error in
            if let data = data as? NSDictionary {
                var users: [User]!
                completion(users!)
            }
        }
    }
    
    class func retrieveUsersWithPredicate(searchString: String, completion: [User] -> Void) {
        var users = [User]()
        var currentUserId = PFUser.currentUser().objectId
        var equery = PFUser.query()
        equery.whereKey("email", matchesRegex: searchString, modifiers: "i")
        equery.findObjectsInBackgroundWithBlock { (objects, error) in
            users = objects
                .filter { !(($0 as PFObject).objectId == currentUserId) }
                .map { User(object: $0 as PFObject) }
            var uquery = PFUser.query()
            uquery.whereKey("username", matchesRegex: searchString, modifiers: "i")
            uquery.findObjectsInBackgroundWithBlock { usernames, error in
                var ids = users.map { $0.objectId as String }
                usernames
                    .filter { !(($0 as PFObject).objectId == currentUserId) }
                    .filter { !contains(ids, ($0 as PFObject).objectId as String) }
                    .map { users.append(User(object: $0 as PFObject)) }
                
                dispatch_async(dispatch_get_main_queue()) {
                    completion(users)
                }
            }
        }
    }
    
    class func toggleFriend(user: User) -> Bool? {
        var isFriends: Bool!
        var pfCurrentUser = PFUser.currentUser()
        getCurrentUserModel() { currentUser in
            if let cu = currentUser {
                let friend = cu.users.map { $0.objectId == user.objectId }
                if !friend.isEmpty {
                    isFriends = false
                    var query = PFUser.query().whereKey("objectId", equalTo: user.objectId)
                    //                    var relation = pfCurrentUser.relationForKey("users")
                    //                    (query.findObjects() as [PFObject]).map { pfCurrentUser.removeObject($0) }
                } else {
                    isFriends = true
                    var query = PFUser.query().whereKey("objectId", equalTo: user.objectId)
                    let newFriend = (query.findObjects() as [PFObject])[0] // todo long running
                    pfCurrentUser.addUniqueObject(newFriend, forKey: "users")
                    //                    pfCurrentUser
                    //                        .relationForKey("users")
                    //                        .addObject(newFriend)
                }
            }
            pfCurrentUser.saveEventually(nil)
        }
        return isFriends
    }
    
    class func getFriendsOfUser(completion: [User]? -> Void) {
        getCurrentUserModel() { currentUser in
            
            
        }
        
    }
    
    class func saveUserLocation(location: CLLocation) {
        if let currentUser = PFUser.currentUser() {
            currentUser["location"] = PFGeoPoint(location: location)
            currentUser.saveEventually { success, error in }
        }
    }
    class func saveUser(user: User, completion: (Bool?, String?) -> Void) {
        if let currentUser = PFUser.currentUser() {
            if let u = user.username { currentUser["username"] = u }
            if let e = user.email    { currentUser["email"]    = e }
            if let p = user.password { currentUser["password"] = p }
            currentUser["location"] = PFGeoPoint(location: user.location)
            
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            var ids = user.artists.map { $0.objectId }
            var query = PFQuery(className: "Artist").whereKey("objectId", containedIn: ids)
            var a = query.findObjects()
            currentUser.addUniqueObjectsFromArray(a, forKey: "artists")
            
            ids = user.categories.map { $0.objectId }
            query = PFQuery(className: "Category").whereKey("objectId", containedIn: ids)
            var c = query.findObjects()
            currentUser.addUniqueObjectsFromArray(c, forKey: "categories")
            
            ids = user.venues.map { $0.objectId }
            query = PFQuery(className: "Venue").whereKey("objectId", containedIn: ids)
            var v = query.findObjects()
            currentUser.addUniqueObjectsFromArray(v, forKey: "venues")
            
            ids = user.events.map { $0.objectId }
            query = PFQuery(className: "Event").whereKey("objectId", containedIn: ids)
            var e = query.findObjects()
            currentUser.addUniqueObjectsFromArray(e, forKey: "events")
            
            ids = user.users.map { $0.objectId }
            query = PFQuery(className: "User").whereKey("objectId", containedIn: ids)
            var u = query.findObjects()
            currentUser.addUniqueObjectsFromArray(u, forKey: "users")
            }
            currentUser.saveEventually { success, error in
                println(success)
                if let e = error {
                    if let ui = e.userInfo {
                        completion(false, ui["error"] as? String)
                    }
                }
                completion(true, nil) }
            //            }
        } else {
            completion(false, "no current user, cannot save")
        }
        
    }
}

var classMap: [String: Model.Type] =
["Category": Category.self,
    "Venue": Venue.self,
    "User": User.self,
    "Artist": Artist.self]

// MARK: Model fetch methods
extension DataManager {
    
    // Artist
    class func retrieveArtistsWithNames(names: [String], completion: ([Artist]? -> Void)) {
        if names.isEmpty {
            completion(nil)
        } else {
            var parameters = ["where": ["name":["$in":names]]]
            var request = ClassRouter.GetArtists(parameters)
            makeArtistHTTPRequest(request) { artists in
                dispatch_async(dispatch_get_main_queue()) {
                    completion(artists!)
                }
            }
        }
    }
    
    class func retrieveAllArtists(completion: [Artist]? -> Void) {
        if LocalCache.artists.isEmpty {
            var request = ClassRouter.GetArtists(nil)
            makeArtistHTTPRequest(request) { artists in
                dispatch_async(dispatch_get_main_queue()) {
                    if let artists = artists {
                        LocalCache.artists = artists
                        completion(artists)
                    } else {
                        completion(nil)
                    }
                }
            }
        } else {
            completion(LocalCache.artists)
        }
    }
    
    class func makeArtistHTTPRequest(request: URLRequestConvertible, completion: [Artist]? -> Void) {
        Alamofire.request(request).responseJSON { (request, response, data, error) in
            var artists = [Artist]()
            if let e = error {
                println(e)
            } else {
                if let json = data as? NSDictionary {
                    if let json = json["results"] as? NSArray {
                        for element in json as NSArray {
                            if let artist = Artist(json: element as NSDictionary) {
                                artists.append(artist)
                            }
                        }
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                completion(artists)
            }
        }
    }
    
    // Venue
    class func retrieveVenuesWithNames(names: [String], completion: ([Venue]? -> Void)) {
        if names.isEmpty {
            completion(nil)
        } else {
            var parameters = ["where": ["name":["$in":names]]]
            var request = ClassRouter.GetVenues(parameters)
            makeVenueHTTPRequest(request) { venues in
                dispatch_async(dispatch_get_main_queue()) {
                    completion(venues!)
                }
            }
        }
    }
    
    class func retrieveAllVenues(completion: [Venue]? -> Void) {
        if LocalCache.venues.isEmpty {
            var request = ClassRouter.GetVenues(nil)
            makeVenueHTTPRequest(request) { venues in
                dispatch_async(dispatch_get_main_queue()) {
                    if let venues = venues {
                        LocalCache.venues = venues
                        completion(venues)
                    } else {
                        completion(nil)
                    }
                }
            }
        } else {
            completion(LocalCache.venues)
        }
    }
    
    class func makeVenueHTTPRequest(request: URLRequestConvertible, completion: [Venue]? -> Void) {
        Alamofire.request(request).responseJSON { (request, response, data, error) in
            var venues = [Venue]()
            if let e = error {
                println(e)
            } else {
                if let json = data as? NSDictionary {
                    if let json = json["results"] as? NSArray {
                        for element in json as NSArray {
                            if let venue = Venue(json: element as NSDictionary) {
                                venues.append(venue)
                            }
                        }
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                completion(venues)
            }
        }
    }
    
    class func downloadImageWithURL(url: String, completion: (Bool, UIImage?) -> Void) {
        // Make request
        Alamofire.request(.GET, url, parameters: nil, encoding: .URL).response { (request, response, data, error) -> Void in
            if error == nil {
                var imageData = NSData(data: data as NSData)
                var image = UIImage(data: imageData)
                completion(true, image)
            } else {
                completion(false, nil)
            }
        }
        
    }
    // Category
    class func retrieveCategoriesWithNames(names: [String], completion: ([Category]? -> Void)) {
        if names.isEmpty {
            completion(nil)
        } else {
            var parameters = ["where": ["name":["$in":names]]]
            var request = ClassRouter.GetCategories(parameters)
            makeCategoryHTTPRequest(request) { categories in
                dispatch_async(dispatch_get_main_queue()) {
                    completion(categories!)
                }
            }
        }
        
    }
    
    class func retrieveAllCategories(completion: [Category]? -> Void) {
        if LocalCache.categories.isEmpty {
            var request = ClassRouter.GetCategories(nil)
            makeCategoryHTTPRequest(request) { categories in
                if let categories = categories {
                    LocalCache.categories = categories
                    completion(categories)
                } else {
                    completion(nil)
                }
            }
        } else {
            completion(LocalCache.categories)
        }
    }
    
    class func makeCategoryHTTPRequest(request: URLRequestConvertible, completion: [Category]? -> Void) {
        Alamofire.request(request).responseJSON { (request, response, data, error) in
            var categories = [Category]()
            if let e = error {
                println(e)
            } else {
                if let json = data as? NSDictionary {
                    if let json = json["results"] as? NSArray {
                        for element in json as NSArray {
                            if let category = Category(json: element as NSDictionary) {
                                categories.append(category)
                            }
                        }
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                completion(categories)
            }
        }
    }
    
    // Event
    class func retrieveEventsWithTitles(titles: [String], completion: ([Event]? -> Void)) {
        if titles.isEmpty {
            completion(nil)
        } else {
            var parameters = ["where": ["title":["$in":titles]]]
            var request = ClassRouter.GetVenues(parameters)
            makeEventHTTPRequest(request) { events in
                dispatch_async(dispatch_get_main_queue()) {
                    completion(events!)
                }
            }
        }
    }
    
    class func retrieveEventsForDate(date: NSDate, completion: [Event] -> ()) {
        retrieveEventsForDateRange(date, end: date) { events in
            completion(events)
        }
    }
    
    class func retrieveEventsForDateRange(start:NSDate, end:NSDate, completion: [Event] -> ()) {
        
        func compareDateRange(date: NSDate, start:NSDate, end:NSDate) -> Bool {
            if date.compare(start) == NSComparisonResult.OrderedAscending ||
                date.compare(end) == NSComparisonResult.OrderedDescending {
                return false
            }
            return true
        }
        
        let calendar = NSCalendar.currentCalendar()
        let am = calendar.startOfDayForDate(start)
        let components = NSDateComponents()
        components.day = 7
        let pm = calendar.dateByAddingComponents(components, toDate: start, options: NSCalendarOptions.allZeros)!
        
        if LocalCache.events.count > 0 {
            completion(LocalCache.events.filter { compareDateRange($0.dateTime, am, pm) })
        } else {
            retrieveAllEvents { events in
                completion(events.filter { compareDateRange($0.dateTime, am, pm) })
            }
        }
    }

    class func sortEventsByTime(events: [Event]) -> [Event] {
        return events.sorted { $0.dateTime.compare($1.dateTime) == NSComparisonResult.OrderedAscending }
    }
    class func sortEventsByPriceMin(events: [Event]) -> [Event] {
        return events.sorted { $0.priceMin < $1.priceMin }
    }
    class func sortEventsByNumAttendees(events: [Event]) -> [Event] {
        return events.sorted { $0.numAttendees > $1.numAttendees }
    }
    
    // Sorts an array of events by distance (ascending)
    // from an origin location and return events with distance
    // in meters within a completion closure
    class func sortEventsByDistance(location: CLLocation, events: [Event], completion: [Event]? -> Void) {
        updateUserToEventDistances(location, events: events) { es in
            completion(es.sorted { $0.0.distance < $0.1.distance })
        }
    }
    
    class func updateUserToEventDistances(location: CLLocation, events: [Event], completion: ([Event] -> Void)?) {
        let request = MKLocalSearchRequest()
        for (i, e) in enumerate(events) {
            request.naturalLanguageQuery = e.venue[0].address;
            MKLocalSearch(request: request).startWithCompletionHandler { response, error in
                if let response = response {
                    var item = response.mapItems[0] as MKMapItem
                    e.distance = location.distanceFromLocation(item.placemark.location)*Configuration.meterToMile
                    if i == events.count - 1 {
                        if let c = completion {
                            c(events)
                        }
                    }
                } else {
                    if let c = completion {
                        c(events)
                    }
                }
            }
        }
    }
    
    class func sortUserEventsByTag(completion: [Event]? -> Void) {
        var userEvents = [Event]()
        retrieveAllEvents { events in
            self.getCurrentUserModel { user in
                if let u = user {
                    var categories = events                     // For each in events {}
                        .map    { $0.categories                 // for each in a relation {{}}
                        .map    { c in u.categories             // find each of the users relations {{[]}}
                        .filter { $0.objectId == c.objectId }}} // that have matching event objectIds {{{[[]]}}}
                        .map    { $0                            // for each in events {}
                        .map    { !$0.isEmpty }}                // for each in a relation, is there a match {{[[match?]]}}
                        .map    { $0                            // for each event
                        .filter { $0 }}                         // find matches
                        .map    { !$0.isEmpty }                 // return t/f for each event
                    
//                    var artists = events
//                        .map { $0.artists
//                        .map { c in u.artists
//                        .filter { $0.objectId == c.objectId }}}
//                        .map { $0
//                        .map { !$0.isEmpty }}
//                        .map { $0
//                        .filter { $0 } }
//                        .map { !$0.isEmpty }
//                    
//                    var venues = events
//                        .map { $0.venue
//                        .map { c in u.venues
//                        .filter { $0.objectId == c.objectId }}}
//                        .map { $0
//                        .map { !$0.isEmpty }}
//                        .map { $0
//                        .filter { $0 } }
//                        .map { !$0.isEmpty }

                    // add each event for every match to array
                    var e = [Event]()
                    for (i, event) in enumerate(events) {
//                        if artists[i]    { e.append(event) }
                        if categories[i] { e.append(event) }
//                        if venues[i]     { e.append(event) }
                    }
                    // return only unique entries sorted by time
                    userEvents = self.findUniqueEvents(e)
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(self.sortEventsByTime(userEvents))
                    }
                } else {
                    println("no user logged in")
                }
            }
        }
    }

    // How to call above method
    //        DataManager.sortUserEventsByTag() { events in
    //            if let e = events {
    //                self.eventsArray = e
    //            }
    //        }
    
    class func findUniqueEvents(events: [Event]) -> [Event] {
        var uniqueEvents = [Event]()
        for event in events {
            var unique = true
            for u in uniqueEvents {
                if event.objectId == u.objectId {
                    unique = false
                    break
                }
            }
            if unique {
                uniqueEvents.append(event)
            }
        }
        return uniqueEvents
    }
    
//    class func retrieveAllEvents(completion: [Event] -> Void) {
//        var today = NSDate(timeIntervalSinceNow: 0)
//        var formatter = NSDateFormatter()
//        formatter.dateFormat = "M/d/yy HH:mm"
//        var t = formatter.stringFromDate(today)
//        println("today's date: \(t)")
//        
//        if LocalCache.events.isEmpty {
//            var parameters = ["where": ["dateTime": ["$gte": today]]]
//            var request = ClassRouter.GetEvents(parameters)
//            makeEventHTTPRequest(request) { events in
//                if let events = events {
//                    LocalCache.events = events
//                    dispatch_async(dispatch_get_main_queue()) {
//                        // sort first
//                        completion(self.sortEventsByTime(events))
//                    }
//                    for event in events {
//                        println("event date: \(event.dateTime)")
//                    }
//                }
//            }
//        } else {
//            dispatch_async(dispatch_get_main_queue()) {
//                completion(LocalCache.events)
//            }
//        }
//    }
    
    class func retrieveAllEvents(completion: [Event] -> Void) {
        var today = NSDate(timeIntervalSinceNow: 0)
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.stringFromDate(today)
        
        if LocalCache.events.isEmpty {
            var parameters = ["where": ["dateTime":["$gte":["__type":"Date", "iso": formatter.stringFromDate(today)]]]]
            var request = ClassRouter.GetEvents(parameters)
            makeEventHTTPRequest(request) { events in
                if let events = events {
                    LocalCache.events = events
                    dispatch_async(dispatch_get_main_queue()) {
                        // sort first
                        completion(self.sortEventsByTime(events))
                    }
                }
            }
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                completion(LocalCache.events)
            }
        }
    }
    
    class func makeEventHTTPRequest(request: URLRequestConvertible, completion: [Event]? -> Void) {
        //var cache = NSCache()
        
        Alamofire.request(request).responseJSON { (request, response, data, error) in
            var events = [Event]()
            if let e = error {
                println(e)
            } else {
                if let json = data as? NSDictionary {
                    if let json = json["results"] as? NSArray {
                        for element in json as NSArray {
                            if let event = Event(json: element as NSDictionary) {
                                events.append(event)
                                //cache.setObject(event, forKey: event.objectId)
                            }
                        }
                        dispatch_async(dispatch_get_main_queue()) {
                            completion(events)
                        }
                    }
                }
            }
        }
    }
    
    class func makeArrayOfObjects(objectInfo: NSArray) -> [Model]? {
        var objects = [Model]()
        
        if objectInfo.count > 0 {
            var ids = [String]()
            var className = String()
            for c in objectInfo {
                className = c["className"] as String
                if let id = c.objectForKey("objectId") as? String {
                    ids.append(id)
                }
            }
            var query = PFQuery(className: className).whereKey("objectId", containedIn: ids)
            if let cm = classMap[className] {
                objects = query.findObjects().map { cm(object: $0 as PFObject) }
            }
        }
        return objects
    }
}
