//
//  MRBTextField.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 26/05/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import UIKit


/// A text field with an image in the left side
class MRBTextField: UIView {
    
    // MARK: - UI elements
    var imageView: UIImageView!
    var textField: UITextField!
    
    
    // MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    func setup() {
        backgroundColor = .clear
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        setImageViewConstraints()
        imageView.tintColor = Constant.Color.MRBGrey
        
        textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        setTextFieldConstraints()
        textField.textColor = Constant.Color.navyBlue
        textField.font = Constant.Font.textFont
        textField.attributedPlaceholder = NSAttributedString(string: "placeholder text", attributes: [NSAttributedString.Key.foregroundColor: Constant.Color.navyBlue!, NSAttributedString.Key.font: Constant.Font.placeolderFont])
        
        // remove any auto correction because self is used for get an email address, a username or a passeword
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
        
    }
    
    private func setImageViewConstraints() {
        self.addSubview(imageView)
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 26).isActive = true
    }
    
    private func setTextFieldConstraints() {
        self.addSubview(textField)
        textField.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 10).isActive = true
        textField.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
}
