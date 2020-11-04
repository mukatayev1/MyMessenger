//
//  Message.swift
//  MyMessenger
//
//  Created by AZM on 2020/10/29.
//

import Firebase
import UIKit

struct Message {
    let text: String
    let toID: String
    let fromID: String
    let timestamp: Timestamp!
    var user: User?
    
    var chatPartnerID: String {
        return isFromCurrentUser ? toID : fromID
    }
    
    let isFromCurrentUser: Bool
    
    //initialization method
    init(dictionary: [String: Any]) {
        
        self.text = dictionary["text"] as? String ?? ""
        self.toID = dictionary["toID"] as? String ?? ""
        self.fromID = dictionary["fromID"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        
        self.isFromCurrentUser = fromID == Auth.auth().currentUser?.uid
        
    }
}

