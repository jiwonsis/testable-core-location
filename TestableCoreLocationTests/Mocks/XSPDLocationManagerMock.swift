//
//  XSPDLocationManagerMock.swift
//  TestableCoreLocationTests
//
//  Created by Scott moon on 09/11/2017.
//  Copyright © 2017 Scott moon. All rights reserved.
//

import Foundation
@testable import TestableCoreLocation
import CoreLocation

class XSPDLocationManagerMock: XSPDLocationManager {
    
    weak var delegate: XSPDLocationManagerDelegate?
    weak var authorizationDelegate: XSPDLocationManagerAuthorizationDelegate?
    
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    
    var requestedWhenInAuthorization = false
    var didStartUpdatingLocation = false
    var didStopUpdatingLocation = false
    
    func requestWhenInUseAuthorization() {
        requestedWhenInAuthorization = true
    }
    
    func startUpdatingLocation() {
        didStartUpdatingLocation = true
    }
    
    func stopUpdatingLocation() {
        didStopUpdatingLocation = true
    }
}
