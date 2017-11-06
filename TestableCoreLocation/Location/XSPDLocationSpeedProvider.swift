//
//  XSPDLocationSpeedProvider.swift
//  TestableCoreLocation
//
//  Created by Scott moon on 03/11/2017.
//  Copyright © 2017 Scott moon. All rights reserved.
//

import Foundation
import CoreLocation
import Swinject

protocol XSPDSpeedProviderDelegate: class {
    
    func didUpdate(speed: CLLocationSpeed)
}

protocol XSPDLocationSpeedProvider: class {
    var delegate: XSPDSpeedProviderDelegate? { get set }
}

class XSPDDefaultLocationSpeedProvider {
    weak var delegate: XSPDSpeedProviderDelegate?
    let locationProvider: XSPDLocationProvider
    
    init(locationProvider: XSPDLocationProvider) {
        self.locationProvider = locationProvider
        locationProvider.add(self)
    }
}

extension XSPDDefaultLocationSpeedProvider: XSPDLocationSpeedProvider {
    
}

extension XSPDDefaultLocationSpeedProvider: XSPDLocationConsumer {
    
    func consumeLocation(_ location: CLLocation) {
        let speed = max(location.speed, 0)
        
        delegate?.didUpdate(speed: speed)
    }
}

class XSPDLocationSpeedProviderAssembly: Assembly {
    func assemble(container: Container) {
        container.register(XSPDLocationSpeedProvider.self, factory: { r in
            
            let locationProvider = r.resolve(XSPDLocationProvider.self)!
            
            return XSPDDefaultLocationSpeedProvider.init(locationProvider: locationProvider)
            
        }).inObjectScope(.weak)
    }
}
