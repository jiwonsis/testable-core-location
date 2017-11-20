//
//  XSPDLocationManagerUITestMock.swift
//  TestableCoreLocation
//
//  Created by Scott moon on 20/11/2017.
//  Copyright © 2017 Scott moon. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import Swinject

class XSPDLocationManagerUITestMock {
    
    weak var delegate: XSPDLocationManagerDelegate?
    weak var authorizationDelegate: XSPDLocationManagerAuthorizationDelegate?
    
    var authorizationStatus: CLAuthorizationStatus = .notDetermined {
        didSet {
            authorizationDelegate?.locationManager(self, didChangeAuthorization: authorizationStatus)
        }
    }
    
}

extension XSPDLocationManagerUITestMock: XSPDLocationManager {
    
    func requestWhenInUseAuthorization() {
        guard let viewController = UIApplication.shared.delegate?.window??.rootViewController else {
            return
        }
        
        let alertController = UIAlertController(title: "위치 서비스 앱 접근 권한", message: nil, preferredStyle: .alert)
        
        let allowAction = UIAlertAction(title: "허용", style: .default) { [weak self](_) in
            self?.authorizationStatus = .authorizedWhenInUse
        }
        alertController.addAction(allowAction)
        
        let dontAllowAction = UIAlertAction(title: "허용안함", style: .cancel) { [weak self](_) in
            self?.authorizationStatus = .denied
        }
        alertController.addAction(dontAllowAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func startUpdatingLocation() {
        delayPostLocation()
    }
    
    func stopUpdatingLocation() {
        // Do Nothing
    }
}


private extension XSPDLocationManagerUITestMock {
    
    func delayPostLocation() {
        let coordinate = CLLocationCoordinate2D()
        let location = CLLocation(coordinate: coordinate, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, course: 0, speed: 20, timestamp: Date())
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)){ [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.delegate?.locationManager(strongSelf, didUpdateLocations: [location])
        }
    }
}

class XSPDLocationManagerUITestMockAssembly: Assembly {
    func assemble(container: Container) {
        container.register(XSPDLocationManager.self) { r in
            return XSPDLocationManagerUITestMock()
        }
    }
}









