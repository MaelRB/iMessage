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
    private var stackView: UIStackView!
    private var title: UILabel!
    var method = AuthMethod.login {
        didSet {
            title.text = self.method.rawValue
            updateStackViewHeight()
            updateCheckButton()
        }
    }
    private var mailTextField: MRBTextField!
    private var passwordTextField: MRBTextField!
    private var usernameTextField: MRBTextField!
    private var alertLabel: UILabel!
    var logButton: CheckButton!
    var screenButton: ScreenButton!
    
    // MARK: - Other
    
    private var stackViewLeftConstraint = NSLayoutConstraint()
    private var stackViewHeightConstraint = NSLayoutConstraint()
    private var screenButtonLeftConstraints = NSLayoutConstraint()
    
    let config = UIImage.SymbolConfiguration(pointSize: 8)
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    //MARK: - Setup
    
    private func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        setTitle()
        setMailtextField()
        setUsername()
        setPasswordtextField()
        setStackView()
        setStackViewConstraints()
        setCheckButton()
        setScreenButton()
        setAlertLabel()
    }
    
    private func setCheckButton() {
        logButton = CheckButton(frame: .zero)
        stackView.addSubview(logButton)
        let xPos = Constant.Size.textFieldSize.width - (Constant.Size.textFieldSize.height / 2)
        let height = Constant.Size.textFieldSize.height
        logButton.frame = CGRect(x: xPos, y: height / 1.8, width: height * 0.8, height: height * 0.8)
        logButton.setup()
    }
    
    private func setMailtextField() {
        mailTextField = MRBTextField(frame: .zero)
        mailTextField.translatesAutoresizingMaskIntoConstraints = false
        mailTextField.heightAnchor.constraint(equalToConstant: Constant.Size.textFieldSize.height).isActive = true
        mailTextField.widthAnchor.constraint(equalToConstant: Constant.Size.textFieldSize.width).isActive = true
        mailTextField.textField.placeholder = "Mail"
        mailTextField.imageView.image = UIImage(systemName: "envelope", withConfiguration: config)
        mailTextField.textField.keyboardType = .emailAddress
    }
    
    private func setPasswordtextField() {
        passwordTextField = MRBTextField(frame: .zero)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.heightAnchor.constraint(equalToConstant: Constant.Size.textFieldSize.height).isActive = true
        passwordTextField.widthAnchor.constraint(equalToConstant: Constant.Size.textFieldSize.width).isActive = true
        passwordTextField.textField.placeholder = "Password"
        passwordTextField.imageView.image = UIImage(systemName: "lock", withConfiguration: config)
        passwordTextField.textField.isSecureTextEntry = true
    }
    
    private func setUsername() {
        usernameTextField = MRBTextField(frame: .zero)
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.heightAnchor.constraint(equalToConstant: Constant.Size.textFieldSize.height).isActive = true
        usernameTextField.widthAnchor.constraint(equalToConstant: Constant.Size.textFieldSize.width).isActive = true
        usernameTextField.textField.placeholder = "Username"
        usernameTextField.imageView.image = UIImage(systemName: "person", withConfiguration: config)
        usernameTextField.isHidden = true
    }
    
    private func setStackViewConstraints() {
        self.addSubview(stackView)
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: Constant.Size.textFieldSize.width).isActive = true
        stackViewLeftConstraint = stackView.leftAnchor.constraint(equalTo: self.leftAnchor)
        stackViewLeftConstraint.isActive = true
        stackViewHeightConstraint = stackView.heightAnchor.constraint(equalToConstant: Constant.Size.textFieldSize.height * 2)
        stackViewHeightConstraint.isActive = true
    }
    
    private func setAlertLabel() {
        alertLabel = UILabel()
        alertLabel.textColor = .red
        alertLabel.translatesAutoresizingMaskIntoConstraints = false
        alertLabel.textAlignment = .center
        alertLabel.numberOfLines = 0
        setAlertLabelConstraints()
    }
    
    private func setAlertLabelConstraints() {
        addSubview(alertLabel)
        alertLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10).isActive = true
        alertLabel.bottomAnchor.constraint(equalTo: screenButton.topAnchor, constant: -10).isActive = true
        alertLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        alertLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
    }
    
    private func setStackView() {
        stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.customize(backgroundColor: .white, radiusSize: Constant.Size.textFieldSize.height / 1.6)
        stackView.addArrangedSubview(usernameTextField)
        stackView.addArrangedSubview(mailTextField)
        stackView.addArrangedSubview(passwordTextField)
    }
    
    private func setTitle() {
        title = UILabel()
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        setTitleConstraints()
        title.font = Constant.Font.titleFont
        title.text = method.rawValue
    }
    
    private func setTitleConstraints() {
        self.addSubview(title)
        title.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        title.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        title.widthAnchor.constraint(equalToConstant: 150).isActive = true
        title.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    private func setScreenButton() {
        screenButton = ScreenButton(frame: .zero)
        self.addSubview(screenButton)
        screenButton.heightAnchor.constraint(equalToConstant: screenButton.height).isActive = true
        screenButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.30).isActive = true
        screenButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        screenButtonLeftConstraints = screenButton.leftAnchor.constraint(equalTo: leftAnchor)
        screenButtonLeftConstraints.isActive = true
    }
    
    // MARK: - Other
    
    private func updateStackViewHeight() {
        switch method {
        case .login:
            usernameTextField.isHidden = true
            stackViewHeightConstraint.constant = Constant.Size.textFieldSize.height * 2
            self.layoutIfNeeded()
        case .register:
            usernameTextField.isHidden = false
            stackViewHeightConstraint.constant = Constant.Size.textFieldSize.height * 3
            self.layoutIfNeeded()
        }
    }
    
    /// To remove self by an animated way
    private func disparition(handler: @escaping () -> Void) {
        stackViewLeftConstraint.constant = -UIScreen.main.bounds.width
        UIView.animate(withDuration: 0.5, delay: 0.1, animations: {
            self.layoutIfNeeded()
            self.title.alpha = 0
        }) { (bool) in
            handler()
        }
    }
    
    /// To appear self by an animated way
    private func apparition() {
        title.alpha = 0
        stackViewLeftConstraint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.title.alpha = 1
            self.layoutIfNeeded()
        }
    }
    
    private func switchScreen() {
        switch method {
        case .login:
            method = .register
        case .register:
            method = .login
        }
    }
    
    private func updateCheckButton() {
        let xPos = Constant.Size.textFieldSize.width - (Constant.Size.textFieldSize.height / 2)
        let height = Constant.Size.textFieldSize.height
        switch method {
        case .login:
            logButton.frame = CGRect(x: xPos, y: height / 1.8, width: height * 0.8, height: height * 0.8)
        case .register:
            logButton.frame = CGRect(x: xPos, y: height, width: height * 0.8, height: height * 0.8)
        }
    }
    
    // MARK: - Interface
    
    func transition() {
        disparition {
            self.switchScreen()
            self.apparition()
            self.screenButton.apparition()
        }
        screenButton.disparition(method)
    }
    
    func getTextFieldInput() -> (String, String, String?)? {
        guard let email = mailTextField.textField.text, let password = passwordTextField.textField.text else { return nil}
        return (email, password, usernameTextField.textField.text)
    }
    
    func cleanTextField() {
        mailTextField.textField.text = nil
        passwordTextField.textField.text = nil
    }
    
    func showAlert(with text: String) {
        alertLabel.text = text
    }
}
