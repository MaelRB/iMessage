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
        
        view.backgroundColor = Constant.Color.background
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DiscussionCell.self, forCellReuseIdentifier: "discussionCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = Constant.Color.background
        
        loadDiscussion()
        
        self.title = "Messages"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setCreateDiscussionButton()
    }
    
    func setCreateDiscussionButton() {
        let rightButton = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 24)
        rightButton.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: config), for: .normal)
        rightButton.addTarget(self, action: #selector(addDiscussion), for: .touchUpInside)
        navigationController?.navigationBar.addSubview(rightButton)
        rightButton.tag = 1
        rightButton.frame = CGRect(x: self.view.frame.width, y: 0, width: 120, height: 20)

        let targetView = self.navigationController?.navigationBar

        let trailingContraint = NSLayoutConstraint(item: rightButton, attribute:
            .trailingMargin, relatedBy: .equal, toItem: targetView, attribute: .trailingMargin, multiplier: 1.0, constant: -20)
        let bottomConstraint = NSLayoutConstraint(item: rightButton, attribute: .bottom, relatedBy: .equal, toItem: targetView, attribute: .bottom, multiplier: 1.0, constant: -15)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([trailingContraint, bottomConstraint])
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
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
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
        cell.setup()
        cell.setName(discussions[indexPath.row].to.pseudo)
        cell.setLastMessage(discussions[indexPath.row].lastMessage)
        cell.setDate(discussions[indexPath.row].date)
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: .zero)
        view.backgroundColor = Constant.Color.background
        return view
    }
    
    
}

