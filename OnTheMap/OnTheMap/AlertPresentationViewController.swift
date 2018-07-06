//
//  AlertPresentationViewController.swift
//  OnTheMap
//
//  Created by Bernadett Kiss on 7/6/18.
//  Copyright © 2018 Bernadett Kiss. All rights reserved.
//

import UIKit

class AlertPresentationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showAlert(forAppError appError: AppError) {
        let message = appError.rawValue
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
