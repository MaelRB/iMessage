//
//  LogScreenStateButton.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 26/05/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import UIKit

/// Alow to change the state of the screen
class ScreenButton: UIButton {
    
    var height: CGFloat = 0
    var width: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let height = UIScreen.main.bounds.height
        self.height = height * 0.06
        let width = UIScreen.main.bounds.width
        self.width = width * 0.30
        self.setTitleColor(Constant.Color.tappable, for: .normal)
        self.setAttributedTitle(NSAttributedString(string: "Register", attributes: [NSAttributedString.Key.font: Constant.Font.textFont, NSAttributedString.Key.foregroundColor: Constant.Color.tappable!]), for: .normal)
        
        self.layer.shadowColor = Constant.Color.MRBGrey.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 2
        
        self.layer.cornerRadius = self.height / 2
        self.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMaxYCorner, .layerMaxXMinYCorner)
        self.backgroundColor = .white
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func disparition(_ method: AuthMethod) {
        UIView.animate(withDuration: 0.5, animations: {
            self.transform = CGAffineTransform(translationX: -self.width, y: 0)
        }) { (_) in
            self.setAttributedTitle(NSAttributedString(string: method.rawValue, attributes: [NSAttributedString.Key.font: Constant.Font.textFont, NSAttributedString.Key.foregroundColor: Constant.Color.tappable!]), for: .normal)
        }
    }
    
    func apparition() {
        UIView.animate(withDuration: 0.5, animations: {
            self.transform = CGAffineTransform.identity
        })
    }
}
