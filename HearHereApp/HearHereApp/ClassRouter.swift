//
//  Router.swift
//  HearHereApp
//
//  Created by Matthew Korporaal on 3/12/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import Foundation
import Alamofire

enum ClassRouter: URLRequestConvertible {
    static let baseURLString = "https://api.parse.com/1/classes"

    case GetArtists([String: AnyObject]?)
    case GetCategories([String: AnyObject]?)
    case GetVenues([String: AnyObject]?)
    case GetEvents([String: AnyObject]?)
    
    var method: Alamofire.Method {
        switch self {
        case .GetArtists:    return .GET
        case .GetCategories: return .GET
        case .GetVenues:     return .GET
        case .GetEvents:     return .GET
        }
    }
    
    var path: String {
        switch self {
        case .GetArtists:    return "/Artist"
        case .GetCategories: return "/Category"
        case .GetVenues:     return "/Venue"
        case .GetEvents:     return "/Event"
        }
    }
    
    var URLRequest: NSURLRequest {
        let URL = NSURL(string: ClassRouter.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        if mutableURLRequest.HTTPMethod == "PUT" || mutableURLRequest.HTTPMethod == "POST" {
            mutableURLRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        mutableURLRequest.addValue(Configuration.parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        mutableURLRequest.addValue(Configuration.parseRestAPIKey, forHTTPHeaderField: "X-Parse-REST-API-key")
        
        
        switch self {
        case .GetArtists(let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case .GetCategories(let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case .GetVenues(let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case .GetEvents(let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        default:
            return mutableURLRequest
        }
    }
    
}