//
//  SigninContracts.swift
//  CryptoApp
//
//  Created by Rockz on 09/12/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import SwiftUI

// MARK: - View Protocol

protocol SigninViewProtocol {
    
}

// MARK: - Presenter Protocol

protocol SigninPresenterProtocol {
    func setupValidation()
    func signIn()
}

// MARK: - Interactor Protocol

protocol SigninInteractorProtocol {
    func validateCredentials(email: String, password: String, completion: (String?, String?) -> Void)
    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
}

// MARK: - Router Protocol

protocol SigninRouterProtocol {
    static func composeView() -> AnyView
    func navigateToDashboard() -> AnyView
}
