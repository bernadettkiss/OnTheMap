//
//  UserAccount.swift
//  OnTheMap
//
//  Created by Bernadett Kiss on 7/3/18.
//  Copyright © 2018 Bernadett Kiss. All rights reserved.
//

import Foundation

class UserAccount {
    
    static let shared = UserAccount()
    
    public private(set) var key: String?
    public private(set) var firstName = "Jane"
    public private(set) var lastName = "Doe"
    public private(set) var location: StudentInformation?
    
    func setAccountKey(_ accountKey: String?) {
        self.key = accountKey
    }
    
    func setStudentLocation(_ location: StudentInformation?) {
        self.location = location
    }
}
