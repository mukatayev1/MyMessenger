//
//  ConversationVM.swift
//  MyMessenger
//
//  Created by AZM on 2020/11/03.
//

import Foundation

struct ConversationVM {
    
    private let conversation: Conversation
    
    var profileImageURL: URL? {
        return URL(string: conversation.user.profileImageURL)
    }
    
    var timestamp: String {
        let date = conversation.message.timestamp.dateValue()
        //date formatter ot format the timestamp
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    init(conversation: Conversation) {
        self.conversation = conversation
    }
    
}
