//
//  LogScreenStateButton.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 26/05/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import UIKit

/// Alow to change the state of the screen
class LogScreenStateButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let height = UIScreen.main.bounds.height
        let width = UIScreen.main.bounds.width
        self.frame = CGRect(x: 0, y: height * 0.70, width: width * 0.30, height: height * 0.06)
        self.setTitleColor(Constant.Color.tappable, for: .normal)
        self.setAttributedTitle(NSAttributedString(string: "Register", attributes: [NSAttributedString.Key.font: Constant.Font.textFont, NSAttributedString.Key.foregroundColor: Constant.Color.tappable!]), for: .normal)
        
        self.layer.shadowColor = Constant.Color.MRBGrey.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 2
        
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMaxYCorner, .layerMaxXMinYCorner)
        self.backgroundColor = .white
    }
    
    func disparition(_ title: String) {
        UIView.animate(withDuration: 0.5, animations: {
            self.transform = CGAffineTransform(translationX: -self.frame.width, y: 0)
        }) { (_) in
            self.setAttributedTitle(NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: Constant.Font.textFont, NSAttributedString.Key.foregroundColor: Constant.Color.tappable!]), for: .normal)
        }
    }
    
    func apparition(then handler: @escaping () -> Void) {
        UIView.animate(withDuration: 0.5, animations: {
            self.transform = CGAffineTransform.identity
        })
    }
}
