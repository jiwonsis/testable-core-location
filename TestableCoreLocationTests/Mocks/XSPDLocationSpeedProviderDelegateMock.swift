//
//  XSPDLocationSpeedProviderDelegateMock.swift
//  TestableCoreLocationTests
//
//  Created by Scott moon on 09/11/2017.
//  Copyright © 2017 Scott moon. All rights reserved.
//

import Foundation
@testable import TestableCoreLocation
import CoreLocation

class XSPDLocationSpeedProviderDelegateMock: XSPDLocationSpeedProviderDelegate {
    
    var lastSpeed : CLLocationSpeed?
    func didUpdate(speed: CLLocationSpeed) {
        lastSpeed = speed
    }
    
}
