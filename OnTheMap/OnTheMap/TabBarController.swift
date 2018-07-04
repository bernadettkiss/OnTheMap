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
    
    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
        ParseClient.shared.retrieveData { (success, error) in
            
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        if UserAccount.shared.location != nil {
            let alertController = UIAlertController(title: nil, message: "Would you like to overwrite your current location?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Overwrite", style: .default))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
            self.present(alertController, animated: true)
        }
        performSegue(withIdentifier: SegueIdentifier.toInformationPosting.rawValue, sender: nil)
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        UdacityClient.shared.logout { (success, error) in
            if success {
                ParseClient.shared.clearStudentInformationArray()
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: SegueIdentifier.unwindToLogin.rawValue, sender: self)
                }
            } else {
                let alertController = UIAlertController(title: nil, message: "Could not log out", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default))
                DispatchQueue.main.async {
                    self.present(alertController, animated: true)
                }
            }
        }
    }
}
