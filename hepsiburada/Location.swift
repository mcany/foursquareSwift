//
//  Location.swift
//  hepsiburada
//
//  Created by Mertcan Yigin on 4/19/16.
//  Copyright © 2016 Mertcan Yigin. All rights reserved.
//

import CoreLocation
import QuadratTouch


extension CLLocation {
    func parameters() -> Parameters {
        let ll      = "\(self.coordinate.latitude),\(self.coordinate.longitude)"
        let llAcc   = "\(self.horizontalAccuracy)"
        let alt     = "\(self.altitude)"
        let altAcc  = "\(self.verticalAccuracy)"
        let parameters = [
            Parameter.ll:ll,
            Parameter.llAcc:llAcc,
            Parameter.alt:alt,
            Parameter.altAcc:altAcc
        ]
        return parameters
    }
}
