//
//  Constants.swift
//  OnTheMap
//
//  Created by Bernadett Kiss on 6/21/18.
//  Copyright © 2018 Bernadett Kiss. All rights reserved.
//

import Foundation

let udacitySignUpURL = "https://auth.udacity.com/sign-up"

enum StudentLocations: String {
    case willLoad = "StudentLocationsWillLoad"
    case didLoad = "StudentLocationsDidLoad"
    case couldNotLoad = "StudentLocationsCouldNotLoad"
    
    var notification: Notification.Name {
        return Notification.Name(rawValue: self.rawValue)
    }
}

enum SegueIdentifier: String {
    case unwindToLogin = "unwindToLogin"
    case toStudentInformation = "toStudentInformation"
    case toInformationPosting = "toInformationPosting"
    case toLocationConfirmation = "toLocationConfirmation"
}
