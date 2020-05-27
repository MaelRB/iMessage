//
//  CheckButton.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 26/05/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import UIKit

class CheckButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 3, height: 2)
        self.layer.shadowOpacity = 0.4
        
        let config = UIImage.SymbolConfiguration(pointSize: 24)
        self.setImage(UIImage(systemName: "arrow.right", withConfiguration: config), for: .normal)
        
        self.backgroundColor = Constant.Color.buttonGradient(self.frame)
        self.tintColor = Constant.Color.background
        
    }
    
}
