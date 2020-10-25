//
//  LoginVM.swift
//  MyMessenger
//
//  Created by AZM on 2020/10/24.
//

import UIKit

protocol AuthenticationProtocol {
    var formIsValid: Bool { get }
}

struct LoginVM: AuthenticationProtocol {
    
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false
            && password?.isEmpty == false
    }
}


