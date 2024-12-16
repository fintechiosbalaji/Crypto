//
//  SigninEntity.swift
//  CryptoApp
//
//  Created by Rockz on 09/12/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import Foundation

struct User: Codable {
    let email: String
    let password: String
}

enum LoginStatus {
    case success
    case failure
    case none
    
    var desc: String {
        switch self {
        case .success:
            return LocalizationKeys.Login.loginSuccess
        case .failure:
            return "Invalid credentials."
        case .none:
            return ""
        }
    }
}
