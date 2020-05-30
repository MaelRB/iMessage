//
//  MessagesViewController.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 11/05/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import UIKit
import Firebase

class DiscussionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let dbCommunication = DBCommunication()
    
    var discussions = [Discussion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.isHidden = false
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(logoutUser))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(addDiscussion))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(DiscussionCell.self, forCellReuseIdentifier: "discussionCell")
        tableView.separatorStyle = .none
        
        loadDiscussion()
        
        self.title = "Messages"
        
    }
    
    @objc func addDiscussion() {
        weak var vc = storyboard?.instantiateViewController(identifier: "createDiscussion") as? CreateDiscussionViewController
        vc?.discussions = discussions
        showDetailViewController(vc!, sender: self)
    }
    
    //MARK: - Firebase methods
    
    func loadDiscussion() {
        dbCommunication.loadDiscussion { (discussions) in
            self.discussions = discussions
            self.tableView.reloadData()
        }
    }
    
    @objc func logoutUser() {
        dbCommunication.logout {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    //MARK: - Segue methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDiscussion" {
            let row = tableView.indexPathForSelectedRow!.row
            if let vc = segue.destination as? MessageViewController {
                vc.discussion = discussions[row]
            }
        }
    }
}

// MARK: - TableView delegate & data source methods
extension DiscussionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discussions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "discussionCell", for: indexPath) as! DiscussionCell
//        cell.textLabel?.text = discussions[indexPath.row].to.pseudo
        cell.setup()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDiscussion", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let eltRemoved = discussions.remove(at: indexPath.row)
            dbCommunication.deleteDiscussion(eltRemoved)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

