//
//  CraeteDiscussionViewController.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 12/05/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import UIKit
import Firebase

class CreateDiscussionViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    var discussions = [Discussion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textField.layer.borderWidth = 1
    }

    @IBAction func createButtonTapped(_ sender: Any) {
        if isDiscussionAlreadyExist() {
            textField.layer.borderColor = UIColor.red.cgColor
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.textField.layer.borderColor = UIColor.black.cgColor
            }
        } else {
            creatDiscussion()
        }
    }
    
    func creatDiscussion() {
        let db = Firestore.firestore()
        
        let id = db.collection(Constant.FStore.discussionCollection).addDocument(data: [
            Constant.FStore.discussionParticipant: [Auth.auth().currentUser!.email!, textField.text!],
            Constant.FStore.date: Date().timeIntervalSince1970]
        ).documentID
        
        db.collection(Constant.FStore.discussionCollection).document(id).updateData([Constant.FStore.discussionID: id])
        
        dismiss(animated: true, completion: nil)
    }
    
    func isDiscussionAlreadyExist() -> Bool {
        for discussion in discussions {
            if discussion.to.email == textField.text {
                return true
            }
        }
        return false
    }
    
}
