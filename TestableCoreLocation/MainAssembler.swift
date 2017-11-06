//
//  MainAssembler.swift
//  TestableCoreLocation
//
//  Created by Scott moon on 06/11/2017.
//  Copyright © 2017 Scott moon. All rights reserved.
//

import Foundation
import Swinject

class MainAssembler {
    var resolver : Resolver {
        return assembler.resolver
    }
    
    private let assembler = Assembler()
    
    init() {
        assembler.apply(assembly: XSPDLocationManagerAssembly())
        assembler.apply(assembly: XSPDLocationSpeedCheckerAssembly())
        assembler.apply(assembly: XSPDLocationProviderAssembly())
        assembler.apply(assembly: XSPDLocationAuthorizationAssembly())
        assembler.apply(assembly: XSPDLocationSpeedProviderAssembly())
    }
}
