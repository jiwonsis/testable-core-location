//
//  XSPDLocationAuthorizationDelegateMock.swift
//  TestableCoreLocationTests
//
//  Created by Scott moon on 09/11/2017.
//  Copyright © 2017 Scott moon. All rights reserved.
//

import Foundation
@testable import TestableCoreLocation

class XSPDLocationAuthorizationDelegateMock: XSPDLocationAuthorizationDelegate {
    
    var authorizationWasDenied = false
    func authorizationDenied(for locationAuthorization: XSPDLocationAuthorization) {
        authorizationWasDenied = true
    }
}
