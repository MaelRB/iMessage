//
//  UserManager.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 06/06/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import Foundation
import Firebase

class UserServices {
    
    let db = Firestore.firestore()

    func getListOfUser(completion: @escaping ([MRBUser]) -> Void)  {
        var users = [MRBUser]()
        db.collection(Constant.FStore.usersCollection).getDocuments { (snapshot, error) in
            if error != nil {
                print(error!)
            } else {
                users = self.extractDataWithoutAuthUser(in: snapshot!)
            }
            completion(users)
        }
    }
    
    private func extractDataWithoutAuthUser(in snapshot: QuerySnapshot) -> [MRBUser] {
        var users = [MRBUser]()
        for doc in snapshot.documents {
            let data = doc.data()
            guard let name = data[Constant.FStore.userName] as? String else { break }
            guard let mail = data[Constant.FStore.userMail] as? String else { break }
            guard let photoUrl = data[Constant.FStore.userPhoto] as? String else { break }
            if mail != Auth.auth().currentUser!.email! {
                users.append(MRBUser(name: name, mail: mail, photoUrl: photoUrl))
            }
        }
        return users
    }
}
