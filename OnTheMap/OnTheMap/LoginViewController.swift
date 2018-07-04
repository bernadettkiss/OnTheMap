//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Bernadett Kiss on 6/12/18.
//  Copyright © 2018 Bernadett Kiss. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, emailTextField.text != "" else {
            showAlert(forAppError: .emptyCredentials)
            return
        }
        guard let password = passwordTextField.text, passwordTextField.text != "" else {
            showAlert(forAppError: .emptyCredentials)
            return
        }
        UdacityClient.shared.login(withEmail: email, andPassword: password) { (success, error) in
            if error == AppError.incorrectCredentials {
                DispatchQueue.main.async {
                    self.showAlert(forAppError: .incorrectCredentials)
                }
            }
            if error == AppError.networkFailure {
                DispatchQueue.main.async {
                    self.showAlert(forAppError: .networkFailure)
                }
            }
            if success {
                ParseClient.shared.getUserLocation()
                ParseClient.shared.retrieveData() { (success, error) in
                    if success {
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: SegueIdentifier.toStudentInformation.rawValue, sender: nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showAlert(forAppError: .noData)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        guard let url = URL(string: udacitySignUpURL) else {return}
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func unwindToLoginScreen(segue: UIStoryboardSegue) {}
    
    private func showAlert(forAppError appError: AppError) {
        var message = String()
        switch appError {
        case .emptyCredentials:
            message = "Please enter your email and password"
        case .incorrectCredentials:
            message = "Please enter valid credentials"
        case .networkFailure:
            message = "There was a problem with the network. Please try again"
        case .noData:
            message = "Could not retrieve data from the server"
        default:
            message = "An error has occured"
        }
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
