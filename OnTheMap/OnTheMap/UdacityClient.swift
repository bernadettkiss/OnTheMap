//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Bernadett Kiss on 6/26/18.
//  Copyright © 2018 Bernadett Kiss. All rights reserved.
//

import Foundation

struct Account {
    let key: String?
    let registered: Bool?
    
    init(dictionary: [String: AnyObject]) {
        key = dictionary[UdacityClient.JSONResponseKeys.Key] as? String
        registered = dictionary[UdacityClient.JSONResponseKeys.Registered] as? Bool
    }
}

struct Session {
    let id: String?
    let expiration: String?
    
    init(dictionary: [String: AnyObject]) {
        id = dictionary[UdacityClient.JSONResponseKeys.Id] as? String
        expiration = dictionary[UdacityClient.JSONResponseKeys.Expiration] as? String
    }
}

class UdacityClient {
    
    static let shared = UdacityClient()
    var account: Account?
    var session: Session?
    
    func login(withEmail email: String, andPassword password: String, completion: @escaping (_ success: Bool) -> Void) {
        let jsonBody = "{\"\(UdacityClient.JSONBodyKeys.Udacity)\": {\"\(UdacityClient.JSONBodyKeys.Username)\": \"\(email)\", \"\(UdacityClient.JSONBodyKeys.Password)\": \"\(password)\"}}"
        
        NetworkManager.shared.request(client: .udacity, urlParameters: nil, httpMethod: .post, headerParameters: nil, jsonBody: jsonBody) { (results, error) in
            if error != nil {
                completion(false)
                return
            } else {
                if let account = results?[UdacityClient.JSONResponseKeys.Account] as? [String: AnyObject] {
                    self.account = Account(dictionary: account)
                }
                if let session = results?[UdacityClient.JSONResponseKeys.Session] as? [String: AnyObject] {
                    self.session = Session(dictionary: session)
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
}
