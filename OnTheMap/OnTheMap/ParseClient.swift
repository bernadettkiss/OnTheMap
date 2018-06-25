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
    
    var session = URLSession.shared
    var studentInformationArray = [StudentInformation]()
    
    func getStudentLocations(_ completionHandlerForStudentLocations: @escaping (_ result: [StudentInformation]?, _ error: NSError?) -> Void) {
        NotificationCenter.default.post(name: StudentLocations.willLoad.notification, object: nil)
        
        let parameters = [ParseClient.ParameterKeys.Limit: ParseClient.ParameterValues.Limit,
                          ParseClient.ParameterKeys.Order: ParseClient.ParameterKeys.Order]
        
        _ = taskForGET(method: ParseClient.Methods.StudentLocation, parameters: parameters as [String: AnyObject]) { (results, error) in
            if let error = error {
                completionHandlerForStudentLocations(nil, error)
            } else {
                if let results = results?[ParseClient.JSONResponseKeys.Results] as? [[String: AnyObject]] {
                    self.studentInformationArray = StudentInformation.studentInformationArrayFrom(results: results)
                    NotificationCenter.default.post(name: StudentLocations.didLoad.notification, object: nil)
                    completionHandlerForStudentLocations(self.studentInformationArray, nil)
                } else {
                    completionHandlerForStudentLocations(nil, NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
                }
            }
        }
    }
    
    func postStudentLocation(_ completionHandlerForStudentLocation:  @escaping (_ result: String?, _ error: NSError?) -> Void) {
        let parameters = [String: String]()
        let jsonBody = "{\"\(ParseClient.JSONBodyKeys.UniqueKey)\": \"\(UserDataService.shared.uniqueKey)\", \"\(ParseClient.JSONBodyKeys.FirstName)\": \"\(UserDataService.shared.firstName)\", \"\(ParseClient.JSONBodyKeys.LastName)\": \"\(UserDataService.shared.lastName)\",\"\(ParseClient.JSONBodyKeys.MapString)\": \"\(UserDataService.shared.mapString)\", \"\(ParseClient.JSONBodyKeys.MediaURL)\": \"\(UserDataService.shared.mediaURL)\",\"\(ParseClient.JSONBodyKeys.Latitude)\": \(UserDataService.shared.latitude), \"\(ParseClient.JSONBodyKeys.Longitude)\": \(UserDataService.shared.longitude)}"
        
        let _ = taskForPOST(method: ParseClient.Methods.StudentLocation, parameters: parameters as [String: AnyObject], jsonBody: jsonBody) { (results, error) in
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
    
    func taskForGET(method: String, parameters: [String: AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        var request = URLRequest(url: buildURL(fromParameters: parameters as [String: AnyObject], withPathExtension: method))
        request.addValue(ParseClient.ParameterValues.ParseAppId, forHTTPHeaderField: ParseClient.ParameterKeys.ParseAppId)
        request.addValue(ParseClient.ParameterValues.RestApiKey, forHTTPHeaderField: ParseClient.ParameterKeys.RestApiKey)
        
        let task = session.dataTask(with: request) { data, response, error in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        task.resume()
        return task
    }
    
    func taskForPOST(method: String, parameters: [String: AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        var request = URLRequest(url: buildURL(fromParameters: parameters as [String: AnyObject], withPathExtension: method))
        request.httpMethod = "POST"
        request.addValue(ParseClient.ParameterValues.ParseAppId, forHTTPHeaderField: ParseClient.ParameterKeys.ParseAppId)
        request.addValue(ParseClient.ParameterValues.RestApiKey, forHTTPHeaderField: ParseClient.ParameterKeys.RestApiKey)
        request.addValue(ParseClient.ParameterValues.ContentType, forHTTPHeaderField: ParseClient.ParameterKeys.ContentType)
        request.httpBody = jsonBody.data(using: .utf8)
        
        let task = session.dataTask(with: request) { data, response, error in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPOST(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        task.resume()
        return task
    }
    
    func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    func buildURL(fromParameters parameters: [String: AnyObject], withPathExtension pathExtension: String?) -> URL {
        var components = URLComponents()
        components.scheme = ParseClient.Constants.ApiScheme
        components.host = ParseClient.Constants.ApiHost
        components.path = ParseClient.Constants.ApiPath + (pathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems?.append(queryItem)
        }
        return components.url!
    }
    
    func clearStudentInformationArray() {
        studentInformationArray.removeAll()
    }
}
