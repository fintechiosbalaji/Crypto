//
//  LoginInteractor.swift
//  CryptoApp
//
//  Created by Rockz on 14/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import Combine
import Foundation

final class LoginInteractor: LoginInteractorProtocol {
    
    func validateCredentials(email: String, password: String) -> Bool {
        return email == "balaji@gmail.com" && password == "tester14"
    }
}

