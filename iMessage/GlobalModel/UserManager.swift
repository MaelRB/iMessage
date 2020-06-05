//
//  UserManager.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 05/06/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import Foundation
import Firebase

class UserManager {
    
    private var user: User
    
    init(user: User) {
        self.user = user
    }
    
    func createUserDataBase() {
        let dataBase = Firestore.firestore()
        dataBase.collection(Constant.FStore.usersCollection).addDocument(data: [Constant.FStore.userName: user.displayName!,
             Constant.FStore.userMail: user.email!,
             Constant.FStore.userPhoto: user.photoURL ?? "undefined"])
    }

}
