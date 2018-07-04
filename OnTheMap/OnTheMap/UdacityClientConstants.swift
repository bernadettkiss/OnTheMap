//
//  UdacityClientConstants.swift
//  OnTheMap
//
//  Created by Bernadett Kiss on 6/26/18.
//  Copyright © 2018 Bernadett Kiss. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    struct Constants {
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api/session"
    }
    
    struct JSONBodyKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    struct JSONResponseKeys {
        static let Results = "results"
        static let Account = "account"
        static let Key = "key"
        static let Registered = "registered"
        static let Session = "session"
        static let Id = "id"
        static let Expiration = "expiration"
        static let Error = "error"
        static let Status = "status"
    }
}
