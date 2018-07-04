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
    var studentInformationArray = [StudentInformation]()
    
    let headerParameters = [ParseClient.ParameterKeys.ParseAppId: ParseClient.ParameterValues.ParseAppId,
                            ParseClient.ParameterKeys.RestApiKey: ParseClient.ParameterValues.RestApiKey]
    
    func retrieveData(completion: @escaping (_ success: Bool, _ error: AppError?) -> Void) {
        clearStudentInformationArray()
        getStudentLocations() { (studentInformationArray, error) in
            if let studentInformationArray = studentInformationArray {
                self.studentInformationArray = studentInformationArray
                completion(true, nil)
            } else {
                print(error ?? "Could not get studentInformationArray")
                completion(false, .noData)
            }
        }
    }
    
    func getUserLocation() {
        guard let accountKey = UserAccount.shared.key else {
            return
        }
        let accountKey2 = "1235"
        let queryString = "{\"\(ParseClient.ParameterValues.UniqueKey)\":\"\(accountKey2)\"}"
        let urlParameters = [ParseClient.ParameterKeys.Where: queryString]
        
        NetworkManager.shared.request(client: .parse, urlParameters: urlParameters, httpMethod: .get, headerParameters: headerParameters, jsonBody: nil) { (results, error) in
            
            if let error = error {
                print(error)
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
    
    private func getStudentLocations(_ completionHandlerForStudentLocations: @escaping (_ result: [StudentInformation]?, _ error: NSError?) -> Void) {
        NotificationCenter.default.post(name: StudentLocations.willLoad.notification, object: nil)
        
        let urlParameters = [ParseClient.ParameterKeys.Limit: ParseClient.ParameterValues.Limit,
                             ParseClient.ParameterKeys.Order: ParseClient.ParameterValues.Order]
        
        NetworkManager.shared.request(client: .parse, urlParameters: urlParameters, httpMethod: .get, headerParameters: headerParameters, jsonBody: nil) { (results, error) in
            
            if let error = error {
                completionHandlerForStudentLocations(nil, error)
                NotificationCenter.default.post(name: StudentLocations.couldNotLoad.notification, object: nil)
            } else {
                if let results = results?[ParseClient.JSONResponseKeys.Results] as? [[String: AnyObject]] {
                    self.studentInformationArray = StudentInformation.studentInformationArrayFrom(results: results)
                    NotificationCenter.default.post(name: StudentLocations.didLoad.notification, object: nil)
                    completionHandlerForStudentLocations(self.studentInformationArray, nil)
                } else {
                    completionHandlerForStudentLocations(nil, NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
                    NotificationCenter.default.post(name: StudentLocations.couldNotLoad.notification, object: nil)
                }
            }
        }
    }
    
    func postStudentLocation(_ completionHandlerForStudentLocation:  @escaping (_ result: String?, _ error: NSError?) -> Void) {
//        let jsonBody = "{\"\(ParseClient.JSONBodyKeys.UniqueKey)\": \"\(UserDataService.shared.uniqueKey)\", \"\(ParseClient.JSONBodyKeys.FirstName)\": \"\(UserDataService.shared.firstName)\", \"\(ParseClient.JSONBodyKeys.LastName)\": \"\(UserDataService.shared.lastName)\",\"\(ParseClient.JSONBodyKeys.MapString)\": \"\(UserDataService.shared.mapString)\", \"\(ParseClient.JSONBodyKeys.MediaURL)\": \"\(UserDataService.shared.mediaURL)\",\"\(ParseClient.JSONBodyKeys.Latitude)\": \(UserDataService.shared.latitude), \"\(ParseClient.JSONBodyKeys.Longitude)\": \(UserDataService.shared.longitude)}"
//        
        NetworkManager.shared.request(client: .parse, urlParameters: nil, httpMethod: .post, headerParameters: headerParameters, jsonBody: nil) { (results, error) in
            if let error = error {
                completionHandlerForStudentLocation(nil, error)
            } else {
                if let results = results?[ParseClient.JSONResponseKeys.CreatedAt] as? String {
                    completionHandlerForStudentLocation(results, nil)
                } else {
                    completionHandlerForStudentLocation(nil, NSError(domain: "postStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postStudentLocation"]))
                }
            }
        }
    }
    
    func clearStudentInformationArray() {
        studentInformationArray.removeAll()
    }
}
