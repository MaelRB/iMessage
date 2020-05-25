//
//  Constant.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 11/05/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import Foundation
import UIKit.UIScreen

struct Constant {
    
    struct Contact {
        static var listOfContacts = [
            User(pseudo: "admin", email: "1@2.com"),
            User(pseudo: "Bob", email: "0@0.com"),
            User(pseudo: "Alice", email: "1@1.com")]
    }
    
    struct FStore {
        static let discussionCollection = "discussion"
        static let discussionParticipant = "participant"
        static let discussionID = "id"
        static let messagesCollection = "messages"
        static let messageBody = "body"
        static let date = "date"
        static let messageSender = "sender"
    }
    
    struct CellSize {
        static let cellHeight = UIScreen.main.bounds.size.height * 0.06
        static let cellWidth = UIScreen.main.bounds.size.width * 0.8
    }
}
