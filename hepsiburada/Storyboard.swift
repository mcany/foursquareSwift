//
//  Storyboard.swift
//  hepsiburada
//
//  Created by Mertcan Yigin on 4/19/16.
//  Copyright © 2016 Mertcan Yigin. All rights reserved.
//

import UIKit

class Storyboard: UIStoryboard {
    class func create(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(name)
    }
}
