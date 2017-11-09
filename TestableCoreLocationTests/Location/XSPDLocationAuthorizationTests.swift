//
//  XSPDLocationAuthorizationTests.swift
//  TestableCoreLocationTests
//
//  Created by Scott moon on 09/11/2017.
//  Copyright © 2017 Scott moon. All rights reserved.
//

import XCTest
@testable import TestableCoreLocation

class XSPDLocationAuthorizationTests: XCTestCase {
    
    var sut : XSPDLocationAuthorization!
    
    var locationManagerMock : XSPDLocationManagerMock!
    var delegateMock : XSPDLocationAuthorizationDelegateMock!
    
    override func setUp() {
        super.setUp()
        
        locationManagerMock = XSPDLocationManagerMock()
        delegateMock = XSPDLocationAuthorizationDelegateMock()
        
        sut = XSPDDefaultLocationAuthorization(locationManger: locationManagerMock)
        sut.delegate = delegateMock
    }
    
    func test_checkAuthorization_notDetermined_requestsAuthorization() {
        
        // Arrange
        locationManagerMock.authorizationStatus = .notDetermined
        
        // Act
        sut.checkAuthorization()
        
        // Assert
        XCTAssertTrue(locationManagerMock.requestedWhenInAuthorization)
    }
    
    func test_checkAuthorization_determined_doesNotRequestsAuthorization() {
        // Arrange
        locationManagerMock.authorizationStatus = .denied
        
        // Act
        sut.checkAuthorization()
        
        // Assert
        XCTAssertFalse(locationManagerMock.requestedWhenInAuthorization)
        
    }
    
    func test_didChangeAuthorizationStatus_authorizedWhenInUse_notificationIsPosted() {
        // Arrange
        let notification = NSNotification.Name.XSPDLocationAuthorized
        let _ = expectation(forNotification: notification, object: sut, handler: nil)
        
        // Act
        locationManagerMock.authorizationDelegate?.locationManager(locationManagerMock, didChangeAuthorization: .authorizedWhenInUse)
        
        // Assert
        waitForExpectations(timeout: 0, handler: nil)
    }
    
    func test_didChangeAuthorizationStatus_authorizedAlways_notificationIsPosted() {
        // Arrange
        let notification = NSNotification.Name.XSPDLocationAuthorized
        let _ = expectation(forNotification: notification, object: sut, handler: nil)
        
        // Act
        locationManagerMock.authorizationDelegate?.locationManager(locationManagerMock, didChangeAuthorization: .authorizedAlways)
        
        // Assert
        waitForExpectations(timeout: 0, handler: nil)
    }
    
    func test_didChangeAuthorizationStatus_denied_delegateInformed() {
        // Arrange
        // Act
        locationManagerMock.authorizationDelegate?.locationManager(locationManagerMock, didChangeAuthorization: .denied)
        
        // Assert
        XCTAssertTrue(delegateMock.authorizationWasDenied)
    }
    
    func test_didChangeAuthorizationStatus_restricted_delegateInformed() {
        // Arrange
        locationManagerMock.authorizationDelegate?.locationManager(locationManagerMock, didChangeAuthorization: .restricted)
        
        // Assert
        XCTAssertTrue(delegateMock.authorizationWasDenied)
    }
}
