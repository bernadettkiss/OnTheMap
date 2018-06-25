//
//  ParseClientConstants.swift
//  OnTheMap
//
//  Created by Bernadett Kiss on 6/12/18.
//  Copyright © 2018 Bernadett Kiss. All rights reserved.
//

import Foundation

extension ParseClient {

    struct Constants {
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
    }
    
    struct Methods {
        static let StudentLocation = "/StudentLocation"
    }
    
    struct ParameterKeys {
        static let ParseAppId = "X-Parse-Application-Id"
        static let RestApiKey = "X-Parse-REST-API-Key"
        static let Limit = "limit"
        static let Order = "order"
        static let Where = "where"
        static let ContentType = "Content-Type"
    }
    
    struct ParameterValues{
        static let ParseAppId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let Limit = "10"
        static let Order = "-updatedAt"
        static let UniqueKey = "uniqueKey"
        static let ContentType = "application/json"
    }
    
    struct JSONBodyKeys {
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
    }
    
    struct JSONResponseKeys {
        static let Results = "results"
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
    }
}
