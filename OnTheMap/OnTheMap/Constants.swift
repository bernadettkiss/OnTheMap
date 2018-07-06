//
//  Constants.swift
//  OnTheMap
//
//  Created by Bernadett Kiss on 6/21/18.
//  Copyright © 2018 Bernadett Kiss. All rights reserved.
//

import Foundation

let udacitySignUpURL = "https://auth.udacity.com/sign-up"

enum SegueIdentifier: String {
    case unwindToLogin = "unwindToLogin"
    case toStudentInformation = "toStudentInformation"
    case toInformationPosting = "toInformationPosting"
    case toLocationConfirmation = "toLocationConfirmation"
}

enum AppError: String {
    case emptyCredentials = "Please enter your email and password"
    case incorrectCredentials = "Please enter valid credentials"
    case networkFailure = "There was a problem with the network. Please try again"
    case noData = "Could not retrieve data from the server"
    case emptyLocation = "Please enter your location and website"
    case incorrectLink = "Please enter valid link starting with http(s)://"
    case geocodingFailure = "Could not find your location"
    case postError = "Could not save your information"
    case logoutError = "Could not log out. Please try again"
    case error = "An error has occured"
}
