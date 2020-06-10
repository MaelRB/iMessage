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
    
    var discussions = [Discussion]()
    
    let user = Auth.auth().currentUser!
    
    var dataManager: DataManager!
    
    var isNewDiscussionTransition = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.isHidden = false
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(logoutUser))
        navigationController?.navigationBar.tintColor = Constant.Color.tappable
        
        view.backgroundColor = Constant.Color.background
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DiscussionCell.self, forCellReuseIdentifier: "discussionCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = Constant.Color.background
        
        self.title = "Messages"
        
        dataManager = DataManager(user: user)
        dataManager.addDiscussionListener { (discussions) in
            self.discussions = discussions
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setCreateDiscussionButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if isNewDiscussionTransition == true {
            isNewDiscussionTransition = false
            DispatchQueue.main.async {
                self.tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
                self.performSegue(withIdentifier: "goToDiscussion", sender: self)
                self.tableView.deselectRow(at: IndexPath(row: 0, section: 0), animated: false)
            }
        }
        
    }
    
    func setCreateDiscussionButton() {
        let targetView = self.navigationController?.navigationBar
        let rightButton = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 18)
        rightButton.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: config), for: .normal)
        rightButton.addTarget(self, action: #selector(addDiscussion), for: .touchUpInside)
        navigationController?.navigationBar.addSubview(rightButton)
        rightButton.tag = 1
        rightButton.backgroundColor = Constant.Color.tappable
        rightButton.tintColor = Constant.Color.background

//        rightButton.layer.cornerRadius = (targetView!.frame.height * 0.66) / 2
        rightButton.layer.cornerRadius = (44 * 0.66) / 2
        
        let trailingContraint = NSLayoutConstraint(item: rightButton, attribute:
            .trailingMargin, relatedBy: .equal, toItem: targetView, attribute: .trailingMargin, multiplier: 1.0, constant: -20)
        let bottomConstraint = NSLayoutConstraint(item: rightButton, attribute: .bottom, relatedBy: .equal, toItem: targetView, attribute: .bottom, multiplier: 1.0, constant: -15)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([trailingContraint, bottomConstraint])
//        rightButton.heightAnchor.constraint(equalToConstant: targetView!.frame.height * 0.66).isActive = true
        rightButton.heightAnchor.constraint(equalToConstant: 44 * 0.66).isActive = true
//        rightButton.widthAnchor.constraint(equalToConstant: targetView!.frame.height * 0.66).isActive = true
        rightButton.widthAnchor.constraint(equalToConstant: 44 * 0.66).isActive = true
    }
    
    @objc func addDiscussion() {
        weak var vc = storyboard?.instantiateViewController(identifier: "createDiscussion") as? CreateDiscussionViewController
        vc?.parentVC = self
        show(vc!, sender: self)
    }
    
    @objc func logoutUser() {
        let logoutManger = LogoutManager()
        logoutManger.logout {
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
        cell.setName(discussions[indexPath.row].to)
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
            dataManager.deleteDiscussion(eltRemoved)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
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

