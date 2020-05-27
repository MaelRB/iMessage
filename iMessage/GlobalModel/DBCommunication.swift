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
    
    static func register(email: String, password: String, then handler: @escaping Handler) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                handler(.failed(error!))
            } else {
                handler(.successed)
            }
        }
    }
    
    static func login(email: String, password: String, then handler: @escaping Handler) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if error != nil {
                handler(.failed(error!))
            } else {
                handler(.successed)
            }
        }
    }
}
