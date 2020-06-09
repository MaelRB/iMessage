//
//  CreateLogicController.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 09/06/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import Foundation

class UserList {
    
    private var orderedUsers = [Int:[MRBUser]]()
    
    subscript(_ index: IndexPath) -> MRBUser {
        get {
            let section = index.section
            let row = index.row
            assert(section < orderedUsers.keys.count, "Section index out of range")
            assert(row < orderedUsers[section]!.count, "Row index out of range")
            return orderedUsers[section]![row]
        }
    }
     
    // MARK: - Interface
    
    func createUsersList(with users: [MRBUser]) {
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
        self.orderedUsers = dico
    }
    
    func getTotalOfKey() -> Int {
        return orderedUsers.keys.count
    }
    
    func getCount(for section: Int) -> Int {
        return orderedUsers[section]!.count
    }
    
    func getSectionTitle(for section: Int) -> String {
        return orderedUsers[section]!.first!.name.first!.uppercased()
    }
    
}
