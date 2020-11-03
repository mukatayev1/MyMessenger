//
//  MessageVM.swift
//  MyMessenger
//
//  Created by AZM on 2020/10/29.
//

import UIKit

//MARK: - MessageVM

//This View Model acts as a brain of the MessageCell.
//It has a logic behind itself such as is the message from current user or not, background color, message is anchored to the left or right side etc.

struct MessageVM {
    
    private let message: Message
    
    var messageBackgroundColor: UIColor {
        return message.isFromCurrentUser ? #colorLiteral(red: 0.8942015613, green: 0.8942015613, blue: 0.8942015613, alpha: 1) : #colorLiteral(red: 0.8900103109, green: 0.2335001627, blue: 0.2835472581, alpha: 1)
    }
    
    var messageTextColor: UIColor {
        return message.isFromCurrentUser ? .black : .white
    }
    
    var rightAnchorActive: Bool {
        return message.isFromCurrentUser
    }
    
    var leftAnchorActive: Bool {
        return !message.isFromCurrentUser
    }
    
    var shouldHideProfileImage: Bool {
        return message.isFromCurrentUser
    }
    
    //Get a profileImageView url to show the profile imsage in chats vc.
    var profileImageURL: URL? {
        guard let user = message.user else { return nil }
        
        return URL(string: user.profileImageURL)
    }
    
    init(message: Message) {
        self.message = message
    }
    
}
