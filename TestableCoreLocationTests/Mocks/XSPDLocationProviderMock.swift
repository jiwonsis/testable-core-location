//
//  XSPDLocationProviderMock.swift
//  TestableCoreLocationTests
//
//  Created by Scott moon on 09/11/2017.
//  Copyright © 2017 Scott moon. All rights reserved.
//

import Foundation
@testable import TestableCoreLocation

class XSPDLocationProviderMock: XSPDLocationProvider {
    
    var lastConsumer: XSPDLocationConsumer?
    func add(_ consumer: XSPDLocationConsumer) {
        lastConsumer = consumer
    }
}
