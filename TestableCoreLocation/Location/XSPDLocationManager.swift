//
//  XSPDLocationManager.swift
//  TestableCoreLocation
//
//  Created by Scott moon on 01/11/2017.
//  Copyright © 2017 Scott moon. All rights reserved.
//

import Foundation
import CoreLocation
import Swinject

protocol XSPDLocationManagerDelegate: class {
    
    func locationManager(_ manager: XSPDLocationManager, didUpdateLocations locations: [CLLocation])
    
}

protocol XSPDLocationManagerAuthorizationDelegate: class {
    
    func locationManager(_ manager: XSPDLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
}

protocol XSPDLocationManager: class {
    
    //Delegates
    var delegate: XSPDLocationManagerDelegate? { get set }
    var authorizationDelegate: XSPDLocationManagerAuthorizationDelegate? { get set }
    
    // CLLocation -> authorizationStatus Convert
    var authorizationStatus: CLAuthorizationStatus { get }
    
    // CLLocation Overloading Methods
    func requestWhenInUseAuthorization()
    func startUpdatingLocation()
    func stopUpdatingLocation()
    
}

class XSPDLocationManagerProxy: NSObject {
    weak var delegate: XSPDLocationManagerDelegate?
    weak var authorizationDelegate: XSPDLocationManagerAuthorizationDelegate?
    
    let locationManager: CLLocationManager
    
    // D.I.P
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        
        super.init()
        
        locationManager.delegate = self
    }
}

extension XSPDLocationManagerProxy: XSPDLocationManager {
    var authorizationStatus: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

extension XSPDLocationManagerProxy: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        delegate?.locationManager(self, didUpdateLocations: locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationDelegate?.locationManager(self, didChangeAuthorization: status)
    }
    
}

class XSPDLocationManagerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(XSPDLocationManager.self, factory: { (r) in
            let locationManager = CLLocationManager()
            return XSPDLocationManagerProxy(locationManager: locationManager)
        }).inObjectScope(.weak)
    }
}
