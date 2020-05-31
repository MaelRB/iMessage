//
//  DiscussionViewController.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 11/05/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import UIKit
import Firebase

class MessageViewController: UIViewController {

    // MARK: UI Elements
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var bottomConstraints: NSLayoutConstraint!
    
    // MARK: Other properties
    let db = Firestore.firestore()
    
    let dbCommunication = DBCommunication()
    
    var discussion: Discussion?
    
    var messages = [Message]()
    
    // MARK: - View methods
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.title = discussion!.to.pseudo
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MessageCell.self, forCellReuseIdentifier: "bubbleCell")
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        
        dbCommunication.loadMessages(for: discussion!) { (messages) in
            self.messages = messages
            DispatchQueue.main.async {
                self.tableView.reloadData()
                if self.messages.count > 0 {
                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
                }
            }
        }
        
        // Manage keyboard
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        removeRightButton()
    }
    
    func removeRightButton(){
        guard let subviews = self.navigationController?.navigationBar.subviews else { return }
        for view in subviews {
            if view.tag != 0 {
                view.removeFromSuperview()
            }
        }
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        send()
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        let isKeyboardShowing = notification.name == UIResponder.keyboardWillChangeFrameNotification
        
        bottomConstraints.constant = isKeyboardShowing ? keyboardViewEndFrame.height : 0
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveLinear, animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            if self.messages.isEmpty == false {
                let lastCell = IndexPath(row: self.messages.count - 1, section: 0)
                self.tableView.scrollToRow(at: lastCell, at: .bottom, animated: true)
            }
        }
    }
    
    func send() {
        let message = Message(body: messageTextField.text!, sender: Auth.auth().currentUser!.email!)
        dbCommunication.sendMessage(message, in: discussion!)
        messages.append(message)
        messageTextField.text = ""
    }
    
}

// MARK: - Table view delegate & data source methods
extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bubbleCell", for: indexPath) as! MessageCell
        cell.configure(messages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.CellSize.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}


