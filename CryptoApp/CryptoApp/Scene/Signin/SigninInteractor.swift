//
//  SigninInteractor.swift
//  CryptoApp
//
//  Created by Rockz on 09/12/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import Foundation
import Combine

final class SigninInteractor: SigninInteractorProtocol {
    
    private let loginValidation: LoginValidation
  
    init(loginValidation: LoginValidation) {
        self.loginValidation = loginValidation
    }
    
    func validateCredentials(email: String, password: String, completion: (String?, String?) -> Void) {
        let emailError = loginValidation.validateEmail(with: email) ? nil : "Invalid email address"
        let passwordError = loginValidation.isPasswordValid(password) ? nil : "Password must be at least 8 characters"
        completion(emailError, passwordError)
    }
    
    func signIn(email: String,
                password: String,
                completion: @escaping (Result<Void, Error>) -> Void) {
        if email == "balaji@gmail.com" && password == "Tester@1" {
              completion(.success(()))
        } else {
            let error = NSError(domain: "SigninError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid email or password"])
            completion(.failure((error)))
        }
    }
}

struct LoginValidation {
    
    func validateEmail(with email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func isPasswordValid(_ password: String) -> Bool {
        // Single regex pattern: at least one uppercase, one lowercase, one digit, one special character, and minimum 8 characters
        let pattern = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[!@#$%^&*()_+=-]).{8,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: password)
    }
}
