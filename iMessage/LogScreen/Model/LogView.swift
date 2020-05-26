//
//  LogView.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 26/05/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import UIKit

class LogView: UIView {
    
    //MARK: - UI elements
    var stackView: UIStackView!
    var title: UILabel!
    
    var stackViewLeftConstraint = NSLayoutConstraint()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    
    private func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.customize(backgroundColor: .white, radiusSize: Constant.Size.textFieldSize.height / 1.6)
        
        title = UILabel()
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        setTitleConstraints()
        title.font = Constant.Font.titleFont
    }
    
    private func setTitleConstraints() {
        self.addSubview(title)
        title.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        title.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        title.widthAnchor.constraint(equalToConstant: 150).isActive = true
        title.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    /// To remove self by an animated way
    func disparition(handler: @escaping () -> Void) {
        stackViewLeftConstraint.constant = -UIScreen.main.bounds.width
        UIView.animate(withDuration: 0.5, animations: {
            self.layoutIfNeeded()
            self.title.alpha = 0
        }) { (bool) in
            handler()
        }
    }
    
    /// To appear self by an animated way
    func apparition() {
        title.alpha = 0
        stackViewLeftConstraint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.title.alpha = 1
            self.layoutIfNeeded()
        }
    }
}
