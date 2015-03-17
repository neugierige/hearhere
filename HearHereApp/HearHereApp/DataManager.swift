
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

class DataManager {
    init() { }
}

// MARK: User data methods
extension DataManager {
    
    class func signUpUser(user: User, completion: String? -> Void) {
        var parameters = ["username": user.username, "email": user.email, "password": user.password]
        let request: URLRequestConvertible = UserRouter.SignUpUser(parameters)
        Alamofire.request(request).responseJSON { request, response, data, error in
            var errorString: String!
            if let e = error {
                errorString = e.localizedDescription
            }
            if let data = data as? NSDictionary {
                if data["sessionToken"] != nil {
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
        var user: User?
        let request = UserRouter.GetUser()
        Alamofire.request(request).responseJSON { _,_, data, error in
            if let data = data as? NSDictionary {
                user = User(json: data)
            }
            completion(user)
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
                println(users)
                
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
            completion(artists!)
        }
        }
    }
    
    class func retrieveAllArtists(completion: [Artist] -> Void) {
        var request = ClassRouter.GetArtists(nil)
        makeArtistHTTPRequest(request) { artists in
            completion(artists!)
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
                completion(venues!)
            }
        }
    }
    
    class func retrieveAllVenues(completion: [Venue] -> Void) {
        var request = ClassRouter.GetVenues(nil)
        makeVenueHTTPRequest(request) { venues in
            completion(venues!)
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
    
    // Category
    class func retrieveCategoriesWithNames(names: [String], completion: ([Category]? -> Void)) {
        if names.isEmpty {
            completion(nil)
        } else {
            var parameters = ["where": ["name":["$in":names]]]
            var request = ClassRouter.GetCategories(parameters)
            makeCategoryHTTPRequest(request) { categories in
                completion(categories!)
            }
        }
    }
    
    class func retrieveAllCategories(completion: [Category] -> Void) {
        var request = ClassRouter.GetCategories(nil)
        makeCategoryHTTPRequest(request) { categories in
            completion(categories!)
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
                completion(events!)
            }
        }
    }
    
    class func retrieveAllEvents(completion: [Event] -> Void) {
        var request = ClassRouter.GetVenues(nil)
        makeEventHTTPRequest(request) { events in
            completion(events!)
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
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                completion(events)
            }
        }
    }
 
    class func makeArrayOfObjects(objectInfo: NSArray) -> [AnyObject]? {//, completion: ([AnyObject]? -> Void)?) {
        var objects = [AnyObject]()
        
        if objectInfo.count > 0 {
//            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
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
//                completion!(objects)
//            }
        }
        return objects
    }
}
