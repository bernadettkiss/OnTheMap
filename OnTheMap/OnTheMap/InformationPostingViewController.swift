//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Bernadett Kiss on 6/21/18.
//  Copyright © 2018 Bernadett Kiss. All rights reserved.
//

import UIKit
import CoreLocation

class InformationPostingViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    
    var mapString: String?
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var mediaURL: String?
    let geoCoder = CLGeocoder()
    var activityIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackBarButton()
        locationTextField.delegate = self
        linkTextField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func findLocationButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        guard let location = locationTextField.text, locationTextField.text != "", let urlString = linkTextField.text, linkTextField.text != "" else {
            showAlert(forAppError: .emptyLocation)
            return
        }
        if verifyURL(urlString: urlString) {
            self.mediaURL = urlString
        } else {
            showAlert(forAppError: .incorrectLink)
            return
        }
        
        geoCoder.geocodeAddressString(location) { (placemarks, error) in
            self.addActivityIndicator()
            guard let placemarks = placemarks, let location = placemarks.first?.location else {
                self.removeActivityIndicator()
                self.showAlert(forAppError: .geocodingFailure)
                return
            }
            self.mapString = self.locationTextField.text
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
            self.removeActivityIndicator()
            self.performSegue(withIdentifier: SegueIdentifier.toLocationConfirmation.rawValue, sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.toLocationConfirmation.rawValue {
            guard let locationConfirmationViewController = segue.destination as? LocationConfirmationViewController else {
                return
            }
            locationConfirmationViewController.mapString = mapString
            locationConfirmationViewController.latitude = latitude
            locationConfirmationViewController.longitude = longitude
            locationConfirmationViewController.mediaURL = mediaURL
        }
    }
    
    private func configureBackBarButton() {
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "icon_back-arrow")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "icon_back-arrow")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func verifyURL(urlString: String) -> Bool {
        if let url = URL(string: urlString) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
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
    
    // MARK: - UITextFieldDelegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
