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

struct AuthService {
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    
    func createUser(credentials: RegistrationCredentials, completion: ((Error?) -> Void)? ) {
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.5) else {return}
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        
        ref.putData(imageData, metadata: nil) { (meta, error) in
            if let error = error {
                completion!(error)
                return
            }
            
            ref.downloadURL { (url, error) in
                //creating profile image URL
                guard let profileImageURL = url?.absoluteString else {return} // this is our profile image url
                Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                    if let error = error {
                        completion!(error)
                        return
                    }
                    
                    guard let uID = result?.user.uid else {return}
                    
                    let data = ["email": credentials.email,
                                "fullname": credentials.fullname,
                                "profileImageURL": profileImageURL,
                                "uID": uID,
                                "password": credentials.password] as [String: Any]
                    
                    Firestore.firestore().collection("users").document(uID).setData(data, completion: completion)
                }
                
            }
        }
        
    }
}
