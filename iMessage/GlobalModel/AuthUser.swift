//
//  AuthMethod.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 04/06/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import Foundation
import Firebase

protocol LogServices {
    typealias Handler = (LogState) -> Void
    func login(then handler: @escaping Handler)
    func register(then handler: @escaping Handler)
    func logout(then handler: @escaping () -> Void)
}

class AuthUser: User, LogServices {
    
    private var password: String?
    var discussion = [Discussion]()
    
    init(mail: String, username: String?, password: String) {
        super.init(mail: mail, username: username)
        self.password = password
    }
    
    func deletePassword() {
        self.password = nil
    }
    
    func login(then handler: @escaping Handler) {
        Auth.auth().signIn(withEmail: mail, password: password!) { authResult, error in
            if error != nil {
                handler(.failed(error!.localizedDescription))
            } else {
                handler(.load(self))
            }
        }
        password = nil
    }
    
    func register(then handler: @escaping Handler) {
        Auth.auth().createUser(withEmail: mail, password: password!) { authResult, error in
            if error != nil {
                handler(.failed(error!.localizedDescription))
            } else {
                handler(.presenting(self))
            }
        }
        password = nil
    }
    
    func logout(then handler: @escaping () -> Void) {
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

}
