//
//  XSPDLocationAuthorization.swift
//  TestableCoreLocation
//
//  Created by Scott moon on 03/11/2017.
//  Copyright © 2017 Scott moon. All rights reserved.
//

import Foundation
import CoreLocation
import Swinject

extension NSNotification.Name {
    static let XSPDLocationAuthorized =
        NSNotification.Name(rawValue: "NSNotification.Name.XSPDLocationAuthorized")
}

protocol XSPDLocationAuthorizationDelegate: class {
    func authorizationDenied(for locationAuthorization: XSPDLocationAuthorization)
}

protocol XSPDLocationAuthorization: class {
    var delegate: XSPDLocationAuthorizationDelegate? { get set }
    
    func checkAuthorization()
}

class XSPDDefaultLocationAuthorization {
    weak var delegate: XSPDLocationAuthorizationDelegate?
    let locationManager: XSPDLocationManager
    
    init(locationManger: XSPDLocationManager) {
        self.locationManager = locationManger
        locationManger.authorizationDelegate = self
    }
}

extension XSPDDefaultLocationAuthorization: XSPDLocationAuthorization {
    
    func checkAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
}

extension XSPDDefaultLocationAuthorization: XSPDLocationManagerAuthorizationDelegate {
    func locationManager(_ manager: XSPDLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            NotificationCenter.default.post(name: .XSPDLocationAuthorized, object: self)
        case .denied, .restricted:
            delegate?.authorizationDenied(for: self)
        default: break
        }
    }
}

class XSPDLocationAuthorizationAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(XSPDLocationAuthorization.self, factory: { r in
            let locationManager = r.resolve(XSPDLocationManager.self)!
            return XSPDDefaultLocationAuthorization.init(locationManger: locationManager)
        }).inObjectScope(.weak)
    }
    
}
