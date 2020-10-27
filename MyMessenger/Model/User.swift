//
//  User.swift
//  MyMessenger
//
//  Created by AZM on 2020/10/27.
//

import Foundation
//A model for our user profile. It's the easiest way to attach necessary info about each user: create struct User that will have all info about registered user.
struct User {
    let uID: String
    let profileImage: String
    let email: String
    let fullname: String
    let username: String
    
    //To get the data from database we create an initializer that will take a dictionary parameter and do the functionality. It's similar how Decodable protocol works. But for this project its' much simpler to use such dictionary
    
    init(dictionary: [String: Any]) {
        //it's saying:
        //assign to self.uID -> go look for the uID key in the dictionary that I will pass in and assign its value to the self.uID in a String type
        self.uID = dictionary["uID"] as? String ?? ""
        self.profileImage = dictionary["profileImage"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
    }
}
