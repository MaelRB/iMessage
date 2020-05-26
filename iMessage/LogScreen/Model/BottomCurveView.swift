//
//  BottomCurveView.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 26/05/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import UIKit

class BottomCurveView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
     
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
       let bottomCurve = CGMutablePath()

        
        bottomCurve.move(to: CGPoint(x: self.frame.width * 0, y: self.frame.height * 1.25))
        bottomCurve.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height * 1.25))
        bottomCurve.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height * 0.5))
        bottomCurve.addCurve(to: CGPoint(x: 0, y: self.frame.height * 0.75), control1: CGPoint(x: frame.width * 0.7, y: frame.height * 0.7), control2: CGPoint(x: frame.width * 0.4, y: frame.height * 0.45))
        bottomCurve.closeSubpath()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bottomCurve
        shapeLayer.fillColor = Constant.Color.bottomCurveGradient(self.frame).cgColor
        shapeLayer.lineWidth = 1.0
        shapeLayer.position = CGPoint(x: 0, y: 0)

        self.layer.addSublayer(shapeLayer)
     }
}
