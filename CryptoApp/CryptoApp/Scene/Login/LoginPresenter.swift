//
//  LoginPresenter.swift
//  CryptoApp
//
//  Created by Rockz on 14/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import Combine
import Foundation
import SwiftUI


struct LoginState {
    var email: String = "balaji@gmail.com"
    var password: String = "tester14"
    var isSubmitFlag: Bool = false
    var loginStatus: LoginStatus = .none
    var errorMessage: String?
    var emailTouched: Bool = false
    var passwordTouched: Bool = false
    var emailError: String?
    var passwordError: String?
    var isValid: Bool = false
}

class LoginPresenter: LoginPresenterProtocol, ObservableObject {
    
    @Published var state = LoginState()
    
    private let interactor: LoginInteractorProtocol
     let router: LoginRouterProtocol
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(
        interactor: LoginInteractorProtocol,
        router: LoginRouterProtocol
    ) {
        self.interactor = interactor
        self.router = router
        self.setupValidation()
    }
    
    private func setupValidation() {
        Publishers.CombineLatest(validUserNamePublisher, passwordValidatorPublisher)
            .map { emailError, passwordError in
                return emailError == "" && passwordError == "" }
            .assign(to: \.state.isValid, on: self)
            .store(in: &cancellableSet)
        
        validUserNamePublisher
            .sink { [weak self] emailError in
                self?.state.emailError = self?.state.emailTouched == true ? emailError : nil
                self?.validateInputs() }
            .store(in: &cancellableSet)
        
        passwordValidatorPublisher
            .sink { [weak self] passwordError in
                self?.state.passwordError = self?.state.passwordTouched == true ? passwordError : nil
                self?.validateInputs() }
            .store(in: &cancellableSet)
        
        isValidPublisher
            .assign(to: \.state.isSubmitFlag, on: self)
            .store(in: &cancellableSet)
    }
    
    private func validateInputs() {
        let isEmailValid = state.email.isValidEmail
        let isPasswordValid = state.password.count >= 8
        
        state.isSubmitFlag = state.isValid && isEmailValid && isPasswordValid
    }
    
    func submit() {
        if interactor.validateCredentials(email: state.email, password: state.password) {
            state.loginStatus = .success
        } else {
            state.loginStatus = .failure
        }
    }
    
    func handleInputChange() {
        state.loginStatus = .none
        validateInputs()
    }

}

extension LoginPresenter {
    
//    $useremail
//        .sink{
//            validationlayer.validemail
//        }
//    $error
//        .sink {
//            
//        }

    private var isValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($state.map(\.emailError), $state.map(\.passwordError))
            .map { emailError, passwordError in
                return emailError == "" && passwordError == "" }
            .eraseToAnyPublisher()
    }
    
    private var validUserNamePublisher: AnyPublisher<String?, Never> {
        $state.map(\.email)
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { email in
                if email.isEmpty {
                    return LocalizationKeys.Login.enterEmail
                } else if !email.isValidEmail {
                    return LocalizationKeys.Login.enterValidEmail
                } else {
                    return ""
                }
            }
            .eraseToAnyPublisher()
    }
    
    private var passwordValidatorPublisher: AnyPublisher<String, Never> {
        $state.map(\.password)
            .removeDuplicates()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map { password in
                if password.isEmpty {
                    return LocalizationKeys.Login.passwordEmpty
                } else if password.count < 8 {
                    return LocalizationKeys.Login.passwordTooShort
                } else {
                    return ""
                }
            }
            .eraseToAnyPublisher()
    }
}
