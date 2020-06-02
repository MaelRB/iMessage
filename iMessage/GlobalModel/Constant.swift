//
//  Constant.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 11/05/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import Foundation
import UIKit.UIScreen
import ChameleonFramework

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
        static let lastMessageDiscussion = "lastMessage"
        static let messagesCollection = "messages"
        static let messageBody = "body"
        static let date = "date"
        static let messageSender = "sender"
    }
    
    struct CellSize {
        static let cellHeight = UIScreen.main.bounds.size.height * 0.06
        static let cellWidth = UIScreen.main.bounds.size.width * 0.8
    }
    
    struct Color {
        static let background = UIColor(displayP3Red: 0.99, green: 0.99, blue: 1, alpha: 1)
        
        // Used for tappable element like button. It's better for the UX to have only one same color through the entire app for tappabale elements.
        static let tappable = UIColor.flatMint()
        
        // Used for layer color (shadow and border)
        static let MRBGrey = UIColor(displayP3Red: 0.53, green: 0.58, blue: 0.66, alpha: 1)
        
        // The text color
        static let navyBlue = UIColor.flatNavyBlue()
        
        static let button = UIColor.flatMint()
        
        // Gradient for the check button
        let darkGreen = UIColor(displayP3Red: 0.37, green: 0.78, blue: 0.77, alpha: 1)
        let lightGreen = UIColor(displayP3Red: 0.43, green: 0.89, blue: 0.67, alpha: 1)
        static let buttonGradient = { (rect: CGRect) -> UIColor in
            return UIColor(gradientStyle: .leftToRight, withFrame: rect, andColors: [Color().darkGreen, Color().lightGreen])
        }
        
        // Gradient for the top shape
        let lightOrange = UIColor(displayP3Red: 0.93, green: 0.65, blue: 0.42, alpha: 1)
        let darkOrange = UIColor(displayP3Red: 0.90, green: 0.44, blue: 0.38, alpha: 1)
        static let topCurveGradient = { (rect: CGRect) -> UIColor in
            return UIColor(gradientStyle: .leftToRight, withFrame: rect, andColors: [Color().lightOrange, Color().darkOrange])
        }
        
        // Gradient for the bottom shape
        let lightCyan = UIColor(displayP3Red: 0.42, green: 0.91, blue: 0.97, alpha: 1)
        let darkCyan = UIColor(displayP3Red: 0.40, green: 0.65, blue: 0.96, alpha: 1)
        static let bottomCurveGradient = { (rect: CGRect) -> UIColor in
            return UIColor(gradientStyle: .leftToRight, withFrame: rect, andColors: [Color().lightCyan, Color().darkCyan])
        }
        
        static let sendMessage = UIColor(displayP3Red: 0.29, green: 0.58, blue: 0.96, alpha: 1)
        static let receiveMessage = UIColor(displayP3Red: 0.91, green: 0.91, blue: 0.92, alpha: 1)
    }
    
    
    struct Size {
        // This size is used for reference for stackView or check button size
        static let textFieldSize = CGSize(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.075)
    }
    
    struct Font {
        static let textFont: UIFont = .systemFont(ofSize: 18)
        static let placeolderFont: UIFont = .systemFont(ofSize: 16)
        static let titleFont: UIFont = .boldSystemFont(ofSize: 34)
    }
}
