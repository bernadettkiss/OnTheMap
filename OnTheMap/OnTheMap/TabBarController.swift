//
//  TabBarController.swift
//  OnTheMap
//
//  Created by Bernadett Kiss on 6/15/18.
//  Copyright © 2018 Bernadett Kiss. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    var activityIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
        loadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        if UserAccount.shared.location != nil {
            let alertController = UIAlertController(title: "", message: "Would you like to overwrite your current location?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { (alert: UIAlertAction) in
                self.performSegue(withIdentifier: SegueIdentifier.toInformationPosting.rawValue, sender: nil)
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alertController, animated: true)
        } else {
            self.performSegue(withIdentifier: SegueIdentifier.toInformationPosting.rawValue, sender: nil)
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        UdacityClient.shared.logout { success in
            DispatchQueue.main.async {
                if success {
                    self.performSegue(withIdentifier: SegueIdentifier.unwindToLogin.rawValue, sender: self)
                } else {
                    self.showAlert(forAppError: .logoutError)
                }
            }
        }
    }
    
    private func loadData() {
        addActivityIndicator()
        ParseClient.shared.retrieveData() { (success) in
            DispatchQueue.main.async {
                self.removeActivityIndicator()
                if !success {
                    self.showAlert(forAppError: .noData)
                } else {
                    NotificationCenter.default.post(name: Notification.Name("StudentLocationsDidLoad"), object: nil)
                }
            }
        }
    }
    
    private func showAlert(forAppError appError: AppError) {
        let message = appError.rawValue
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    private func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator?.center = CGPoint(x: (UIScreen.main.bounds.width / 2) - ((activityIndicator?.frame.width)! / 2), y: (UIScreen.main.bounds.height / 2) - ((activityIndicator?.frame.height)! / 2))
        activityIndicator?.activityIndicatorViewStyle = .whiteLarge
        activityIndicator?.color = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        activityIndicator?.startAnimating()
        view.addSubview(activityIndicator!)
    }
    
    private func removeActivityIndicator() {
        if activityIndicator != nil {
            activityIndicator?.removeFromSuperview()
        }
    }
}
