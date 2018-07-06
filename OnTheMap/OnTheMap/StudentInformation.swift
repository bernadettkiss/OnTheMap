//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Bernadett Kiss on 6/12/18.
//  Copyright © 2018 Bernadett Kiss. All rights reserved.
//

import Foundation

struct StudentInformation {
    
    let id: String?
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Double?
    let longitude: Double?
    
    init(dictionary: [String: AnyObject]) {
        id = dictionary[ParseClient.JSONResponseKeys.ObjectId] as? String
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as? String
        firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as? String
        lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as? String
        mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as? String
        mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as? String
        latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as? Double
        longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as? Double
    }
    
    static func studentInformationArrayFrom(results: [[String: AnyObject]]) -> [StudentInformation] {
        var studentInformationArray = [StudentInformation]()
        for result in results {
            studentInformationArray.append(StudentInformation(dictionary: result))
        }
        return studentInformationArray
    }
}
