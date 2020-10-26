//
//  AuthManager.swift
//  MyMessenger
//
//  Created by AZM on 2020/10/25.
//

import UIKit
import Firebase

struct RegistrationCredentials {
    let email: String
    let fullname: String
    let username: String
    let password: String
    let profileImage: UIImage
}

struct AuthManager {
    static let shared = AuthManager()
    
    func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    
    func createUser(credentials: RegistrationCredentials, completion: ((Error?) -> Void)? ) {
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.5) else {return}
        
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        
        ref.putData(imageData, metadata: nil) { (meta, error) in
            if let error = error {
                print("DEBUG: Failed to upload image with error \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL { (url, error) in
                //creating profile image URL
                guard let profileImageURL = url?.absoluteString else {return} // this is our profile image url
                Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (authResult, error) in
                    if let error = error {
                        print("DEBUG: Failed to create a new user with error \(error.localizedDescription)")
                        return
                    }
                    
                    guard let uID = authResult?.user.uid else {return}
                    
                    let data = ["email": credentials.email,
                                "fullname": credentials.fullname,
                                "profileImageURL": profileImageURL,
                                "username": credentials.username,
                                "password": credentials.password] as [String: Any]
                    
                    Firestore.firestore().collection("users").document(uID).setData(data, completion: completion)
                }
                
            }
        }
    }
}
