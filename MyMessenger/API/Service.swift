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
}
