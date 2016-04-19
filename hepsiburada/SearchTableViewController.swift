//
//  SearchTableViewController.swift
//  hepsiburada
//
//  Created by Mertcan Yigin on 4/18/16.
//  Copyright © 2016 Mertcan Yigin. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit
import QuadratTouch

typealias JSONParameters = [String: AnyObject]

class SearchTableViewController: UITableViewController,  UISearchBarDelegate, CLLocationManagerDelegate {
    var session: Session!
    var location: CLLocation!
    var venues: [JSONParameters]!
    var currentTask: Task?
    let distanceFormatter = MKDistanceFormatter()
    var locationManager : CLLocationManager!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.session = Session.sharedSession()
        self.session.logger = ConsoleLogger()
        
        self.definesPresentationContext = true
        self.searchBar.delegate = self
        
        self.locationManager = CLLocationManager()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        if status == .NotDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        } else if status == CLAuthorizationStatus.AuthorizedWhenInUse
            || status == CLAuthorizationStatus.AuthorizedAlways {
            self.locationManager.startUpdatingLocation()
        } else {
            showNoPermissionsAlert()
        }
    }
    
    func showNoPermissionsAlert() {
        let alertController = UIAlertController(title: "No permission",
                                                message: "In order to work, app needs your location", preferredStyle: .Alert)
        let openSettings = UIAlertAction(title: "Open settings", style: .Default, handler: {
            (action) -> Void in
            let URL = NSURL(string: UIApplicationOpenSettingsURLString)
            UIApplication.sharedApplication().openURL(URL!)
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController.addAction(openSettings)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showErrorAlert(error: NSError) {
        let alertController = UIAlertController(title: "Error",
                                                message:error.localizedDescription, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: {
            (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    

    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // Strip out all the leading and trailing spaces.
        let whitespaceCharacterSet = NSCharacterSet.whitespaceCharacterSet()
        let strippedString = searchText.stringByTrimmingCharactersInSet(whitespaceCharacterSet)
        
        if self.location == nil {
            return
        }
        
        self.currentTask?.cancel()
        var parameters = [Parameter.query:strippedString]
        parameters += self.location.parameters()
        self.currentTask = session.venues.search(parameters) {
            (result) -> Void in
            if let response = result.response {
                self.venues = response["venues"] as? [JSONParameters]
                self.tableView.reloadData()
            }
        }
        self.currentTask?.start()

    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell")

        let venue = venues[indexPath.row]
        if let venueLocation = venue["location"] as? JSONParameters {
            var detailText = ""
            if let distance = venueLocation["distance"] as? CLLocationDistance {
                detailText = distanceFormatter.stringFromDistance(distance)
            }
            if let address = venueLocation["address"] as? String {
                detailText = detailText +  " - " + address
            }
            cell!.detailTextLabel?.text = detailText
        }
        cell!.textLabel?.text = venue["name"] as? String
        return cell!
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let venues = self.venues {
            return venues.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
