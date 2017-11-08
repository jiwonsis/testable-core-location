//
//  XSPDLocationAuthorizationMock.swift
//  TestableCoreLocationTests
//
//  Created by Scott moon on 09/11/2017.
//  Copyright © 2017 Scott moon. All rights reserved.
//

import Foundation
@testable import TestableCoreLocation

class XSPDLocationAuthorizationMock: XSPDLocationAuthorization {
    
    weak var delegate: XSPDLocationAuthorizationDelegate?
    
    var didCheckAuthorization = false
    
    func checkAuthorization() {
        didCheckAuthorization = true
    }
    
}
