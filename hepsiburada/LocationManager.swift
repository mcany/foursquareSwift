//
//  LocationManager.swift
//  hepsiburada
//
//  Created by Mertcan Yigin on 4/19/16.
//  Copyright © 2016 Mertcan Yigin. All rights reserved.
//

import Foundation
import CoreLocation



extension SearchTableViewController {

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .Denied || status == .Restricted {
            showNoPermissionsAlert()
        } else {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        // Process error.
        // kCLErrorDomain. Not localized.
        showErrorAlert(error)
    }
    
    func locationManager(manager: CLLocationManager,
                         didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        self.locationManager.stopUpdatingLocation()
        self.location = newLocation
    }
}