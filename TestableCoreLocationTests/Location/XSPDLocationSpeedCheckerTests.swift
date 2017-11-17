//
//  XSPDLocationSpeedCheckerTests.swift
//  TestableCoreLocationTests
//
//  Created by Scott moon on 17/11/2017.
//  Copyright © 2017 Scott moon. All rights reserved.
//

import XCTest
@testable import TestableCoreLocation
import CoreLocation


class XSPDLocationSpeedCheckerTests: XCTestCase {
    var sut : XSPDLocationSpeedChecker!
    
    var locationProviderMock : XSPDLocationProviderMock!
    var delegateMock : XSPDLocationSpeedCheckerDelegateMock!
    
    override func setUp() {
        super.setUp()
        
        locationProviderMock = XSPDLocationProviderMock()
        delegateMock = XSPDLocationSpeedCheckerDelegateMock()
        
        sut = XSPDDefaultLocationSpeedChecker(locationProvier: locationProviderMock)
        sut.delegate = delegateMock
        
    }
    
    func test_isExceedingMaximumSpeed_maximumSpeedIsNill_false() {
        //Array
        sut.maximumSpeed = nil
        let location = createLocation(with: 1000)
        
        // Act
        locationProviderMock.lastConsumer?.consumeLocation(location)
        
        // Assert
        XCTAssertFalse(sut.isExceedingMaximumSpeed)
    }
    
    func test_isExceedingMaximumSpeed_maximumSpeedNotExceeded_false() {
        //Array
        sut.maximumSpeed = 100
        let location = createLocation(with: 100)
        
        // Act
        locationProviderMock.lastConsumer?.consumeLocation(location)
        
        // Assert
        XCTAssertFalse(sut.isExceedingMaximumSpeed)
    }
    
    func test_isExceedingMaximumSpeed_maximumSpeedExceeded_true() {
        //Array
        sut.maximumSpeed = 100
        let location = createLocation(with: 120)
        
        // Act
        locationProviderMock.lastConsumer?.consumeLocation(location)
        
        // Assert
        XCTAssertTrue(sut.isExceedingMaximumSpeed)
        
    }
    
    func test_isExceedingMaximumSpeed_maximumSpeedExceeded_delegateIsInformed() {
        //Array
        sut.maximumSpeed = 100
        let location = createLocation(with: 120)
        
        // Act
        locationProviderMock.lastConsumer?.consumeLocation(location)
        
        // Assert
        XCTAssertTrue(delegateMock.didChangeExceedingMaxSpeed)
    }
    
    func test_isExceedingMaximemSpeed_maximumSpeedExceededSetToExceededValue_true() {
        // Arrange
        let location = createLocation(with: 110)
        locationProviderMock.lastConsumer?.consumeLocation(location)
        
        // Act
        sut.maximumSpeed = 100
        
        // Assert
        XCTAssertTrue(sut.isExceedingMaximumSpeed)
    }
    
    func test_isExceedingMaximemSpeed_maximumSpeedExceededSetToExceededValue_delegateIsInformed() {
        // Arrange
        let location = createLocation(with: 110)
        locationProviderMock.lastConsumer?.consumeLocation(location)
        
        // Act
        sut.maximumSpeed = 100
        
        // Assert
        XCTAssertTrue(delegateMock.didChangeExceedingMaxSpeed)
    }
    
    func test_isExceedingMaximemSpeed_propertyDoesNotChange_delegateIsNotInformed () {
        // Arrange
        sut.maximumSpeed = 100
        let firstLocation = createLocation(with: 110)
        let secondLocation = createLocation(with: 115)
        locationProviderMock.lastConsumer?.consumeLocation(firstLocation)
        delegateMock.didChangeExceedingMaxSpeed = false
        
        // Act
        locationProviderMock.lastConsumer?.consumeLocation(secondLocation)
        
        // Assert
        XCTAssertFalse(delegateMock.didChangeExceedingMaxSpeed)
    }
    
    func createLocation(with speed:CLLocationSpeed) -> CLLocation {
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
