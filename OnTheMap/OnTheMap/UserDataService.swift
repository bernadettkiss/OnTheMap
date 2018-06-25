//
//  UserDataService.swift
//  OnTheMap
//
//  Created by Bernadett Kiss on 6/25/18.
//  Copyright © 2018 Bernadett Kiss. All rights reserved.
//

import Foundation

class UserDataService {
    
    static let shared = UserDataService()
    
    public private(set) var uniqueKey = "1234"
    public private(set) var firstName = "Theodor"
    public private(set) var lastName = "Doe"
    public private(set) var mapString = ""
    public private(set) var mediaURL = ""
    public private(set) var latitude = ""
    public private(set) var longitude = ""
    
    func setLocation(mapString: String, mediaURL: String, latitude: String, longitude: String) {
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
    }
}

