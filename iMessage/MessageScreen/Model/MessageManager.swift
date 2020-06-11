//
//  MessageManager.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 11/06/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import Foundation
import Firebase

class MessageManager {
    
    let dataBase = Firestore.firestore()
    
    func loadMessages(for discussion: Discussion, handler: @escaping ([Message]) -> Void) {
        let query = dataBase.collection(Constant.FStore.discussionCollection).document(discussion.id).collection(Constant.FStore.messagesCollection).order(by: Constant.FStore.date)
        query.addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error!)
            } else {
                let messages = self.extractMessages(for: snapshot!)
                handler(messages)
            }
        }
    }
    
    private func extractMessages(for snapshot: QuerySnapshot) -> [Message] {
        var messages = [Message]()
        for doc in snapshot.documents {
            let data = doc.data()
            guard let body = data[Constant.FStore.messageBody] as? String,
                  let sender = data[Constant.FStore.messageSender] as? String,
                  let time = data[Constant.FStore.date] as? TimeInterval
                else { continue }
            let date = Date(timeIntervalSince1970: time)
            let message = Message(body: body, sender: sender, date: date)
            messages.append(message)
        }
        return messages
    }
    
    func sendMessage(_ message: Message, in discussion: Discussion) {
        dataBase.collection(Constant.FStore.discussionCollection).document(discussion.id).collection(Constant.FStore.messagesCollection).addDocument(data: [
            Constant.FStore.messageBody: message.body,
            Constant.FStore.messageSender: message.sender,
            Constant.FStore.date: message.date.timeIntervalSince1970
        ])
        updateLastMessage(discussion, message: message)
    }
    
    private func updateLastMessage(_ discussion: Discussion, message: Message) {
        dataBase.collection(Constant.FStore.discussionCollection).document(discussion.id).updateData([Constant.FStore.lastMessageDiscussion: message.body, Constant.FStore.date: message.date.timeIntervalSince1970])
    }
    
}
