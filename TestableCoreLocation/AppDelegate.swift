//
//  AppDelegate.swift
//  TestableCoreLocation
//
//  Created by Scott moon on 31/10/2017.
//  Copyright © 2017 Scott moon. All rights reserved.
//

import UIKit
import SwinjectStoryboard

@UIApplicationMain
class AppDelegate: UIResponder {

    var window: UIWindow?
    let mainAssember = MainAssembler()

    let locationAuthorization: XSPDLocationAuthorization
    
    override init() {
        
        locationAuthorization = mainAssember.resolver.resolve(XSPDLocationAuthorization.self)!
        
        
        super.init()
        
        locationAuthorization.delegate = self
    }

}

private extension AppDelegate {
    
    func setupWindow() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        
        let storyboard = SwinjectStoryboard.create(name: "Main", bundle: nil)
        
        window.backgroundColor = UIColor.black
        window.rootViewController = storyboard.instantiateInitialViewController()
        
        self.window = window
    }
}

extension AppDelegate: UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        setupWindow()
        locationAuthorization.checkAuthorization()
        
        return true
    }
}

extension AppDelegate: XSPDLocationAuthorizationDelegate {
    func authorizationDenied(for locationAuthorization: XSPDLocationAuthorization) {
        let alertController = UIAlertController.init(title: "Perminsion Denied?", message: "This app needs acces your location to function", preferredStyle: .alert)
        
        let okAction = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
