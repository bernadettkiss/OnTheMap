//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Bernadett Kiss on 6/12/18.
//  Copyright © 2018 Bernadett Kiss. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(studentInformationDidLoad(_:)), name: Notification.Name("StudentLocationsDidLoad"), object: nil)
    }
    
    @objc func studentInformationDidLoad(_ notification: Notification) {
        mapView.removeAnnotations(annotations)
        annotations.removeAll()
        createAnnotationFor(studentInformationArray: ParseClient.shared.studentInformationArray)
    }
    
    func createAnnotationFor(studentInformationArray: [StudentInformation]) {
        for studentInformation in studentInformationArray {
            if let latitudeString = studentInformation.latitude, let longitudeString = studentInformation.longitude {
                let latitude = CLLocationDegrees(latitudeString)
                let longitude = CLLocationDegrees(longitudeString)
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(studentInformation.firstName ?? "First name") \(studentInformation.lastName ?? "Last name")"
                annotation.subtitle = studentInformation.mediaURL ?? "No URL"
                annotations.append(annotation)
            }
        }
        mapView.addAnnotations(self.annotations)
        mapView.reloadInputViews()
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let mediaURL = view.annotation?.subtitle {
                if let url = URL(string: mediaURL!) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
}
