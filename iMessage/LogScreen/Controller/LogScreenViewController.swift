//
//  LogScreenViewController.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 26/05/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import UIKit

class LogScreenViewController: UIViewController {
    
    // MARK: - Logic controller
    // Manage the communication with firestore asynchronously
    let logicController = LogScreenLogicController()
    
    // MARK: - UI elements
//    lazy var logScreenStateButton = LogScreenStateButton(frame: .zero)
    
    var  topCurve: TopCurveView!
    var bottomCurve: BottomCurveView!
    
    var appTitle: AppTitleLabel!

    var logView: LogView!
    
    var isFirstLaunch = true
    
    // Discussions are load before segue
    var discussions = [Discussion]()

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
        
        logView = LogView()
        setLogViewConstraints()
        logView.isHidden = true
        
        logView.screenButton.addTarget(self, action: #selector(screenStateButtonTapped), for: .touchUpInside)

        logView.logButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        
        // Create a tap gesture to dismiss keyboard when tapping outside the keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        logView.cleanTextField()
        view.endEditing(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isFirstLaunch == true {
            closeCurve() 
            isFirstLaunch = false
        }
    }
    
    // MARK: - Setup
    
    func setLogViewConstraints() {
        self.view.insertSubview(logView, at: 0)
        logView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        logView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        logView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        logView.heightAnchor.constraint(equalToConstant: self.view.frame.height / 2).isActive = true
    }
    
    // MARK: - Transition animation methods
    @objc func screenStateButtonTapped() {
        logView.transition()
    }
    
    @objc func checkButtonTapped() {
        guard let logInfo = logView.getTextFieldInput() else { return }
        let (mail, password) = logInfo
        
        // Prevent view controller that log action will begin
        logicController.willLogUser(mail, with: password) { (state, user) in
            self.render(state)
            
            // Log the user
            self.logicController.log(user, for: self.logView.method) { (state) in
                self.render(state)
                
                // Load user data if it's not a new user
                switch state {
                case .load(let user):
                    self.logicController.load(user) { (state) in
                        self.render(state)
                    }
                default:
                    break
                }
            }
        }
    }
    
    func closeCurve() {
        UIView.animate(withDuration: 0.5, delay: 1, options: .curveEaseIn, animations: {
            self.topCurve.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height * 0.125)
            self.bottomCurve.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height * 0.125)
        }) { (bool) in
            // First load, initialization with login view
            self.openCurve()
        }
    }
    
    func openCurve() {
        self.appTitle.removeFromSuperview()
         self.logView.isHidden = false
         UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
             self.topCurve.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height * 0.25)
             self.bottomCurve.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height * 0.25)
         }) { (_) in
            self.view.addSubview(self.logView)
        }
    }
    
    func render(_ state: LogState) {
        switch state {
        case .log:
            view.endEditing(true)
            logView.showAlert(with: "")
            logView.logButton.loading()
            break
        case .load(_):
            break
        case .presenting(let user):
            logView.logButton.stopLoading()
            let vc = storyboard?.instantiateViewController(identifier: "DiscussionVC") as! DiscussionViewController
            vc.authUser = user
            navigationController?.show(vc, sender: self)
        case .failed(let description):
            logView.showAlert(with: description)
        }
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }
    
}

