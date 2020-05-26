//
//  RegisterView.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 26/05/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import UIKit

class RegisterView: LogView {
    
    //MARK: - UI elements
    private var mailTextField: MRBTextField!
    private var passwordTextField: MRBTextField!
    private var usernameTextField: MRBTextField!
    
    private var registerButton: CheckButton!

        
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
        
        let config = UIImage.SymbolConfiguration(pointSize: 8)
        
        mailTextField = MRBTextField(frame: .zero)
        mailTextField.translatesAutoresizingMaskIntoConstraints = false
        mailTextField.heightAnchor.constraint(equalToConstant:Constant.Size.textFieldSize.height).isActive = true
        mailTextField.widthAnchor.constraint(equalToConstant: Constant.Size.textFieldSize.width).isActive = true
        mailTextField.textField.placeholder = "Mail"
        mailTextField.imageView.image = UIImage(systemName: "envelope", withConfiguration: config)
        mailTextField.textField.keyboardType = .emailAddress
            
            
        passwordTextField = MRBTextField(frame: .zero)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.heightAnchor.constraint(equalToConstant: Constant.Size.textFieldSize.height).isActive = true
        passwordTextField.widthAnchor.constraint(equalToConstant: Constant.Size.textFieldSize.width).isActive = true
        passwordTextField.textField.placeholder = "Password"
        passwordTextField.imageView.image = UIImage(systemName: "lock", withConfiguration: config)
        passwordTextField.textField.isSecureTextEntry = true
        
        usernameTextField = MRBTextField(frame: .zero)
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.heightAnchor.constraint(equalToConstant: Constant.Size.textFieldSize.height).isActive = true
        usernameTextField.widthAnchor.constraint(equalToConstant: Constant.Size.textFieldSize.width).isActive = true
        usernameTextField.textField.placeholder = "Username"
        usernameTextField.imageView.image = UIImage(systemName: "person", withConfiguration: config)
            
        stackView.addArrangedSubview(usernameTextField)
        stackView.addArrangedSubview(mailTextField)
        stackView.addArrangedSubview(passwordTextField)
        
        setStackViewConstraints()
        
        title.text = "Register"
            
        registerButton = CheckButton(frame: .zero)
        stackView.addSubview(registerButton)
        let xPos = Constant.Size.textFieldSize.width - (Constant.Size.textFieldSize.height / 2)
        let height = Constant.Size.textFieldSize.height
        registerButton.frame = CGRect(x: xPos, y: height, width: height * 0.8, height: height * 0.8)
        registerButton.setup()

    }
    
    // Stack view constraints are set here and not in LogView because his height depends of the amount of elements it contains (3 for register view)
    private func setStackViewConstraints() {
        self.addSubview(stackView)
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: Constant.Size.textFieldSize.height * 3).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: Constant.Size.textFieldSize.width).isActive = true
        stackViewLeftConstraint = stackView.leftAnchor.constraint(equalTo: self.leftAnchor)
        stackViewLeftConstraint.isActive = true
    }
        
}

