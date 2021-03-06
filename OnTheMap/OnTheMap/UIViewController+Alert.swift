//
//  UIViewController+Alert.swift
//  OnTheMap
//
//  Created by Bernadett Kiss on 7/7/18.
//  Copyright © 2018 Bernadett Kiss. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(forAppError appError: AppError) {
        let message = appError.rawValue
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
