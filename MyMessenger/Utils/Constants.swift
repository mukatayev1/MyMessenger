//
//  Constants.swift
//  MyMessenger
//
//  Created by AZM on 2020/10/23.
//

import UIKit
import Firebase

//Custom struct to store all constants used throughout the app. "K" name is just a random name created to make a typing of this struct very fast.
struct K {
    static let chatsReuseIdentifier = "chatsCell"
    
    static let iconImage = UIImage(systemName: "paperplane", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))
    
    static let lockImage = UIImage(systemName: "lock.circle", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))
    
    static let envelopeImage = UIImage(systemName: "envelope.circle", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))
    
    static let plusCircleImage = UIImage(systemName: "plus.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 200, weight: .thin))
    
    static let userImage = UIImage(systemName: "person.circle", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))
    
    static let disabledButtonColor = #colorLiteral(red: 1, green: 0.4024070791, blue: 0.4221591086, alpha: 1)
    
    static let plusImage = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))
    
    static let profileImage = UIImage(systemName: "person.crop.circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
    
    static let circleArrowUpImage = UIImage(systemName: "arrow.up.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .regular))
    
    static let userReuseIdentifier = "UserCell"
    
    static let messageReuseIdentifier = "MessageCell"
    
    static let COLLECTION_MESSAGES = Firestore.firestore().collection("messages")
    static let COLLECTION_USERS = Firestore.firestore().collection("users")
}
