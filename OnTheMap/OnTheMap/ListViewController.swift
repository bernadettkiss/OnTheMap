//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Bernadett Kiss on 6/12/18.
//  Copyright © 2018 Bernadett Kiss. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - TableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParseClient.shared.studentInformationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentInformation", for: indexPath) as UITableViewCell?
        let student = ParseClient.shared.studentInformationArray[indexPath.row]
        
        cell?.textLabel?.text = "\(student.firstName ?? "First name") \(student.lastName ?? "Last name")"
        cell?.detailTextLabel?.text = student.mediaURL ?? "No URL"
        cell?.imageView?.image = UIImage(named: "icon_pin")
        return cell!
    }
    
    // MARK: - TableViewDelegate methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let mediaURL = ParseClient.shared.studentInformationArray[indexPath.row].mediaURL {
            if let url = URL(string: mediaURL) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
