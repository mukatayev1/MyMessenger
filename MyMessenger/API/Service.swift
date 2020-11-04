//
//  Service.swift
//  MyMessenger
//
//  Created by AZM on 2020/10/27.
//

import Firebase

//Fetching users service. Service to get all needed information about users to the device.

struct Service {
    
    static func fetchUsers(completion: @escaping([User]) -> Void) {
        K.COLLECTION_USERS.getDocuments { snapshot, error in
            guard var users = snapshot?.documents.map({ User(dictionary: $0.data()) }) else { return }
            
            if let i = users.firstIndex(where: { $0.uID == Auth.auth().currentUser?.uid }) {
                users.remove(at: i)
            }
            completion(users)
        }
    }
    
    
    //fetching all the messages into a ChatsCVC. Ordered by timestamp
    //If a have a chat with Pavel Durove, then (forUser: Pavel Durov). Later we will fetch all the messages with Pavel Durov through the use of completion.
    static func fetchMessages(forUser user: User, completion: @escaping([Message]) -> Void) {
        var messages = [Message]()
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        //create a query that will access the messages collection. Going into the current user id, accessing the list of messaeges with a particular user.uID and order it by time.
        let query = K.COLLECTION_MESSAGES.document(currentUid).collection(user.uID).order(by: "timestamp")
        //add a snapshot listener: in order to know each time messages is added into the database. It says: "something has been added to the database. Refresh the view"
        query.addSnapshotListener { (snapshot, error) in
            //go through all changes that appeared in a snapshot
            snapshot?.documentChanges.forEach({ (change) in
                //and if the change that occured is of type .added, then we need to capture it.
                if change.type == .added {
                    //we save the .added type changes into our dictionary
                    let dictionary = change.document.data()
                    //and we append the messages with the new data of type dictionary. P.S. the dictionary is the custom initializer of Messase(model).
                    messages.append(Message(dictionary: dictionary))
                    completion(messages)
                }
            })
        }
    }
    
    static func uploadMessage(_ message: String, to user: User, completion: ((Error?) -> Void)?) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        //data dictionary for a Message Model. That has all necessary data about any message.
        let data = ["text": message,
                    "fromID": currentUid,
                    "toID": user.uID,
                    "timestamp": Timestamp(date: Date())] as [String: Any]
        //accessing our firestore "messages" collection & adding a new document/message "data" to our logged in/current user.
        K.COLLECTION_MESSAGES.document(currentUid).collection(user.uID).addDocument(data: data) { (_) in
            //Accessing the firestore "messages" collection and adding the same message data to the user that receives that message.
            K.COLLECTION_MESSAGES.document(user.uID).collection(currentUid).addDocument(data: data, completion: completion)
            //Creating a recent messages collection. Purpose: Store recent message of each user in order to display it in the ConversationsVC.
            //Store recent messages of those, who send the message to current user
            K.COLLECTION_MESSAGES.document(currentUid).collection("recent-messages").document(user.uID).setData(data)
            //Store recent messages of current user to display it in other users' devices. func .setData() overrides existing data i.e. it deletes existing data and creates a new data.
            K.COLLECTION_MESSAGES.document(user.uID).collection("recent-messages").document(currentUid).setData(data)
        }
    }
    
    //fetch user for Conversations
    static func fetchUser(withUid uid: String, completion: @escaping (User) -> Void) {
        K.COLLECTION_USERS.document(uid).getDocument { (snapshot, error) in
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    
    static func fetchConversations(completion: @escaping([Conversation]) -> Void) {
        var conversations = [Conversation]()
        guard let uID = Auth.auth().currentUser?.uid else { return }
        
        let query = K.COLLECTION_MESSAGES.document(uID).collection("recent-messages").order(by: "timestamp")
        
        query.addSnapshotListener { (snapshot, error) in
            
            snapshot?.documentChanges.forEach({ change in
                let dictionary = change.document.data()
                let message = Message(dictionary: dictionary)
                
                self.fetchUser(withUid: message.toID) { user in
                    let conversation = Conversation(user: user, message: message)
                    conversations.append(conversation)
                    completion(conversations)
                }
            })
        }
    }
    
}

