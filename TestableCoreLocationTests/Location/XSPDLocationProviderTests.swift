//
//  XSPDLocationProviderTests.swift
//  TestableCoreLocationTests
//
//  Created by Scott moon on 12/11/2017.
//  Copyright © 2017 Scott moon. All rights reserved.
//

import XCTest
@testable import TestableCoreLocation
import CoreLocation

class XSPDLocationProviderTests: XCTestCase {
    var sut: XSPDLocationProvider!
    
    // DOC's
    var locationManagerMock: XSPDLocationManagerMock!
    var locationAuthorizationMock: XSPDLocationAuthorizationMock!
    var consumerMock: XSPDLocationConsumerMock!
    
    override func setUp() {
        super.setUp()
        
        locationManagerMock = XSPDLocationManagerMock()
        locationAuthorizationMock = XSPDLocationAuthorizationMock()
        consumerMock = XSPDLocationConsumerMock()
        
        sut = XSPDDefaultLocationProvider(locationManger: locationManagerMock, locationAuthorization: locationAuthorizationMock)
        sut.add(consumerMock)
    }
    
    func test_authorizedNotification_startUpdatingLocation() {
        // Arrange
        // Act
        NotificationCenter.default.post(name: .XSPDLocationAuthorized, object: locationAuthorizationMock)
        
        // Assert
        XCTAssertTrue(locationManagerMock.didStartUpdatingLocation)
    }
    
    func test_updatedLocations_passesLocationToConsumers() {
        // Arrange
        let expectedLocation = CLLocation()
        
        // Act
        locationManagerMock.delegate?.locationManager(locationManagerMock, didUpdateLocations: [expectedLocation])
        
        // Assert
        XCTAssertEqual(expectedLocation, consumerMock.lastLocation)
    }
    
    func test_updatedLocations_noLocations_nothingIsPassedToConsumers() {
        // Arrange
        // Act
        locationManagerMock.delegate?.locationManager(locationManagerMock, didUpdateLocations: [])
        
        // Assert
        XCTAssertNil(consumerMock.lastLocation)
    }
    
    func test_updatedLocations_severalLocations_mostRecentLocationIsPassedToConsumers() {
        // Arrange
        let timeStamp = Date()
        let oldLocation = createLocation(with: timeStamp)
        let newLocation = createLocation(with: timeStamp.addingTimeInterval(60))
        
        // Act
        locationManagerMock.delegate?.locationManager(locationManagerMock, didUpdateLocations: [oldLocation, newLocation])
        
        // Assert
        XCTAssertEqual(newLocation, consumerMock.lastLocation)
    }
    
    func test_deinit_stopUpdating() {
        // Arrange
        // Act
        sut = nil
        
        // Asset
        XCTAssertTrue(locationManagerMock.didStopUpdatingLocation)
    }
    
    func createLocation(with date: Date) -> CLLocation {
        let coordinate = CLLocationCoordinate2D()
        return CLLocation(coordinate: coordinate, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, course: 0, speed: 0, timestamp: date)
    }
}
