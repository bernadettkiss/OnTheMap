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
        guard let email = emailTextField.text, emailTextField.text != "" else {return}
        guard let password = passwordTextField.text, passwordTextField.text != "" else {return}
        UdacityClient.shared.login(withEmail: email, andPassword: password) { (success) in
            if success {
                ParseClient.shared.getStudentLocations() { (studentInformationArray, error) in
                    if let studentInformationArray = studentInformationArray {
                        ParseClient.shared.studentInformationArray = studentInformationArray
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: SegueIdentifier.toStudentInformation.rawValue, sender: nil)
                        }
                    } else {
                        print(error ?? "Could not get studentInformationArray")
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
    
}
