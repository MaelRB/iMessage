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
    private var dateLabel: UILabel!
    
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
//        let config = UIImage.SymbolConfiguration(pointSize: 16)
//        logoImage.image = UIImage(systemName: "person.circle", withConfiguration: config)
        logoImage.image = UIImage(named: "profil2")
        logoImage.tintColor = .black
        logoImage.contentMode = .scaleAspectFill
        logoImage.layer.cornerRadius = logoSize / 2
        logoImage.layer.masksToBounds = true
        setLogoConstraints()
    }
    
    private func setLogoConstraints() {
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        addSubview(logoImage)
        logoImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        logoImage.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        logoImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        logoImage.widthAnchor.constraint(equalToConstant: logoSize).isActive = true
    }
    
    private func setName() {
        backgroundColor = Constant.Color.background
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
        nameLabel.heightAnchor.constraint(equalToConstant: logoSize / 3).isActive = true
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
        dateLabel = UILabel()
        dateLabel.text = "9:42"
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textAlignment = .right
        setDateConstraints()
    }
    
    private func setDateConstraints() {
        addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: logoSize / 2).isActive = true
    }
    
    // MARK: - Interface
    
    func setName(_ name: String) {
        nameLabel.text = name
    }
    
    func setLastMessage(_ name: String) {
        lastMessageLabel.text = name
    }
    
    func setDate(_ date: Date) {
        let dateFormatter = DateFormatter()
        if isLessThanDay(date) {
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
        } else {
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
        }
        
        dateLabel.text = dateFormatter.string(from: date)
    }
    
    private func isLessThanDay(_ date: Date) -> Bool {
        return date.timeIntervalSince1970 - Date().timeIntervalSince1970 <= 86_400 ? true : false
    }
    
    override func prepareForReuse() {
        logoImage.removeFromSuperview()
        nameLabel.removeFromSuperview()
        lastMessageLabel.removeFromSuperview()
        dateLabel.removeFromSuperview()
    }
}
