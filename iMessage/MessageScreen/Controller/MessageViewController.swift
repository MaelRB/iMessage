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
        
        loadMessages()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
        addMessage(message)
        messages.append(message)
        messageTextField.text = ""
    }
    
    //MARK: - Firestore methods
    
    func addMessage(_ message: Message) {
        db.collection(Constant.FStore.discussionCollection).document(discussion!.id).collection(Constant.FStore.messagesCollection).addDocument(data: [
            Constant.FStore.messageBody: message.body,
            Constant.FStore.messageSender: message.sender,
            Constant.FStore.date: Date().timeIntervalSince1970
        ])
    }
    
    func loadMessages() {
        db.collection(Constant.FStore.discussionCollection).document(discussion!.id).collection(Constant.FStore.messagesCollection).order(by: Constant.FStore.date).addSnapshotListener { (snapshot, error) in
            self.messages = []
            if error != nil {
                print(error!)
            } else {
                for doc in snapshot!.documents {
                    let data = doc.data()
                    guard let body = data[Constant.FStore.messageBody] as? String,
                        let sender = data[Constant.FStore.messageSender] as? String
                        else { return }
                    let message = Message(body: body, sender: sender)
                    self.messages.append(message)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        if self.messages.count > 0 {
                            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                            self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
                        }
                    }
                }
            }
        }
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


