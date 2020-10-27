//
//  LoginVM.swift
//  MyMessenger
//
//  Created by AZM on 2020/10/24.
//

import UIKit

//Protocol is created in order to make button tapple only when the textfields have at least one value. So each ViewModel that want will correspond to this protocol, will have to create its own validation function
protocol AuthenticationProtocol {
    //Func in order to validate that the textfields have at least one value inside
    var formIsValid: Bool { get }
}

//This ViewModel works for login page. Role: helps in making Login button tappable or not.
struct LoginVM: AuthenticationProtocol {
    
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false
            && password?.isEmpty == false
    }
}


