//
//  BorderedButton.swift
//  TestableCoreLocation
//
//  Created by Scott moon on 06/11/2017.
//  Copyright © 2017 Scott moon. All rights reserved.
//

import UIKit

@IBDesignable
class BorderedButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        layer.cornerRadius = 5
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = titleLabel?.textColor?.cgColor
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }

}
