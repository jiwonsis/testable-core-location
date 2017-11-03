//
//  XSPDLocationSpeedProvider.swift
//  TestableCoreLocation
//
//  Created by Scott moon on 03/11/2017.
//  Copyright © 2017 Scott moon. All rights reserved.
//

import Foundation
import CoreLocation

protocol XSPDSpeedProviderDelegate: class {
    
    func didUpdate(speed: CLLocationSpeed)
}

protocol XSPDLoationSpeedProvider: class {
    var delegate: XSPDSpeedProviderDelegate? { get set }
}

class XSPDDefaultLoationSpeedProvider {
    weak var delegate: XSPDSpeedProviderDelegate?
    let locationProvider: XSPDLocationProvider
    
    init(locationProvider: XSPDLocationProvider) {
        self.locationProvider = locationProvider
        locationProvider.add(self)
    }
}

extension XSPDDefaultLoationSpeedProvider: XSPDLoationSpeedProvider {
    
}

extension XSPDDefaultLoationSpeedProvider: XSPDLocationConsumer {
    
    func consumeLocation(_ location: CLLocation) {
        let speed = max(location.speed, 0)
        
        delegate?.didUpdate(speed: speed)
    }
}
