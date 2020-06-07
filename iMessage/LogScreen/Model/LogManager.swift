//
//  AuthMethod.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 04/06/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import Foundation
import Firebase

protocol LogManagerDelegate {
    func logDidFinish(with state: LogState)
    func userDidLoad(with state: LogState)
}

class LogManager {
    
    var mail: String
    var password: String
    var username: String
    
    var delegate: LogManagerDelegate?
    
    init(log mail: String, _ password: String, username: String?, with method: AuthMethod, target: LogManagerDelegate) {
        self.mail = mail
        self.password = password
        self.username = username ?? "Unknown"
        
        delegate = target
        
        switch method {
        case .login:
            login()
        case .register:
            register()
        }
    }
    
    private func login() {
        Auth.auth().signIn(withEmail: mail, password: password) { authResult, error in
            if error != nil {
                self.delegate?.logDidFinish(with: .failed(error!.localizedDescription))
            } else {
                self.delegate?.logDidFinish(with: .successed)
                self.loadDiscussion()
            }
        }
        password = ""
    }
    
    private func register() {
        Auth.auth().createUser(withEmail: mail, password: password) { authResult, error in
            if error != nil {
                self.delegate?.logDidFinish(with: .failed(error!.localizedDescription))
            } else {
                let user = authResult!.user
                self.createUser(for: user)
                self.delegate?.logDidFinish(with: .successed)
            }
        }
        password = ""
    }
    
    private func createUser(for user: User) {
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = username
        changeRequest.commitChanges { (error) in
            assert(error == nil, "Couldn't change display name")
            let userManager = UserManager(user: user)
            userManager.createUserDataBase()
            self.delegate?.userDidLoad(with: .presenting([]))
        }
    }
    
    private func loadDiscussion() {
        var discussions = [Discussion]()
        let user = Auth.auth().currentUser!
        let db = Firestore.firestore()
        db.collection(Constant.FStore.discussionCollection).whereField(Constant.FStore.discussionParticipant, arrayContains: user.email!).order(by: Constant.FStore.date, descending: true).getDocuments { (snapshot, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                discussions = self.extractData(from: snapshot!)
            }
            self.delegate?.userDidLoad(with: .presenting(discussions))
        }
    }
    
    private func extractData(from snapshot: QuerySnapshot) -> [Discussion] {
        var discussions = [Discussion]()
        for doc in snapshot.documents {
            let data = doc.data()
            guard let id = data[Constant.FStore.discussionID] as? String else { break }
            guard let participant = data[Constant.FStore.discussionParticipant] as? [String] else { break }
            guard let time = data[Constant.FStore.date] as? TimeInterval else { break }
            let date = Date(timeIntervalSince1970: time)
            guard let lastMessage = data[Constant.FStore.lastMessageDiscussion] as? String else { break }
            let discussion = Discussion(id: id, to: self.getToUser(in: participant), date: date, lastMessage: lastMessage)
            discussions.append(discussion)
        }
        return discussions
    }
    
    private func getToUser(in participant: [String]) -> String {
        if participant.first! == Auth.auth().currentUser!.email! {
            return participant[1]
        } else {
            return participant[0]
        }
    }

}
