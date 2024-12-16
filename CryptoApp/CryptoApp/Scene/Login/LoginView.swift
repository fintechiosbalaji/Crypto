//
//  LoginView.swift
//  CryptoApp
//
//  Created by Rockz on 14/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import SwiftUI

struct LoginView: View, LoginViewProtocol {
    
    @ObservedObject
    private var presenter: LoginPresenter
    @State private var isPasswordVisible = false
    @State private var navigateToDashboard = false
    @State private var path = NavigationPath()
    @EnvironmentObject var authService:AuthService
    
    init(presenter: LoginPresenter) {
        self.presenter = presenter
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("primaryColor")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    logincustomView
                    if !presenter.state.loginStatus.desc.isEmpty {
                        Text(presenter.state.loginStatus.desc)
                            .foregroundColor(presenter.state.loginStatus == .success ? .green : .red)
                            .padding(.top, 10) .onAppear {
                                if presenter.state.loginStatus == .success {
                                    navigateToDashboard = true
                                }
                            }
                    }
                }
                .navigationDestination(isPresented: $navigateToDashboard) {
                    LoginRouter().navigateToDashboard()
                }
            }
        }
        .background(.red)
        .navigationBarBackButtonHidden()
    }
}

extension LoginView {
    var logincustomView: some View {
        VStack {
            AppTextField(contentText: $presenter.state.email,
                         touched: $presenter.state.emailTouched,
                         isPasswordVisible: .constant(false),
                         
                         isSubmitEnabled: $presenter.state.isSubmitFlag,
                         placeHolder: LocalizationKeys.Login.email.localizedKey,
                         isPasswordField: false,
                         errorMessage: presenter.state.emailError)
            .padding(.leading, 24)
            .onChange(of: presenter.state.email) { _ , _ in
                presenter.handleInputChange()
            }
            AppTextField(contentText: $presenter.state.password,
                         touched: $presenter.state.passwordTouched,
                         isPasswordVisible: $isPasswordVisible,
                         isSubmitEnabled: $presenter.state.isSubmitFlag,
                         placeHolder: LocalizationKeys.Login.password.localizedKey,
                         isPasswordField: true,
                         errorMessage: presenter.state.passwordError)
            .padding(.leading, 24)
            .onChange(of: presenter.state.password) { _,_ in
                presenter.handleInputChange()
            }
            HStack {
                Spacer()
                Button(action: {  print("Forgot Password tapped") }) {
                    Text(LocalizationKeys.Login.forgot_password.localizedKey)
                        .foregroundColor(.gray)
                    .underline() }
                .padding(.trailing, 24) .padding(.top, 5) }
            
            loginButton
                .opacity(presenter.state.isSubmitFlag ? 1 : 0.5)
                .disabled(!presenter.state.isSubmitFlag)
                .padding(.top, 30)
            
        }
        .padding()
        .modifier(DarkModeViewModifier())
    }
    
    var loginButton: some View {
        Button(action: {
            presenter.submit()
        }) {
            Text(LocalizationKeys.Login.submit)
                .font(.headline)
        }
        .frame(minWidth: 200, maxWidth: .infinity)
        .frame(height: 44)
        .foregroundColor(.white)
        .background(.orange)
        .cornerRadius(22)
        .padding(.leading, 24)
    }
}

struct AppTextField: View {
    
    @Binding var contentText: String
    @Binding var touched: Bool
    @Binding var isPasswordVisible: Bool
    @Binding var isSubmitEnabled: Bool
    var placeHolder: LocalizedStringKey
    var isPasswordField: Bool
    var errorMessage: String?
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(placeHolder)
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .font(.headline)
                .opacity(0.5)
            HStack {
                Image(systemName: isPasswordField ? "lock" : "envelope")
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                if isPasswordField {
                    if isPasswordVisible {
                        TextField(placeHolder, text: $contentText)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .font(.headline)
                            .onChange(of: contentText) { _,newValue in
                                touched = true
                                if contentText.count > 8 {
                                    contentText = String(contentText.prefix(8))
                                }
                            }
                            .frame(height: 20)
                    } else {
                        SecureField(placeHolder, text: $contentText, onCommit: {
                            touched = true
                        })
                        .onChange(of: contentText) { _,newValue in
                            touched = true
                            if contentText.count > 8 {
                                contentText = String(contentText.prefix(8))
                            }
                        }
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .font(.headline)
                        .frame(height: 20)
                    }
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: !isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                } else {
                    TextField(placeHolder, text: $contentText, onEditingChanged: { isEditing in
                        if isEditing {
                            touched = true
                        }
                    })
                    .onReceive(contentText.publisher.collect()) {
                        self.contentText = String($0.prefix(20))
                    }
                    .onChange(of: contentText) { _,newValue in
                        touched = true
                    }
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .font(.headline)
                    .frame(height: 20)
                    .autocapitalization(.none)
                }
                Spacer()
            }
            .padding() .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        Color.gray, lineWidth: 2)
                
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.1)))
            )
            Text(errorMessage ?? "")
                .foregroundColor(.red)
                .font(.caption)
        }
    }
}

