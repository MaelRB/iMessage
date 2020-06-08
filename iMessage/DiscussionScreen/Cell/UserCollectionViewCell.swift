//
//  UserCollectionViewCell.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 07/06/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logoView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        commonInit()
    }
    
    private func commonInit() {
        logoView.layer.cornerRadius = 13
        backgroundColor = Constant.Color.tappable
        layer.cornerRadius = 15
        
        logoView.frame = CGRect(x: 2, y: 2, width: 26, height: 26)
        nameLabel.frame = CGRect(x: 35, y: 2, width: frame.width - 40, height: 26)
    }
    
    func setup(name: String, photoString: String) {
        nameLabel.text = name
        logoView.image = UIImage(named: "profil2")
    }

}
