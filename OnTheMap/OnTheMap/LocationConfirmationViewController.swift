//
//  LocationConfirmationViewController.swift
//  OnTheMap
//
//  Created by Bernadett Kiss on 6/22/18.
//  Copyright © 2018 Bernadett Kiss. All rights reserved.
//

import UIKit
import MapKit

class LocationConfirmationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var mapString: String?
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var mediaURL: String?
    let regionRadius: Double = 1000
    var annotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.removeAnnotation(annotation)
        createAnnotation()
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
//        guard let mapString = mapString, let mediaURL = mediaURL, let latitude = latitude, let longitude = longitude else {
//            return
//        }
//        UserDataService.shared.setLocation(mapString: mapString, mediaURL: mediaURL, latitude: String(latitude), longitude: String(longitude))
//        
//        ParseClient.shared.postStudentLocation { (result, error) in
//            if error != nil {
//                UserDataService.shared.setLocation(mapString: "", mediaURL: "", latitude: "", longitude: "")
//            }
//        }
//        dismiss(animated: true, completion: nil)
    }
    
    func createAnnotation() {
        if let latitude = latitude, let longitude = longitude {
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius * 2.0, regionRadius * 2.0)
            mapView.setRegion(coordinateRegion, animated: true)
            annotation.coordinate = coordinate
            mapView.addAnnotation(self.annotation)
            mapView.reloadInputViews()
        }
    }
    
    // MARK: - MKMapViewDelegate methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pinView!.canShowCallout = true
            pinView!.pinTintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
}
