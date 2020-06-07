//
//  UserCell.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 06/06/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    // MARK: - UI elements
    private var logoImage: UIImageView!
    private var nameLabel: UILabel!
    private var mailLabel: UILabel!
    private var checkbox: UIView!
    
    var logoSize: CGFloat!
    var checkboxSize: CGFloat!
    
    var isCheck = false {
        didSet {
            if oldValue == false {
                addCheckmark()
            } else {
                removeCheckmark()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup() {
        logoSize = frame.height - 15
        checkboxSize = frame.height / 3
        setLogo()
        setName()
        setMailLabel()
        setCheckbox()
        selectionStyle = .none
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
        logoImage.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        logoImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
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
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: logoSize / 3).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
        
    private func setMailLabel() {
        mailLabel = UILabel()
        mailLabel.text = ""
        mailLabel.font = .systemFont(ofSize: 14)
        setLastMessageConstraints()
    }
        
    private func setLastMessageConstraints() {
        addSubview(mailLabel)
        mailLabel.translatesAutoresizingMaskIntoConstraints = false
        mailLabel.leftAnchor.constraint(equalTo: logoImage.rightAnchor, constant: 10).isActive = true
        mailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        mailLabel.heightAnchor.constraint(equalToConstant: logoSize / 2).isActive = true
        mailLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    private func setCheckbox() {
        checkbox = UIView()
        checkbox.backgroundColor = .clear
        checkbox.layer.cornerRadius = checkboxSize / 2
        checkbox.layer.borderColor = Constant.Color.tappable?.cgColor
        checkbox.layer.borderWidth = 1
        setCheckboxConstraints()
    }
    
    private func setCheckboxConstraints() {
        addSubview(checkbox)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        checkbox.heightAnchor.constraint(equalToConstant: checkboxSize).isActive = true
        checkbox.widthAnchor.constraint(equalToConstant: checkboxSize).isActive = true
        checkbox.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func addCheckmark() {
        let config = UIImage.SymbolConfiguration(weight: .heavy)
        let imageView = UIImageView(frame: CGRect(x: checkboxSize / 4, y: checkboxSize / 4, width: checkboxSize / 2, height: checkboxSize / 2))
        imageView.tintColor = Constant.Color.background
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.image = UIImage(systemName: "checkmark", withConfiguration: config)
        checkbox.addSubview(imageView)
        checkbox.backgroundColor = Constant.Color.tappable
    }
    
    private func removeCheckmark() {
        for subview in checkbox.subviews {
            subview.removeFromSuperview()
        }
        checkbox.backgroundColor = Constant.Color.background
    }
        
    // MARK: - Interface
    
    func setName(_ name: String) {
        nameLabel.text = name
    }
        
    func setMail(_ name: String) {
        mailLabel.text = name
    }
    
    func cellTapped() {
        isCheck = !isCheck
    }
        
    override func prepareForReuse() {
        logoImage.removeFromSuperview()
        nameLabel.removeFromSuperview()
        mailLabel.removeFromSuperview()
    }
}
    
