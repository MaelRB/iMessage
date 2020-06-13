//
//  ProfilMenuViewController.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 13/06/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import UIKit

class ProfilMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
        
        tabBarController?.tabBar.tintColor = Constant.Color.tappable
    }

}
