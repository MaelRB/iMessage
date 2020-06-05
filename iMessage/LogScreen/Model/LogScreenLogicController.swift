//
//  LogScreenLogicController.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 27/05/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import UIKit
import Firebase

class LogScreenLogicController {
    
    let dataBase = Firestore.firestore()
    typealias Handler = (LogState) -> Void
    
    func willLogUser(_ mail: String, with password: String, then handler: @escaping (LogState, AuthUser) -> Void) {
        let authUser = AuthUser(mail: mail, username: nil, password: password)
        handler(.log, authUser)
    }
    
    func log(_ authUser: AuthUser, for method: AuthMethod, then handler: @escaping Handler) {
        switch method {
        case .login:
            authUser.login { (state) in
                handler(state)
            }
        case .register:
            authUser.register { (state) in
                handler(state)
            }
        }
    }
    
    func load(_ authUser: AuthUser, then handler: @escaping Handler) {
        // Load auth user data
        loadDiscussion(for: authUser) { (authUser) in
            handler(.presenting(authUser))
        }
    }
    
    private func loadDiscussion(for user: AuthUser, then handler: @escaping (AuthUser) -> Void) {
        
        let discussionRef = dataBase.collection(Constant.FStore.discussionCollection).whereField(Constant.FStore.discussionParticipant, arrayContains: user.mail)
        discussionRef.order(by: Constant.FStore.date, descending: true).getDocuments { (snapshot, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                for doc in snapshot!.documents {
                    let data = doc.data()
                    guard let id = data[Constant.FStore.discussionID] as? String else { return }
                    guard let time = data[Constant.FStore.date] as? TimeInterval else { return }
                    let date = Date(timeIntervalSince1970: time)
                    guard let lastMessage = data[Constant.FStore.lastMessageDiscussion] as? String else { return }
                    let discussion = Discussion(id: id, to: user, date: date, lastMessage: lastMessage)
                    user.discussion.append(discussion)
                }
            }
            handler(user)
        }
    }
    
}
