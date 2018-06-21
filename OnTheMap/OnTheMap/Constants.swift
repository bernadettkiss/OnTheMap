//
//  Constants.swift
//  OnTheMap
//
//  Created by Bernadett Kiss on 6/21/18.
//  Copyright © 2018 Bernadett Kiss. All rights reserved.
//

import Foundation

enum StudentLocations: String {
    case willLoad = "StudentLocationsWillLoad"
    case didLoad = "StudentLocationsDidLoad"
    
    var notification: Notification.Name {
        return Notification.Name(rawValue: self.rawValue)
    }
}
