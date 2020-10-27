//
//  RegistrationVM.swift
//  MyMessenger
//
//  Created by AZM on 2020/10/24.
//

import Foundation


//This ViewModel works for SignUp page. Role: helps in making Sign Up button tappable or not.
struct RegistrationVM: AuthenticationProtocol {
    
    var email: String?
    var fullname: String?
    var username: String?
    var password: String?
    
    
    var formIsValid: Bool {
        return email?.isEmpty == false
            && fullname?.isEmpty == false
            && username?.isEmpty == false
            && password?.isEmpty == false
    }
}
