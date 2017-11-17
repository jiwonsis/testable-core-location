//
//  XSPDLocationSpeedProviderTests.swift
//  TestableCoreLocationTests
//
//  Created by Scott moon on 17/11/2017.
//  Copyright © 2017 Scott moon. All rights reserved.
//

import XCTest
@testable import TestableCoreLocation
import CoreLocation

class XSPDLocationSpeedProviderTests: XCTestCase {
    
    var sut: XSPDLocationSpeedProvider!
    
    var locationProviderMock : XSPDLocationProviderMock!
    var delegateMock: XSPDLocationSpeedProviderDelegateMock!
    
    override func setUp() {
        super.setUp()
        
        locationProviderMock = XSPDLocationProviderMock()
        delegateMock = XSPDLocationSpeedProviderDelegateMock()
        
        sut = XSPDDefaultLocationSpeedProvider(locationProvider: locationProviderMock)
        sut.delegate = delegateMock
    }
    
    func test_consumeLocation_speedLessThanZeroToDelegate() {
        // Arrange
        let location = createLocation(with: -10)
        
        // Act
        locationProviderMock.lastConsumer?.consumeLocation(location)
        
        // Assert
        XCTAssertEqual(0, delegateMock.lastSpeed)
    }
    
    func test_consumeLocation_speedGreaterThanSpeedToDelegate() {
        // Arrange
        let location = createLocation(with: 10.0)
        
        // Act
        locationProviderMock.lastConsumer?.consumeLocation(location)
        
        // Assert
        XCTAssertEqual(10.0, delegateMock.lastSpeed)
    }
    
    func createLocation(with speed: CLLocationSpeed) -> CLLocation {
        let coordinate = CLLocationCoordinate2D()
        return CLLocation(coordinate: coordinate,
                          altitude: 0,
                          horizontalAccuracy: 0,
                          verticalAccuracy: 0,
                          course: 0,
                          speed: speed,
                          timestamp: Date())
    }
}
