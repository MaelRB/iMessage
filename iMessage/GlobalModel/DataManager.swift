//
//  DataManager.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 06/06/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import Foundation
import Firebase

class DataManager {
    
    var user: User
    let db = Firestore.firestore()
    
    init(user: User) {
        self.user = user
    }
    
    func addDiscussionListener(completion: @escaping ([Discussion]) -> Void) {
        var discussions = [Discussion]()
        let user = Auth.auth().currentUser!
    
        db.collection(Constant.FStore.discussionCollection).whereField(Constant.FStore.discussionParticipant, arrayContains: user.email!).order(by: Constant.FStore.date, descending: true).addSnapshotListener { (snapshot, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                discussions = self.extractData(from: snapshot!)
            }
            completion(discussions)
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
            guard let title = data[Constant.FStore.discussionTitle] as? String else { break }
            let discussion = Discussion(id: id, to: self.getToUser(in: participant), date: date, lastMessage: lastMessage, title: title)
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
    
    func deleteDiscussion(_ discussion: Discussion) {
        db.collection(Constant.FStore.discussionCollection).document(discussion.id).delete { (error) in
            if error != nil {
                print(error!)
            }
        }
    }
    
    
}
