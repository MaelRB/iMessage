//
//  LogScreenLogicController.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 27/05/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import UIKit

class LogScreenLogicController {
    typealias Handler = (DBState) -> Void
    
    func log(email: String, password: String, with state: LogScreenState, then handler: @escaping Handler) {
        switch state {
        case .login:
            DBCommunication.login(email: email, password: password) { (state) in
                handler(state)
            }
        case .register:
            DBCommunication.register(email: email, password: password) { (state) in
                handler(state)
            }
        }
    }
}
