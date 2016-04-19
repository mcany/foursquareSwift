//
//  AppDelegate.swift
//  hepsiburada
//
//  Created by Mertcan Yigin on 4/18/16.
//  Copyright © 2016 Mertcan Yigin. All rights reserved.
//

import UIKit
import QuadratTouch


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        self.window?.tintColor = UIColor(red: 71.0/255.0, green: 57.0/255.0, blue: 151.0/255.0, alpha: 1.0)
        
        let client = Client(clientID: "5P1OVCFK0CCVCQ5GBBCWRFGUVNX5R4WGKHL2DGJGZ32FDFKT",
                            clientSecret: "UPZJO0A0XL44IHCD1KQBMAYGCZ45Z03BORJZZJXELPWHPSAR",
                            redirectURL: "testapp123://foursquare")
        var configuration = Configuration(client:client)
        configuration.shouldControllNetworkActivityIndicator = true
        Session.setupSharedSessionWithConfiguration(configuration)
        return true
    }

    func application(application: UIApplication, openURL url: NSURL,
                     sourceApplication: String?, annotation: AnyObject) -> Bool {
        return Session.sharedSession().handleURL(url)
    }



}

