//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Bernadett Kiss on 6/21/18.
//  Copyright © 2018 Bernadett Kiss. All rights reserved.
//

import UIKit
import CoreLocation

class InformationPostingViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    
    var mapString: String?
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var mediaURL: String?
    let geoCoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackBarButton()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationButtonPressed(_ sender: UIButton) {
        guard let location = locationTextField.text, locationTextField.text != "" else {return}
        guard let urlString = linkTextField.text, linkTextField.text != "" else {return}
        if verifyURL(urlString: urlString) {
            self.mediaURL = urlString
        } else {
            return
        }
        
        geoCoder.geocodeAddressString(location) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location else {
                return
            }
            self.mapString = self.locationTextField.text
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
            
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
}
