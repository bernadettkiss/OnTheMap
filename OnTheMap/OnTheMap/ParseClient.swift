//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Bernadett Kiss on 6/14/18.
//  Copyright © 2018 Bernadett Kiss. All rights reserved.
//

import Foundation

class ParseClient {
    
    static let shared = ParseClient()
    
    public private(set) var studentInformationArray = [StudentInformation]()
    
    private let headerParameters = [ParseClient.ParameterKeys.ParseAppId: ParseClient.ParameterValues.ParseAppId,
                                    ParseClient.ParameterKeys.RestApiKey: ParseClient.ParameterValues.RestApiKey]
    
    func getUserLocation() {
        guard let key = UserAccount.shared.key else {
            return
        }
        let queryString = "{\"\(ParseClient.ParameterValues.UniqueKey)\":\"\(key)\"}"
        let urlParameters = [ParseClient.ParameterKeys.Where: queryString]
        
        NetworkManager.shared.request(client: .parse, pathExtension: nil, urlParameters: urlParameters, httpMethod: .get, headerParameters: headerParameters, jsonBody: nil) { (results, error) in
            if error != nil {
                return
            } else {
                if let results = results?[ParseClient.JSONResponseKeys.Results] as? [[String: AnyObject]] {
                    let studentInformationArray = StudentInformation.studentInformationArrayFrom(results: results)
                    if !studentInformationArray.isEmpty {
                        UserAccount.shared.setStudentLocation(studentInformationArray[0])
                    } else {
                        return
                    }
                }
            }
        }
    }
    
    func retrieveData(completion: @escaping (_ success: Bool) -> Void) {
        clearStudentInformationArray()
        
        let urlParameters = [ParseClient.ParameterKeys.Limit: ParseClient.ParameterValues.Limit,
                             ParseClient.ParameterKeys.Order: ParseClient.ParameterValues.Order]
        
        NetworkManager.shared.request(client: .parse, pathExtension: nil, urlParameters: urlParameters, httpMethod: .get, headerParameters: headerParameters, jsonBody: nil) { (results, error) in
            if error != nil {
                completion(false)
            } else {
                if let results = results?[ParseClient.JSONResponseKeys.Results] as? [[String: AnyObject]] {
                    self.studentInformationArray = StudentInformation.studentInformationArrayFrom(results: results)
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func post(mapString: String, mediaURL: String, latitude: String, longitude: String, completion: @escaping (_ success: Bool) -> Void) {
        let jsonBody = buildJSONBody(mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
        
        NetworkManager.shared.request(client: .parse, pathExtension: nil, urlParameters: nil, httpMethod: .post, headerParameters: headerParameters, jsonBody: jsonBody) { (results, error) in
            if error != nil {
                completion(false)
            } else {
                if let _ = results?[ParseClient.JSONResponseKeys.CreatedAt] as? String {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func update(mapString: String, mediaURL: String, latitude: String, longitude: String, completion: @escaping (_ success: Bool) -> Void) {
        let jsonBody = buildJSONBody(mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
        
        if let pathExtension = UserAccount.shared.location?.id {
            NetworkManager.shared.request(client: .parse, pathExtension: pathExtension, urlParameters: nil, httpMethod: .put, headerParameters: headerParameters, jsonBody: jsonBody) { (results, error) in
                if error != nil {
                    completion(false)
                } else {
                    if let _ = results?[ParseClient.JSONResponseKeys.UpdatedAt] as? String {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        }
    }
    
    private func buildJSONBody(mapString: String, mediaURL: String, latitude: String, longitude: String) -> String? {
        guard let key = UserAccount.shared.key else {
            return nil
        }
        let jsonBody = "{\"\(ParseClient.JSONBodyKeys.UniqueKey)\": \"\(key)\", \"\(ParseClient.JSONBodyKeys.FirstName)\": \"\(UserAccount.shared.firstName)\", \"\(ParseClient.JSONBodyKeys.LastName)\": \"\(UserAccount.shared.lastName)\",\"\(ParseClient.JSONBodyKeys.MapString)\": \"\(mapString)\", \"\(ParseClient.JSONBodyKeys.MediaURL)\": \"\(mediaURL)\",\"\(ParseClient.JSONBodyKeys.Latitude)\": \(latitude), \"\(ParseClient.JSONBodyKeys.Longitude)\": \(longitude)}"
        return jsonBody
    }
    
    func clearStudentInformationArray() {
        studentInformationArray.removeAll()
    }
}
