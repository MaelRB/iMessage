//
//  LogScreenLogicController.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 27/05/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import UIKit

class LogScreenLogicController {
    let dbCommunication = DBCommunication.sharedInstance
    
    func log(email: String, password: String, for method: AuthMethod , then handler: @escaping (DBState, [Discussion]?) -> Void) {
        switch method {
        case .login:
            DBCommunication.login(email: email, password: password) { (state) in
                self.dbCommunication.loadDiscussion { (discussions) in
                    handler(state, discussions)
                }
            }
        case .register:
            DBCommunication.register(email: email, password: password) { (state) in
                handler(state, nil)
            }
        }
    }
    
    
}
