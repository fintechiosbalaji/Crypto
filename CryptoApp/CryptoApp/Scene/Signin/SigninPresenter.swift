//
//  SigninPresenter.swift
//  CryptoApp
//
//  Created by Rockz on 09/12/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

final class SigninPresenter: SigninPresenterProtocol, ObservableObject {
    
     @Published var email: String = "balaji@gmail.com"
     @Published var password: String = "Tester@1"
     @Published var isSubmitFlag: Bool = false
     @Published var loginStatus: LoginStatus = .none
     @Published var errorMessage: String?
     @Published var emailTouched: Bool = false
     @Published var passwordTouched: Bool = false
     @Published var emailError: String?
     @Published var passwordError: String?
     @Published var isValid: Bool = false
     @Published var navigateToDashboard: Bool = false
 
    private let interactor: SigninInteractorProtocol
    let router: SigninRouterProtocol
    private var cancellables: Set<AnyCancellable> = []

    init(
        interactor: SigninInteractorProtocol,
        router: SigninRouterProtocol
    ) {
        self.interactor = interactor
        self.router = router
        self.setupValidation()
    }
    
    internal func setupValidation() {
        Publishers.CombineLatest($email, $password)
            .sink { [weak self] email, password in
                guard let self = self else { return }
                self.loginStatus = .none
                self.interactor.validateCredentials(email: email, password: password) { emailErr, pwErr in
                    self.emailError = emailErr
                    self.passwordError = pwErr
                    self.isValid = self.emailError == nil && self.passwordError == nil
                }
            }
            .store(in: &cancellables)
    }

    func signIn() {
        guard isValid else { return }
        interactor.signIn(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.loginStatus = .success
                self?.navigateToDashboard = true
            case .failure(let error):
                self?.loginStatus = .failure
                self?.errorMessage = error.localizedDescription
            }
        }
    }
}
