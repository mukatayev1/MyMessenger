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
        var users = [User]()
        Firestore.firestore().collection("users").getDocuments { snapshot, error in
            snapshot?.documents.forEach({ document in 
                
                //information is stored as dictionaary in firestore.
                let dictionary = document.data()
                //retrieving username info from documents data that has the key "username"
                let user = User(dictionary: dictionary)
                users.append(user)
                completion(users)
                
            })
            
            
        }
    }
    
    
    //fetching all the messages into a ChatsCVC. Ordered by timestamp
    static func fetchMessages(forUser user: User, completion: @escaping([Message]) -> Void?) {
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
        }
    }
    
}
