//
//  UIStackViewExt.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 26/05/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import UIKit

extension UIStackView {
    
    // Add a transparent to be able to add shadow and corner radius because stackView has no call to draw method
    func customize(backgroundColor: UIColor = .clear, radiusSize: CGFloat = 0) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = backgroundColor
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
        
        subView.layer.shadowColor = Constant.Color.MRBGrey.cgColor
        subView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        subView.layer.shadowOpacity = 0.2
        subView.layer.shadowRadius = 2
        
        subView.layer.borderWidth = 0.3
        subView.layer.borderColor = Constant.Color.MRBGrey.cgColor

        
        subView.layer.cornerRadius = radiusSize
        subView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMaxYCorner, .layerMaxXMinYCorner)

    }
}
