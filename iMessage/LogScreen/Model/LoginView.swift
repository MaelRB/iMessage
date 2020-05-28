//
//  LoginView.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 26/05/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import UIKit

class LoginView: LogView {
    
    //MARK: - UI elements
    private var mailTextField: MRBTextField!
    private var passwordTextField: MRBTextField!
    var alertLabel: UILabel!
    
    var logButton: CheckButton!
    
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
        mailTextField.heightAnchor.constraint(equalToConstant: Constant.Size.textFieldSize.height).isActive = true
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
        
        stackView.addArrangedSubview(mailTextField)
        stackView.addArrangedSubview(passwordTextField)
        
        setStackViewConstraints()
        
        title.text = "Login"

        logButton = CheckButton(frame: .zero)
        stackView.addSubview(logButton)
        let xPos = Constant.Size.textFieldSize.width - (Constant.Size.textFieldSize.height / 2)
        let height = Constant.Size.textFieldSize.height
        logButton.frame = CGRect(x: xPos, y: height / 1.8, width: height * 0.8, height: height * 0.8)
        logButton.setup()
        
        setAlertLabel()
    }
    
    // Stack view constraints are set here and not in LogView because his height depends of the amount of elements it contains (2 for login view)
    private func setStackViewConstraints() {
        self.addSubview(stackView)
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: Constant.Size.textFieldSize.height * 2).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: Constant.Size.textFieldSize.width).isActive = true
        stackViewLeftConstraint = stackView.leftAnchor.constraint(equalTo: self.leftAnchor)
        stackViewLeftConstraint.isActive = true
    }
    
    private func setAlertLabel() {
        alertLabel = UILabel()
        alertLabel.textColor = .red
        alertLabel.translatesAutoresizingMaskIntoConstraints = false
        alertLabel.textAlignment = .center
        setAlertLabelConstraints()
    }
    
    private func setAlertLabelConstraints() {
        addSubview(alertLabel)
        alertLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10).isActive = true
        alertLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        alertLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        alertLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
    }
    
    
    //MARK: - Interface
    
    func getTextFieldInput() -> (String, String)? {
        guard let email = mailTextField.textField.text, let password = passwordTextField.textField.text else { return nil}
        return (email, password)
    }
    
    func cleanTextField() {
        mailTextField.textField.text = nil
        passwordTextField.textField.text = nil
    }
    
    func showAlert(for error: LogError) {
        switch error {
        case .incorrectData:
            alertLabel.text = "Incorrect password or email"
        case .noAccount:
            break
        }
    }

}
