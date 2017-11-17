//
//  XSPDLocationSpeedChecker.swift
//  TestableCoreLocation
//
//  Created by Scott moon on 03/11/2017.
//  Copyright © 2017 Scott moon. All rights reserved.
//

import Foundation
import CoreLocation
import Swinject


protocol XSPDLocationSpeedCheckerDelegate: class {
    
    func exceedingMaximumSpeedChanged(for speedChecker: XSPDLocationSpeedChecker)
}

protocol XSPDLocationSpeedChecker: class {
    
    var delegate: XSPDLocationSpeedCheckerDelegate? { get set }
    
    var maximumSpeed: CLLocationSpeed? { get set }
    var isExceedingMaximumSpeed: Bool { get }
}

class XSPDDefaultLocationSpeedChecker {
    weak var delegate: XSPDLocationSpeedCheckerDelegate?
    var maximumSpeed: CLLocationSpeed? {
        didSet {
            checkIfSpeedExceeded()
        }
    }
    var isExceedingMaximumSpeed = false {
        didSet {
            if oldValue != isExceedingMaximumSpeed {
                delegate?.exceedingMaximumSpeedChanged(for: self)
            }
        }
    }
    
    var lastLocation: CLLocation? {
        didSet {
            checkIfSpeedExceeded()
        }
    }
    let locationProvier: XSPDLocationProvider
    
    init(locationProvier: XSPDLocationProvider) {
        self.locationProvier = locationProvier
        locationProvier.add(self)
    }
}

private extension XSPDDefaultLocationSpeedChecker {
    
    func checkIfSpeedExceeded() {
        if let maximumSpeed = maximumSpeed, let location = lastLocation {
            isExceedingMaximumSpeed = location.speed > maximumSpeed
        } else {
            isExceedingMaximumSpeed = false
        }
    }
}

extension XSPDDefaultLocationSpeedChecker: XSPDLocationSpeedChecker {
    
}

extension XSPDDefaultLocationSpeedChecker: XSPDLocationConsumer {
    func consumeLocation(_ location: CLLocation) {
        lastLocation = location
    }
}

class XSPDLocationSpeedCheckerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(XSPDLocationSpeedChecker.self, factory: { r in
            let locationProvier = r.resolve(XSPDLocationProvider.self)!
            return XSPDDefaultLocationSpeedChecker.init(locationProvier: locationProvier)
        }).inObjectScope(.weak)
    }
}
