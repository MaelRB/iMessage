//
//  User.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 11/05/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import Foundation

class User {
    
    var mail: String
    var username: String
    
    init(mail: String, username: String?) {
        self.mail = mail
        self.username = username ?? "[unknown]"
    }
}
