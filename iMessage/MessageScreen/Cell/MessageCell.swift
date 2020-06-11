//
//  DiscussionCell.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 11/05/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import UIKit
import Firebase

class MessageCell: UITableViewCell {

    var body = UILabel()
    var bubbleBackground = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(bubbleBackground)
        addSubview(body)
        body.numberOfLines = 0
        body.translatesAutoresizingMaskIntoConstraints = false
        
        bubbleBackground.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackground.layer.cornerRadius = 5
        
        let constraints = [body.topAnchor.constraint(equalTo: topAnchor, constant: 28),
                           body.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -28),
                           bubbleBackground.topAnchor.constraint(equalTo: body.topAnchor, constant: -12),
                           bubbleBackground.leftAnchor.constraint(equalTo: body.leftAnchor, constant: -12),
                           bubbleBackground.rightAnchor.constraint(equalTo: body.rightAnchor, constant: 12),
                           bubbleBackground.bottomAnchor.constraint(equalTo: body.bottomAnchor, constant: 12),
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBody() {
        let height = body.getHeight(with: contentView.frame.width - 20)
        body.frame = CGRect(x: 10, y: 5, width: contentView.frame.width - 20, height: height)
        body.numberOfLines = 0
    }
    
    func configure(_ message: Message) {
        body.text = message.body
        
        if message.sender == Auth.auth().currentUser!.email! {
            body.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.66).isActive = true
            body.rightAnchor.constraint(equalTo: rightAnchor, constant: -28).isActive = true
            bubbleBackground.backgroundColor = Constant.Color.sendMessage
            body.textColor = .white
            
        } else {
            body.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.66).isActive = true
            body.leftAnchor.constraint(equalTo: leftAnchor, constant: 28).isActive = true
            bubbleBackground.backgroundColor = Constant.Color.receiveMessage
            body.textColor = .black
        }
    }
    
    override func prepareForReuse() {
        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }
    }
}
