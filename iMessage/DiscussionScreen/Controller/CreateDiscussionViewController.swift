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
    }
    
}
