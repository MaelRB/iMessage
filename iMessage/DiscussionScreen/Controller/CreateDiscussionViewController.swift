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
    
    var parentVC: DiscussionViewController!
    
    private var participants = [MRBUser]() {
        didSet {
            if self.participants.isEmpty {
                navigationItem.rightBarButtonItem?.isEnabled = false
            } else {
                navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
    }
    
    var userList = UserList()
    
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
                self.userList.createUsersList(with: users)
            }
            self.tableView.reloadData()
        }
        
        tableView.register(UserCell.self, forCellReuseIdentifier: "UserCell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
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
        searchController.searchBar.delegate = self
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
    }
    
    func updateCollectionConstraints(_ oldValue: Int) {
        if checkCell.count % 3 == 1 {
            let rows = Int(checkCell.count / 3) + 1
            heightConstraints.constant = CGFloat(55 * rows)
            UIView.animate(withDuration: 0.5) {
                self.collectionView.layoutIfNeeded()
            }
        } else if oldValue > checkCell.count && checkCell.count % 3 == 0 {
            let rows = Int(checkCell.count / 3) 
            heightConstraints.constant = CGFloat(55 * rows)
            UIView.animate(withDuration: 0.5) {
                self.collectionView.layoutIfNeeded()
            }
        }
    }
    
    @objc func done() {
        let discussionServices = DiscussionServices()
        discussionServices.createDiscussion(with: participants) {
            self.parentVC.isNewDiscussionTransition = true
            self.navigationController?.popToViewController(self.parentVC, animated: true)
        }
    }
    
    func createDiscussion() {
    }
    
}

//MARK: - Table view delegate & data source methods
extension CreateDiscussionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return userList.getTotalOfKey()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.getCount(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        cell.setup()
        let user = userList[indexPath]
        cell.setName(user.name)
        cell.setMail(user.mail)
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
            participants.removeAll { (user) -> Bool in
                self.userList[indexPath].mail == user.mail
            }
        } else {
            checkCell.append(indexPath)
            participants.append(userList[indexPath])
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return userList.getSectionTitle(for: section)
    }
}

//MARK: - Collection view deleagte & data source methods

extension CreateDiscussionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return checkCell.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCollection", for: indexPath) as! UserCollectionViewCell
        let indexPath = checkCell[indexPath.item]
        let user = userList[indexPath]
        cell.setup(name: user.name, photoString: user.photoUrl)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 80) / 3
        return CGSize(width: width, height: 30)
    }
}

extension CreateDiscussionViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let research = searchBar.text!
        for user in users {
            if user.mail == research && isAlreadyAdd(research) == false {
                participants.append(user)
                do {
                    let indexPath = try userList.getIndexPath(for: user)
                    updateCheckCell(for: indexPath)
                }
                catch {
                    print(error)
                }
                break
            }
        }
    }
    
    func isAlreadyAdd(_ mail: String) -> Bool {
        for user in participants {
            if mail == user.mail {
                return true
            }
        }
        return false
    }
    
    func updateCheckCell(for indexPath: IndexPath) {
        checkCell.append(indexPath)
        tableView.reloadData()
        collectionView.reloadData()
    }
}
