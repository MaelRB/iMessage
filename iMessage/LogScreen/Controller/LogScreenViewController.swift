//
//  LogScreenViewController.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 26/05/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import UIKit

class LogScreenViewController: UIViewController {
    
    // MARK: - UI elements
    lazy var logScreenStateButton = LogScreenStateButton(frame: .zero)
    
    var  topCurve: TopCurveView!
    var bottomCurve: BottomCurveView!
    
    var appTitle: AppTitleLabel!
    
    var loginView: LoginView!
    var registerView: RegisterView!
    
    var screenState = LogScreenState.Login

    // MARK: - View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.backgroundColor = Constant.Color.background
        
        appTitle = AppTitleLabel(frame: view.frame)
        view.addSubview(appTitle)
        
        topCurve = TopCurveView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(topCurve)
        
        bottomCurve =  BottomCurveView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(bottomCurve)
        
        self.loginView = LoginView(frame: .zero)
        self.setConstraints(for: self.loginView)
        loginView.isHidden = true
        
        self.registerView = RegisterView(frame: .zero)
        self.setConstraints(for: self.registerView)
        registerView.isHidden = true
        
        // Set the constraints to the disparition position so for his first apparition the
        // stack view will be animated
        registerView.stackViewLeftConstraint.constant = -UIScreen.main.bounds.width
        
        logScreenStateButton.addTarget(self, action: #selector(screenStateButtonTapped), for: .touchUpInside)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5, delay: 1, options: .curveEaseIn, animations: {
            self.topCurve.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height * 0.125)
            self.bottomCurve.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height * 0.125)
        }) { (bool) in
            // First load, initialization with login view
            self.appTitle.removeFromSuperview()
            self.view.insertSubview(self.logScreenStateButton, at: 0)
            self.loginView.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
                self.topCurve.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height * 0.25)
                self.bottomCurve.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height * 0.25)
            }) { (_) in
                // Move the button to the last subview otherwise the tap event isn't triger
                self.logScreenStateButton.removeFromSuperview()
                self.view.addSubview(self.logScreenStateButton)
                self.view.insertSubview(self.topCurve, at: 0)
                self.view.insertSubview(self.bottomCurve, at: 0)
            }
        }
    }
    
    // MARK: - Other
    // set constraints for loginView and registerView
    func setConstraints(for view: LogView) {
        self.view.insertSubview(view, at: 0)
        view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        view.heightAnchor.constraint(equalToConstant: self.view.frame.height / 2).isActive = true
    }
    
    @objc func screenStateButtonTapped() {
        switch screenState {
        case .Login:
            screenState = .Register
            logScreenStateButton.disparition("Login")
            loginView.disparition {
                self.loginView.isHidden = true
                self.registerView.isHidden = false
                self.registerView.apparition()
                self.logScreenStateButton.apparition {
                    // Move the button to the last subview otherwise the tap event isn't triger
                    self.logScreenStateButton.removeFromSuperview()
                    self.view.addSubview(self.logScreenStateButton)
                }
            }
        case .Register:
            screenState = .Login
            logScreenStateButton.disparition("Register")
            registerView.disparition {
                self.loginView.isHidden = false
                self.registerView.isHidden = true
                self.loginView.apparition()
                self.logScreenStateButton.apparition {
                    // Move the button to the last subview otherwise the tap event isn't triger
                    self.logScreenStateButton.removeFromSuperview()
                    self.view.addSubview(self.logScreenStateButton)
                }
            }
        }
    }
    
    
    
    
}
