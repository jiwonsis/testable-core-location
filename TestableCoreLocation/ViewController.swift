//
//  ViewController.swift
//  TestableCoreLocation
//
//  Created by Scott moon on 31/10/2017.
//  Copyright © 2017 Scott moon. All rights reserved.
//

import UIKit
import CoreLocation
import Swinject
import SwinjectStoryboard

private let maxDisplayableSpeed: CLLocationSpeed = 40  // 40m/s , 144km/h

class ViewController: UIViewController {
    
    var speedProvider: XSPDLocationSpeedProvider! {
        didSet {
            speedProvider.delegate = self
        }
    }
    var speedChecker: XSPDLocationSpeedChecker! {
        didSet {
            speedChecker.delegate = self
        }
    }
    
    @IBOutlet var speedLables: [UILabel]!
    
    @IBOutlet weak var speedViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var colorableViews: [UIView]!
    

    @IBAction func didTapMaxSpeed(_ sender: Any) {
        let alertController = UIAlertController(title: "최대 속도 선택",
                                                message: "이 최대 속도를 초과하면 경고 메시지가 표시됩니다.",
                                                preferredStyle: .alert)
        alertController.addTextField { [weak self] (textField) in
            textField.keyboardType = .numberPad
            textField.placeholder = "최대 속도 값을 입력해주세요"
            textField.accessibilityIdentifier = "maxSpeedInputLabel"
            if let maxSpeed = self?.speedChecker.maximumSpeed {
                textField.text = String(format: "%.0f", maxSpeed.asKMH)
            }
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] (_) in
            guard let text = alertController.textFields?.first?.text else { return }
            guard let maxSpeed = Double(text) else { return }
            
            self?.speedChecker.maximumSpeed = maxSpeed.asMPS
            
        }
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for label in speedLables {
            label.text = "0"
        }
    
        speedViewHeightConstraint.constant = 0
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension ViewController: XSPDLocationSpeedProviderDelegate {
    
    func didUpdate(speed: CLLocationSpeed) {
        for label in speedLables {
            label.text = String(format: "%.0f", speed.asKMH)
        }
        
        view.layoutIfNeeded()
        
        let maxHeight = view.bounds.height
        speedViewHeightConstraint.constant = maxHeight * CGFloat(speed / maxDisplayableSpeed)
        
        UIView.animate(withDuration: 1.4) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}

extension ViewController: XSPDLocationSpeedCheckerDelegate {
    
    func exceedingMaximumSpeedChanged(for speedChecker: XSPDLocationSpeedChecker) {
        let color: UIColor = speedChecker.isExceedingMaximumSpeed ? .displayColorRed : .displayColorBlue
        
        UIView.animate(withDuration: 1.0) { [weak self] in
            for view in self?.colorableViews ?? [] {
                if let label = view as? UILabel {
                    label.textColor = color
                } else if let button = view as? UIButton {
                    button.setTitleColor(color, for: .normal)
                } else {
                    view.backgroundColor = color
                }
            }
        }
    }
}

extension UIColor {
    static let displayColorRed = UIColor(red: 255/255, green: 82/255, blue: 0/255, alpha: 1)
    static let displayColorBlue = UIColor(red: 0/255, green: 0/255, blue: 128/255, alpha: 1)
}

extension Double {
    var asMPS: CLLocationSpeed {
        return self / 3.6  // 3.6km/h = 1m/s
    }
}

extension CLLocationSpeed {
    var asKMH: Double {
        return self * 3.6 // 1m/s = 3.6 km/h
    }
}

class ViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.storyboardInitCompleted(ViewController.self) { (r, c) in
            c.speedProvider = r.resolve(XSPDLocationSpeedProvider.self)!
            c.speedChecker = r.resolve(XSPDLocationSpeedChecker.self)!
        }
    }
}
