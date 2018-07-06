//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Bernadett Kiss on 6/12/18.
//  Copyright © 2018 Bernadett Kiss. All rights reserved.
//

import UIKit

class LoginViewController: AlertPresentationViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, emailTextField.text != "", let password = passwordTextField.text, passwordTextField.text != "" else {
            showAlert(forAppError: .emptyCredentials)
            return
        }
        UdacityClient.shared.login(withEmail: email, andPassword: password) { (success, error) in
            DispatchQueue.main.async {
                if let error = error {
                    self.showAlert(forAppError: error)
                }
                if success {
                    ParseClient.shared.getUserLocation()
                    self.performSegue(withIdentifier: SegueIdentifier.toStudentInformation.rawValue, sender: nil)
                }
            }
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        guard let url = URL(string: udacitySignUpURL) else {return}
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func unwindToLoginScreen(segue: UIStoryboardSegue) {}
    
    // MARK: - UITextFieldDelegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
