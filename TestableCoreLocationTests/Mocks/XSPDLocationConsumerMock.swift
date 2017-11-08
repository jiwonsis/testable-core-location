//
//  XSPDLocationConsumerMock.swift
//  TestableCoreLocationTests
//
//  Created by Scott moon on 09/11/2017.
//  Copyright © 2017 Scott moon. All rights reserved.
//

import Foundation
@testable import TestableCoreLocation
import CoreLocation

class XSPDLocationConsumerMock: XSPDLocationConsumer {
    
    var lastLocation : CLLocation?
    
    func consumeLocation(_ location: CLLocation) {
        lastLocation = location
    }
}
