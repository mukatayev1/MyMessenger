//
//  ProfileViewModel.swift
//  MyMessenger
//
//  Created by AZM on 2020/11/03.
//

import Foundation

enum ProfileVM: Int, CaseIterable {
    case accountInfo
    case settings
    
    var description: String {
        switch self {
        case .accountInfo: return "Account Info"
        case .settings: return "Settings"
        }
    }
    
    var iconImageName: String {
        switch self {
        case .accountInfo: return "person.circle"
        case .settings: return "gear"
        }
    }
    
}
