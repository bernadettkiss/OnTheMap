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
    
    private var account: Account?
    private var session: Session?
    
    func login(withEmail email: String, andPassword password: String, completion: @escaping (_ success: Bool, _ error: AppError?) -> Void) {
        let jsonBody = "{\"\(UdacityClient.JSONBodyKeys.Udacity)\": {\"\(UdacityClient.JSONBodyKeys.Username)\": \"\(email)\", \"\(UdacityClient.JSONBodyKeys.Password)\": \"\(password)\"}}"
        
        NetworkManager.shared.request(client: .udacity, pathExtension: nil, urlParameters: nil, httpMethod: .post, headerParameters: nil, jsonBody: jsonBody) { (results, error) in
            if error != nil {
                completion(false, .networkFailure)
                return
            } else {
                if let account = results?[UdacityClient.JSONResponseKeys.Account] as? [String: AnyObject] {
                    self.account = Account(dictionary: account)
                    guard let registered = self.account?.registered, registered == true else {
                        completion(false, .incorrectCredentials)
                        return
                    }
                    UserAccount.shared.setAccountKey(self.account?.key)
                }
                if let session = results?[UdacityClient.JSONResponseKeys.Session] as? [String: AnyObject] {
                    self.session = Session(dictionary: session)
                    completion(true, nil)
                } else {
                    completion(false, .incorrectCredentials)
                }
            }
        }
    }
    
    func logout(completion: @escaping (_ success: Bool) -> Void) {
        NetworkManager.shared.request(client: .udacity, pathExtension: nil, urlParameters: nil, httpMethod: .delete, headerParameters: nil, jsonBody: nil) { (results, error) in
            if error != nil {
                completion(false)
            } else if let _ = results?[UdacityClient.JSONResponseKeys.Session] as? [String: AnyObject] {
                self.account = nil
                self.session = nil
                UserAccount.shared.setAccountKey(nil)
                UserAccount.shared.setStudentLocation(nil)
                ParseClient.shared.clearStudentInformationArray()
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
