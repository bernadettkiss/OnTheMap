//
//  NetworkManager.swift
//  OnTheMap
//
//  Created by Bernadett Kiss on 6/27/18.
//  Copyright © 2018 Bernadett Kiss. All rights reserved.
//

import Foundation

typealias Parameters = [String: String]
typealias CompletionHandler = (_ result: AnyObject?, _ error: NSError?) -> ()

enum Client: String {
    case udacity
    case parse
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    var session = URLSession.shared
    var client: Client?
    
    func request(client: Client, pathExtension: String?, urlParameters: Parameters?, httpMethod: HTTPMethod, headerParameters: Parameters?, jsonBody: String?, completionHandler: @escaping CompletionHandler) {
        self.client = client
        let url = buildURL(client: client, pathExtension: pathExtension, urlParameters: urlParameters)
        let request = buildRequest(client: client, url: url, httpMethod: httpMethod, headerParameters: headerParameters, jsonBody: jsonBody)
        let _ = createTask(with: request) { (results, error) in
            completionHandler(results, error)
            return
        }
    }
    
    private func buildURL(client: Client, pathExtension: String?, urlParameters: Parameters?) -> URL {
        var components = URLComponents()
        
        var pathExtensionString = ""
        if let pathExtension = pathExtension {
            pathExtensionString = "/" + pathExtension
        }
        
        switch client {
        case .udacity:
            components.scheme = UdacityClient.Constants.ApiScheme
            components.host = UdacityClient.Constants.ApiHost
            components.path = UdacityClient.Constants.ApiPath + pathExtensionString
        case .parse:
            components.scheme = ParseClient.Constants.ApiScheme
            components.host = ParseClient.Constants.ApiHost
            components.path = ParseClient.Constants.ApiPath + pathExtensionString
        }
        
        if let urlParameters = urlParameters {
            components.queryItems = [URLQueryItem]()
            for (key, value) in urlParameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems?.append(queryItem)
            }
        }
        
        return components.url!
    }
    
    private func buildRequest(client: Client, url: URL, httpMethod: HTTPMethod, headerParameters: Parameters?, jsonBody: String?) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        if client == .udacity && httpMethod == .delete {
            var xsrfCookie: HTTPCookie? = nil
            let sharedCookieStorage = HTTPCookieStorage.shared
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
        }
        
        if client == .udacity && httpMethod == .post {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        
        if httpMethod == .post {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if let headerParameters = headerParameters {
            for (key, value) in headerParameters {
                request.addValue("\(value)", forHTTPHeaderField: key)
            }
        }
        
        if let jsonBody = jsonBody {
            request.httpBody = jsonBody.data(using: .utf8)
        }
        
        return request
    }
    
    private func createTask(with request: URLRequest, completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil  else {
                completionHandler(nil, error! as NSError)
                return
            }
            
            if request.httpMethod == HTTPMethod.get.rawValue {
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                    let error = "Your request returned a status code other than 2xx!"
                    completionHandler(nil, NSError(domain: "createTask", code: 1, userInfo: [NSLocalizedDescriptionKey: error]))
                    return
                }
            }
            
            guard let data = data else {
                let error = "No data was returned by the request!"
                completionHandler(nil, NSError(domain: "createTask", code: 1, userInfo: [NSLocalizedDescriptionKey: error]))
                return
            }
            
            self.convertData(data, completionHandler: completionHandler)
        }
        task.resume()
        return task
    }
    
    private func convertData(_ data: Data, completionHandler: CompletionHandler) {
        var result = data
        
        if self.client == .udacity {
            let range = Range(5..<result.count)
            result = data.subdata(in: range)
        }
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: result, options: .allowFragments) as AnyObject
        } catch {
            completionHandler(nil, error as NSError)
        }
        completionHandler(parsedResult, nil)
    }
}
