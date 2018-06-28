//
//  StudentInformationViewController.swift
//  OnTheMap
//
//  Created by Bernadett Kiss on 6/21/18.
//  Copyright © 2018 Bernadett Kiss. All rights reserved.
//

import UIKit

class StudentInformationViewController: UIViewController {
    
    var spinner: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(studentInformationWillLoad(_:)), name: StudentLocations.willLoad.notification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(studentInformationDidLoad(_:)), name: StudentLocations.didLoad.notification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(studentInformationCouldNotLoad(_:)), name: StudentLocations.couldNotLoad.notification, object: nil)
    }
    
    @objc func studentInformationWillLoad(_ notification: Notification) {
        self.addSpinner()
    }
    
    @objc func studentInformationDidLoad(_ notification: Notification) {
        DispatchQueue.main.async {
            self.refresh()
            self.removeSpinner()
        }
    }
    
    @objc func studentInformationCouldNotLoad(_ notification: Notification) {
        DispatchQueue.main.async {
            self.removeSpinner()
        }
    }
    
    func refresh() {}
    
    private func addSpinner() {
        spinner = UIActivityIndicatorView()
        spinner?.center = CGPoint(x: (UIScreen.main.bounds.width / 2) - ((spinner?.frame.width)! / 2), y: (UIScreen.main.bounds.height / 2) - ((spinner?.frame.height)! / 2))
        spinner?.activityIndicatorViewStyle = .whiteLarge
        spinner?.color = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        spinner?.startAnimating()
        view.addSubview(spinner!)
    }
    
    private func removeSpinner() {
        if spinner != nil {
            spinner?.removeFromSuperview()
        }
    }
}
