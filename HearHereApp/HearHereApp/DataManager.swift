
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

class Data {
    private struct Cache {
        static var events = [Event]()
        static var currentUser = User(id: "")
        static var venues = [Venue]()
        static var artists = [Artist]()
        static var categories = [Category]()
    }
    class var events: [Event] {
        get { return Cache.events }
        set { Cache.events = newValue }
    }
    class var currentUser: User {
        get { return Cache.currentUser }
        set { Cache.currentUser = newValue }
    }
    class var venues: [Venue] {
        get { return Cache.venues }
        set { Cache.venues = newValue }
    }
    class var artists: [Artist] {
        get { return Cache.artists }
        set { Cache.artists = newValue }
    }
    class var categories: [Category] {
        get { return Cache.categories }
        set { Cache.categories = newValue }
    }
}

class DataManager {
    init() { }
}

// MARK: User data methods
extension DataManager {
    
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
                    Data.currentUser = user
                    UserRouter.sessionToken = data["sessionToken"] as? String
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
    class func signInUser(user: User, completion: String? -> Void) {
        var parameters = ["username": user.username, "password": user.password]
        let request: URLRequestConvertible = UserRouter.SignInUser(parameters)
        Alamofire.request(request).responseJSON { _, _, data, error in
            var errorString: String!
            if let e = error {
                // e.userInfo!.debugDescription
                errorString = e.localizedDescription
            }
            if let data = data as? NSDictionary {
                if data["sessionToken"] != nil {
                    Data.currentUser = user
                    UserRouter.sessionToken = data["sessionToken"] as? String
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
    
    class func getCurrentUserModel(completion: User? -> Void) {
        if UserRouter.sessionToken == nil {
            var user: User?
            let request = UserRouter.GetUser()
            Alamofire.request(request).responseJSON { _,_, data, error in
                if let data = data as? NSDictionary {
                    user = User(json: data)
                    if let user = user {
                        Data.currentUser = user
                    }
                }
                dispatch_async(dispatch_get_main_queue()) {
                    completion(user)
                }
            }
        } else {
            completion(Data.currentUser)
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

    class func saveUser(user: User, completion: Bool? -> Void) {
        if let currentUser = PFUser.currentUser() {
        
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

                currentUser.saveEventually { _, _ in completion(true) }
            }
        } else {
            println("no current user, cannot save")
            completion(false)
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
        if Data.artists.isEmpty {
            var request = ClassRouter.GetArtists(nil)
            makeArtistHTTPRequest(request) { artists in
                dispatch_async(dispatch_get_main_queue()) {
                    if let artists = artists {
                        Data.artists = artists
                        completion(artists)
                    } else {
                        completion(nil)
                    }
                }
            }
        } else {
            completion(Data.artists)
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
        if Data.venues.isEmpty {
            var request = ClassRouter.GetVenues(nil)
            makeVenueHTTPRequest(request) { venues in
                dispatch_async(dispatch_get_main_queue()) {
                    if let venues = venues {
                        Data.venues = venues
                        completion(venues)
                    } else {
                        completion(nil)
                    }
                }
            }
        } else {
            completion(Data.venues)
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
        if Data.categories.isEmpty {
            var request = ClassRouter.GetCategories(nil)
            makeCategoryHTTPRequest(request) { categories in
                if let categories = categories {
                    Data.categories = categories
                    completion(categories)
                } else {
                    completion(nil)
                }
            }
        } else {
            completion(Data.categories)
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
    class func sortEventsByDistance(location: CLLocation, events: [Event], completion: [Event] -> Void) {
        func getEventsCoordinates(events: [Event], completion: [Event] -> Void) {
            let request = MKLocalSearchRequest()
            for (i, e) in enumerate(events) {
                request.naturalLanguageQuery = e.venue[0].address;
                MKLocalSearch(request: request).startWithCompletionHandler { response, error in
                    var item = response.mapItems[0] as MKMapItem
                    e.distance = location.distanceFromLocation(item.placemark.location)
                    if i == events.count - 1 {
                        completion(events)
                    }
                }
            }
        }
        
        getEventsCoordinates(events) { es in
//            dispatch_async(dispatch_get_main_queue()) {
                completion(es.sorted { $0.0.distance < $0.1.distance })
//            }
        }
    }
    
    // Get locations by distance (how to use code above)
    //        var location = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
    //        DataManager.retrieveAllEvents { events in
    //            DataManager.sortEventsByDistance(location, events: events) { sortedEvents in
    //                sortedEvents.map { println($0.distance) }; return
    //            }
    //        }
    
    class func sortUserEventsByTag(completion: [Event]? -> Void) {
        var userEvents = [Event]()
        retrieveAllEvents { events in
            self.getCurrentUserModel { user in
                if let u = user {
                    var artists = events.map { $0.artists.map { a in u.artists.filter { $0.objectId == a.objectId } } }.map { $0.filter { $0.isEmpty }.isEmpty }
                    var categories = events.map { $0.categories.map { a in u.categories.filter { $0.objectId == a.objectId } } }.map { $0.filter { $0.isEmpty }.isEmpty }
                    var venues = events.map { $0.venue.map { a in u.venues.filter { $0.objectId == a.objectId } } }.map { $0.filter { $0.isEmpty }.isEmpty }
                    var e = [Event]()
                    for (i, tf) in enumerate(events) {
                        if artists[i]    { e.append(tf) }
                        if categories[i] { e.append(tf) }
                        if venues[i]     { e.append(tf) }
                    }
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
    
    class func retrieveAllEvents(completion: [Event] -> Void) {
        if Data.events.isEmpty {
            var request = ClassRouter.GetEvents(nil)
            makeEventHTTPRequest(request) { events in
                if let events = events {
                    Data.events = events
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(events)
                    }
                }
            }
        } else {
            completion(Data.events)
        }
    }
    
    class func makeEventHTTPRequest(request: URLRequestConvertible, completion: [Event]? -> Void) {
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
 
    class func makeArrayOfObjects(objectInfo: NSArray) -> [AnyObject]? {//, completion: ([AnyObject]? -> Void)?) {
        var objects = [AnyObject]()
        
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
            //            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            
                if let cm = classMap[className] {
                    objects = query.findObjects().map { cm(object: $0 as PFObject) }
                }
//                completion!(objects)
//            }
        }
        return objects
    }
}
