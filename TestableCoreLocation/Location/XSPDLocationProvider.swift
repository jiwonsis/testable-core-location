//
//  XSPDLocationProvider.swift
//  TestableCoreLocation
//
//  Created by Scott moon on 03/11/2017.
//  Copyright © 2017 Scott moon. All rights reserved.
//

import Foundation
import CoreLocation
import Swinject

protocol XSPDLocationConsumer: class {
    func consumeLocation(_ location: CLLocation)
}

protocol XSPDLocationProvider: class {
    func add(_ consumer: XSPDLocationConsumer)
}

class XSPDDefaultLocationProvider {
    let locationManager: XSPDLocationManager
    let locationAuthorization: XSPDLocationAuthorization
    
    var locationConsumers = [XSPDLocationConsumer]()
    
    init(locationManger: XSPDLocationManager, locationAuthorization: XSPDLocationAuthorization) {
        self.locationManager = locationManger
        self.locationAuthorization = locationAuthorization
        
        locationManger.delegate = self
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
    }
}

private extension XSPDDefaultLocationProvider {
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(forName: .XSPDLocationAuthorized,
                                               object: locationAuthorization,
                                               queue: .main) { [weak self](_) in
            self?.locationManager.startUpdatingLocation()
        }
    }
}

extension XSPDDefaultLocationProvider: XSPDLocationProvider {
    func add(_ consumer: XSPDLocationConsumer) {
        locationConsumers.append(consumer)
    }
}

extension XSPDDefaultLocationProvider: XSPDLocationManagerDelegate {
    
    func locationManager(_ manager: XSPDLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let sortedLocations = locations.sorted { (lhs, rhs) -> Bool in
            return lhs.timestamp.compare(rhs.timestamp) == .orderedDescending
        }
        
        guard let location = sortedLocations.first else { return }
        for consumer in locationConsumers {
            consumer.consumeLocation(location)
        }
    }
}

class XSPDLocationProviderAssembly: Assembly {
    func assemble(container: Container) {
        container.register(XSPDLocationProvider.self, factory: { r in
            
            let locationManger = r.resolve(XSPDLocationManager.self)!
            let locationAuthorization = r.resolve(XSPDLocationAuthorization.self)!
            
            return XSPDDefaultLocationProvider.init(locationManger: locationManger, locationAuthorization: locationAuthorization)
            
        }).inObjectScope(.weak)
    }
}


