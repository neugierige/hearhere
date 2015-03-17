//
//  Router.swift
//  HearHereApp
//
//  Created by Matthew Korporaal on 3/12/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import Foundation
import Alamofire

enum UserRouter: URLRequestConvertible {
    static let baseURLString = "https://api.parse.com/1"
    static var sessionToken: String?
    
    case SignUpUser([String: AnyObject])
    case SignInUser([String: AnyObject])
    case GetUser()
    case UpdateUser(String, [String: AnyObject])
    case GetFriends([String: AnyObject]?)

    var method: Alamofire.Method {
        switch self {
        case .SignUpUser: return .POST
        case .SignInUser: return .GET
        case .GetUser:    return .GET
        case .UpdateUser: return .PUT
        case .GetFriends: return .GET
        }
    }
    
    var path: String {
        switch self {
        case .SignUpUser: return "/users"
        case .SignInUser: return "/login"
        case .GetUser:    return "/users/me"
        case .UpdateUser: return "/users/me"
        case .GetFriends: return "/User"
        }
    }
    
    var URLRequest: NSURLRequest {
        let URL = NSURL(string: UserRouter.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        if mutableURLRequest.HTTPMethod == "PUT" || mutableURLRequest.HTTPMethod == "POST" {
            mutableURLRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if let token = UserRouter.sessionToken {
            mutableURLRequest.setValue(UserRouter.sessionToken, forHTTPHeaderField: "X-Parse-Session-Token")
        }
        
        mutableURLRequest.addValue(Configuration.parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        mutableURLRequest.addValue(Configuration.parseRestAPIKey, forHTTPHeaderField: "X-Parse-REST-API-key")
        
        
        switch self {
        case .SignUpUser(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        case .SignInUser(let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case .GetUser():
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0
        case .UpdateUser(_, let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case .GetFriends(let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        default:
            return mutableURLRequest
        }
    }
    
}