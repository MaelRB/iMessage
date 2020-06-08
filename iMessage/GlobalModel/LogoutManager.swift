//
//  LogoutManager.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 06/06/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import Foundation
import Firebase

class LogoutManager {
    
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
    
}
