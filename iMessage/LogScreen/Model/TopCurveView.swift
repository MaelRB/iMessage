//
//  TopCurveView.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 26/05/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import UIKit

class TopCurveView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
     
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
       let topCurve = CGMutablePath()

        
        topCurve.move(to: CGPoint(x: 0, y: self.frame.height * 0.5))
        topCurve.addCurve(to: CGPoint(x: self.frame.width, y: self.frame.height * 0.25), control1: CGPoint(x: frame.width * 0.4, y: frame.height * 0.25), control2: CGPoint(x: frame.width * 0.7, y: frame.height * 0.5))
        topCurve.addLine(to: CGPoint(x: frame.width, y: -frame.height * 0.125))
        topCurve.addLine(to: CGPoint(x: 0, y: -frame.height * 0.125))
        topCurve.closeSubpath()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = topCurve
        shapeLayer.fillColor = Constant.Color.topCurveGradient(self.frame).cgColor
        shapeLayer.lineWidth = 1.0
        shapeLayer.position = CGPoint(x: 0, y: 0)
        
        self.layer.addSublayer(shapeLayer)
     }
}
