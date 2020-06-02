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
    
    var view: UIView!
    var body: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView() {
        let width = Constant.CellSize.cellWidth
        let height = contentView.frame.height * 0.8
        view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        view.widthAnchor.constraint(equalToConstant: width).isActive = true
        view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        view.layer.cornerRadius = view.frame.height / 2
    }
    
    func setupBody() {
        body = UILabel(frame: CGRect(x: 10, y: 5, width: view.frame.width - 20, height: view.frame.height - 10))
        view.addSubview(body)
    }
    
    func configure(_ message: Message) {
        
        setupView()
        if message.sender == Auth.auth().currentUser!.email! {
            view.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
            view.backgroundColor = Constant.Color.sendMessage
            setupBody()
            body.text = message.body
            body.textColor = .white
        } else {
            view.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
            view.backgroundColor = Constant.Color.receiveMessage
            setupBody()
            body.text = message.body
            body.textColor = .black
        }
    }
    
    override func prepareForReuse() {
        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }
    }
}
