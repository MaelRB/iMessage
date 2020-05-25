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

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    let db = Firestore.firestore()
    
    var discussion: Discussion?
    
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.title = discussion!.to.pseudo
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MessageCell.self, forCellReuseIdentifier: "bubbleCell")
        tableView.separatorStyle = .none
        
        loadMessages()
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
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
}
