//
//  LoginContracts.swift
//  CryptoApp
//
//  Created by Rockz on 14/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import SwiftUI
import Combine

// MARK: - View Protocol

protocol LoginViewProtocol {
    
}

// MARK: - Presenter Protocol

protocol LoginPresenterProtocol {
    func submit()
}

// MARK: - Interactor Protocol

protocol LoginInteractorProtocol {
    func validateCredentials(email: String, password: String) -> Bool 
}

// MARK: - Router Protocol

protocol LoginRouterProtocol {
    static func composeView() -> AnyView
}
