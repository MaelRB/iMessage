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
    
    let db = Firestore.firestore()
    
    var discussions = [Discussion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(logoutUser))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(addDiscussion))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadDiscussion()
        
    }
    
    @objc func addDiscussion() {
        weak var vc = storyboard?.instantiateViewController(identifier: "createDiscussion") as? CreateDiscussionViewController
        vc?.discussions = discussions
        showDetailViewController(vc!, sender: self)
    }
    
    //MARK: - Firebase methods
    
    func loadDiscussion() {
        let discussionRef = db.collection(Constant.FStore.discussionCollection).whereField(Constant.FStore.discussionParticipant, arrayContains: Auth.auth().currentUser!.email!)
        discussionRef.order(by: Constant.FStore.date, descending: true).addSnapshotListener { (snapshot, error) in
            self.discussions = []
            if error != nil {
                print(error!.localizedDescription)
            } else {
                for doc in snapshot!.documents {
                    let data = doc.data()
                    guard let participant = data[Constant.FStore.discussionParticipant] as? [String] else { return }
                    guard let user = self.getParticipant(of: participant) else { return }
                    guard let id = data[Constant.FStore.discussionID] as? String else { return }
                    let discussion = Discussion(id: id, to: user)
                    self.discussions.append(discussion)
                
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }

    }
    
    func getParticipant(of part: [String]) -> User? {
        var toHimself = 0
        for user in part {
            if user != Auth.auth().currentUser!.email! {
                for contact in Constant.Contact.listOfContacts {
                    if contact.email == user {
                        return contact
                    }
                }
            } else {
                toHimself += 1
            }
        }
        if toHimself == part.count {
            for contact in Constant.Contact.listOfContacts {
                if contact.email == Auth.auth().currentUser!.email {
                    return contact
                }
            }
        }
        return nil
    }
    
    @objc func logoutUser() {
        let firebaseAuth = Auth.auth()
        do {
           try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        }
        catch
            let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func removeDiscussionFromFirestore(_ discussionID: String) {
        db.collection(Constant.FStore.discussionCollection).document(discussionID).delete { (error) in
            if error != nil {
                print(error!)
            }
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

extension DiscussionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discussions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = discussions[indexPath.row].to.pseudo
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDiscussion", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let eltRemoved = discussions.remove(at: indexPath.row)
            removeDiscussionFromFirestore(eltRemoved.id)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

