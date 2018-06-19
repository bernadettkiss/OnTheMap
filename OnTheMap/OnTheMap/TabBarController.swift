//
//  TabBarController.swift
//  OnTheMap
//
//  Created by Bernadett Kiss on 6/15/18.
//  Copyright © 2018 Bernadett Kiss. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStudentInformationArray()
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
        getStudentInformationArray()
    }
    
    private func getStudentInformationArray() {
        ParseClient.shared.getStudentLocations() { (studentInformationArray, error) in
            if let studentInformationArray = studentInformationArray {
                ParseClient.shared.studentInformationArray = studentInformationArray
            } else {
                print(error ?? "Could not get studentInformationArray")
            }
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        ParseClient.shared.clearStudentInformationArray()
        performSegue(withIdentifier: "unwindToLoginScreen", sender: self)
    }
}