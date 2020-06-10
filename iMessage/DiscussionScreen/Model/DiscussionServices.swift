//
//  DiscussionServices.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 10/06/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import Foundation
import Firebase

class DiscussionServices {
    
    let dataBase = Firestore.firestore()
    
    func createDiscussion(with participants: [MRBUser], completion: @escaping () -> Void) {
        var participantsMail = [Auth.auth().currentUser?.email]
        for user in participants {
            participantsMail.append(user.mail)
        }
        
        let id = dataBase.collection(Constant.FStore.discussionCollection).addDocument(data: [
            Constant.FStore.discussionParticipant: participantsMail,
            Constant.FStore.date: Date().timeIntervalSince1970,
            Constant.FStore.lastMessageDiscussion: ""]
        ).documentID
            
        // Get the id of the discussion. It's used to send a message to the good discussion
        dataBase.collection(Constant.FStore.discussionCollection).document(id).updateData([Constant.FStore.discussionID: id])
        completion()
    }
    
   
}
