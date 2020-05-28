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
    
    static func register(email: String, password: String, then handler: @escaping Handler) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                handler(.failed(.incorrectData))
            } else {
                handler(.successed)
            }
        }
    }
    
    static func login(email: String, password: String, then handler: @escaping Handler) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if error != nil {
                handler(.failed(.incorrectData))
            } else {
                handler(.successed)
            }
        }
    }
    
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
    
    func deleteDiscussion(_ discussion: Discussion) {
        dataBase.collection(Constant.FStore.discussionCollection).document(discussion.id).delete { (error) in
            if error != nil {
                print(error!)
            }
        }
    }
    
    
}
