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
    
    var userServices: UserServices!
    var users = [MRBUser]()
    var checkCell = [IndexPath]() {
        didSet {
            updateCollectionConstraints()
            collectionView.reloadData()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    // MARK: - View methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        craeteSearchBar()
        
        userServices = UserServices()
        userServices.getListOfUser { [weak self] (users) in
            self?.users = users
            self?.tableView.reloadData()
        }
        
        tableView.register(UserCell.self, forCellReuseIdentifier: "UserCell")
        
//        setCollectionView()
        
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
    
    func updateCollectionConstraints() {
//        if checkCell.count % 2 == 1 {
//            let rows = Int(checkCell.count / 2)
//
//            UIView.animate(withDuration: 0.5) {
//
//            }
//        }
        collectionView.layoutIfNeeded()
    }
    
//    func setCollectionView() {
//        let width = view.frame.width - 40
//        let y = navigationController?.navigationBar.frame.maxY
//        collectionView.frame = CGRect(x: 20, y: y!, width: width, height: 50)
//    }
}

extension CreateDiscussionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        cell.setup()
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: .zero)
        view.backgroundColor = Constant.Color.background
        return view
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
}

extension CreateDiscussionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return checkCell.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCollection", for: indexPath) as! UserCollectionViewCell
        let user = users[indexPath.item]
        cell.setup(name: user.name, photoString: user.photoUrl)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 30)
    }
    
    
}
