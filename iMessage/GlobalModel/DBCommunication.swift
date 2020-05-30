//
//  DBCommunication.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 27/05/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import Foundation
import Firebase

struct DBCommunication {
    typealias Handler = (DBState) -> Void
    
    let dataBase = Firestore.firestore()
    
    //MARK: - Connection methods
    
    static func register(email: String, password: String, then handler: @escaping Handler) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                handler(.failed(localizedDescription: error!.localizedDescription))
            } else {
                handler(.successed)
            }
        }
    }
    
    static func login(email: String, password: String, then handler: @escaping Handler) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if error != nil {
                handler(.failed(localizedDescription: error!.localizedDescription))
            } else {
                handler(.successed)
            }
        }
    }
    
    func logout(_ handler: @escaping () -> Void) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            handler()
        }
        catch
            let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    //MARK: - Discussion methods
    
    func loadDiscussion(_ handler: @escaping ([Discussion]) -> Void) {
        var discussions = [Discussion]()
        let discussionRef = dataBase.collection(Constant.FStore.discussionCollection).whereField(Constant.FStore.discussionParticipant, arrayContains: Auth.auth().currentUser!.email!)
        discussionRef.order(by: Constant.FStore.date, descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                for doc in snapshot!.documents {
                    let data = doc.data()
                    guard let participant = data[Constant.FStore.discussionParticipant] as? [String] else { return }
                    guard let user = self.getParticipant(of: participant) else { return }
                    guard let id = data[Constant.FStore.discussionID] as? String else { return }
                    let discussion = Discussion(id: id, to: user)
                    discussions.append(discussion)
                }
            }
            
            DispatchQueue.main.async {
                handler(discussions)
            }
        }
    }
    
    private func getParticipant(of part: [String]) -> User? {
        var toHimself = 0
        for user in part {
            if user != Auth.auth().currentUser!.email! {
                for contact in Constant.Contact.listOfContacts {
                    if contact.email == user {
                        return contact
                    }
                }
            } else {
                toHimself += 1
            }
        }
        if toHimself == part.count {
            for contact in Constant.Contact.listOfContacts {
                if contact.email == Auth.auth().currentUser!.email {
                    return contact
                }
            }
        }
        return nil
    }
    
    
    
    func deleteDiscussion(_ discussion: Discussion) {
        dataBase.collection(Constant.FStore.discussionCollection).document(discussion.id).delete { (error) in
            if error != nil {
                print(error!)
            }
        }
    }
    
    //MARK: - Messages methods
    
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
                  let sender = data[Constant.FStore.messageSender] as? String
                else { continue }
            let message = Message(body: body, sender: sender)
            messages.append(message)
        }
        return messages
    }
    
    func sendMessage(_ message: Message, in discussion: Discussion) {
        dataBase.collection(Constant.FStore.discussionCollection).document(discussion.id).collection(Constant.FStore.messagesCollection).addDocument(data: [
            Constant.FStore.messageBody: message.body,
            Constant.FStore.messageSender: message.sender,
            Constant.FStore.date: Date().timeIntervalSince1970
        ])
    }
}
