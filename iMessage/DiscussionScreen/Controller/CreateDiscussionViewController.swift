//
//  CraeteDiscussionViewController.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 12/05/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import UIKit
import Firebase

class CreateDiscussionViewController: UIViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightConstraints: NSLayoutConstraint!
    
    var userServices: UserServices!
    var users = [MRBUser]()
    var checkCell = [IndexPath]() {
        didSet {
            updateCollectionConstraints(oldValue.count)
            collectionView.reloadData()
        }
    }
    
    var orderedUsers = [Int:[MRBUser]]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    // MARK: - View methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        craeteSearchBar()
        
        userServices = UserServices()
        userServices.getListOfUser { [weak self] (users) in
            guard let self = self else { return }
            self.users = users
            if self.users.isEmpty == false {
                self.orderedUsers = self.createOrderdUsersList()
            }
            self.tableView.reloadData()
        }
        
        tableView.register(UserCell.self, forCellReuseIdentifier: "UserCell")
        
        heightConstraints.constant = 0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        removeRightButton()
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    // MARK: - Setup
    
    func craeteSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func removeRightButton(){
        guard let subviews = self.navigationController?.navigationBar.subviews else { return }
        for view in subviews {
            if view.tag != 0 {
                view.removeFromSuperview()
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // to do
    }
    
    func updateCollectionConstraints(_ oldValue: Int) {
        if checkCell.count % 2 == 1 {
            let rows = Int(checkCell.count / 2) + 1
            heightConstraints.constant = CGFloat(40 * rows)
            UIView.animate(withDuration: 0.5) {
                self.collectionView.layoutIfNeeded()
            }
        } else if oldValue > checkCell.count && checkCell.count % 2 == 0 {
            let rows = Int(checkCell.count / 2) 
            heightConstraints.constant = CGFloat(40 * rows)
            UIView.animate(withDuration: 0.5) {
                self.collectionView.layoutIfNeeded()
            }
        }
    }
    
    func createOrderdUsersList() -> [Int:[MRBUser]] {
        var dico = [Int:[MRBUser]]()
        let orderUsers = users.sorted { (user1, user2) -> Bool in
            user1.name.capitalized < user2.name.capitalized
        }
        
        var key = 0
        var firstLetter = orderUsers.first!.name.first
        
        dico.updateValue([], forKey: key)
        for user in orderUsers {
            if user.name.first == firstLetter {
                dico[key]?.append(user)
            } else {
                key += 1
                firstLetter = user.name.first
                dico.updateValue([], forKey: key)
                dico[key]?.append(user)
            }
        }
        return dico
    }
    
}

extension CreateDiscussionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return orderedUsers.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderedUsers[section]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        cell.setup()
        let users = orderedUsers[indexPath.section]!
        cell.setName(users[indexPath.row].name)
        cell.setMail(users[indexPath.row].mail)
        if checkCell.contains(indexPath) {
            cell.isCheck = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UserCell
        cell.cellTapped()
        tableView.deselectRow(at: indexPath, animated: false)
        if checkCell.contains(indexPath) {
            checkCell.removeAll { (index) -> Bool in
                indexPath == index
            }
        } else {
            checkCell.append(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return orderedUsers[section]?.first!.name.first!.uppercased()
    }
}

extension CreateDiscussionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return checkCell.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCollection", for: indexPath) as! UserCollectionViewCell
        let indexPath = checkCell[indexPath.item]
        let user = orderedUsers[indexPath.section]![indexPath.row]
        cell.setup(name: user.name, photoString: user.photoUrl)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 125, height: 30)
    }
    
    
}
