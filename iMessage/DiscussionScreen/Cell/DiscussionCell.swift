//
//  DiscussionCell.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 30/05/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import UIKit

class DiscussionCell: UITableViewCell {
    
    // MARK: - UI elements
    private var logoImage: UIImageView!
    private var nameLabel: UILabel!
    private var lastMessageLabel: UILabel!
    private var date: UILabel!
    
    var logoSize: CGFloat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup() {
        logoSize = frame.height - 30
        setLogo()
        setName()
        setLastMessage()
        setDate()
    }
    
    private func setLogo() {
        logoImage = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 16)
        logoImage.image = UIImage(systemName: "person.circle", withConfiguration: config)
        logoImage.tintColor = .black
        logoImage.layer.cornerRadius = logoSize / 2
        setLogoConstraints()
    }
    
    private func setLogoConstraints() {
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        addSubview(logoImage)
        logoImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        logoImage.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        logoImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
        logoImage.widthAnchor.constraint(equalToConstant: logoSize).isActive = true
    }
    
    private func setName() {
        nameLabel = UILabel()
        nameLabel.text = "Name"
        nameLabel.font = .boldSystemFont(ofSize: 16)
        setNameConstraints()
    }
    
    private func setNameConstraints() {
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leftAnchor.constraint(equalTo: logoImage.rightAnchor, constant: 10).isActive = true
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: logoSize / 2).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    private func setLastMessage() {
        lastMessageLabel = UILabel()
        lastMessageLabel.text = "Hey !! What's up ?"
        lastMessageLabel.font = .systemFont(ofSize: 16)
        setLastMessageConstraints()
    }
    
    private func setLastMessageConstraints() {
        addSubview(lastMessageLabel)
        lastMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        lastMessageLabel.leftAnchor.constraint(equalTo: logoImage.rightAnchor, constant: 10).isActive = true
        lastMessageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
        lastMessageLabel.heightAnchor.constraint(equalToConstant: logoSize / 2).isActive = true
        lastMessageLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    private func setDate() {
        date = UILabel()
        date.text = "9:42"
        date.font = .systemFont(ofSize: 14)
        setDateConstraints()
    }
    
    private func setDateConstraints() {
        addSubview(date)
        date.translatesAutoresizingMaskIntoConstraints = false
        date.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        date.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        date.widthAnchor.constraint(equalToConstant: 50).isActive = true
        date.heightAnchor.constraint(equalToConstant: logoSize / 2).isActive = true
    }
}
