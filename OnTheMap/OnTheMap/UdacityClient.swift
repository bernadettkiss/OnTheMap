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

struct UdacityError {
    let error: String?
    let status: Int?
    
    init(dictionary: [String: AnyObject]) {
        error = dictionary[UdacityClient.JSONResponseKeys.Error] as? String
        status = dictionary[UdacityClient.JSONResponseKeys.Status] as? Int
    }
}

class UdacityClient {
    
    static let shared = UdacityClient()
    
    var account: Account?
    var session: Session?
    var error: UdacityError?
    
    func login(withEmail email: String, andPassword password: String, completion: @escaping (_ success: Bool, _ error: AppError?) -> Void) {
        let jsonBody = "{\"\(UdacityClient.JSONBodyKeys.Udacity)\": {\"\(UdacityClient.JSONBodyKeys.Username)\": \"\(email)\", \"\(UdacityClient.JSONBodyKeys.Password)\": \"\(password)\"}}"
        
        NetworkManager.shared.request(client: .udacity, urlParameters: nil, httpMethod: .post, headerParameters: nil, jsonBody: jsonBody) { (results, error) in
            if error != nil {
                completion(false, .networkFailure)
                return
            } else {
                if let error = results as? [String: AnyObject] {
                    self.error = UdacityError(dictionary: error)
                    if self.error?.status == 403 {
                        completion(false, .incorrectCredentials)
                        return
                    }
                }
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
    
    func logout(completion: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        NetworkManager.shared.request(client: .udacity, urlParameters: nil, httpMethod: .delete, headerParameters: nil, jsonBody: nil) { (results, error) in
            if error != nil {
                completion(false, error)
                return
            } else {
                self.account = nil
                self.session = nil
                self.error = nil
                UserAccount.shared.setAccountKey(nil)
                completion(true, nil)
            }
        }
    }
}
