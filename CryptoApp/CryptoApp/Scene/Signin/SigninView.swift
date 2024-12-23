//
//  SigninView.swift
//  CryptoApp
//
//  Created by Rockz on 09/12/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import SwiftUI

struct SigninView: View, SigninViewProtocol {
    
    @ObservedObject
    private var presenter: SigninPresenter
    @EnvironmentObject var authService:AuthService
    @State private var isPasswordVisible: Bool = false
  
    init(presenter: SigninPresenter) {
        self.presenter = presenter
    }
    
    var body: some View {
        ZStack {
            Color("primaryColor")
                .edgesIgnoringSafeArea(.all)
            VStack {
                logincustomView
                if !presenter.loginStatus.desc.isEmpty {
                    Text(presenter.loginStatus.desc)
                        .foregroundColor(presenter.loginStatus == .success ? .green : .red)
                        .padding(.top, 10) .onAppear {
                            if presenter.loginStatus == .success {
                                presenter.navigateToDashboard = true
                            }
                        }
                }
            }
            NavigationLink(destination: presenter.router.navigateToDashboard(),
                           isActive: $presenter.navigateToDashboard) {
                EmptyView()
            }
        }
        .background(.red)
        .navigationBarBackButtonHidden()
    }
    
    private var logincustomView: some View {
        VStack {
            SignInTextField(contentText: $presenter.email,
                            isPasswordVisible: .constant(false),
                            isSecure: false,
                            textfieldImg: "envelope",
                            placeHolder: LocalizationKeys.Login.email.localizedKey,
                            errorMessage: presenter.emailError)
            .padding(.leading, 24)
            SignInTextField(contentText: $presenter.password,
                            isPasswordVisible: $isPasswordVisible,
                            isSecure: true,
                            textfieldImg: "lock",
                            placeHolder: LocalizationKeys.Login.password.localizedKey,
                            errorMessage: presenter.passwordError)
            .padding(.leading, 24)
            HStack {
                Spacer()
                Button(action: {  print("Forgot Password tapped") }) {
                    Text(LocalizationKeys.Login.forgot_password.localizedKey)
                        .foregroundColor(.gray)
                    .underline() }
                .padding(.trailing, 24) .padding(.top, 5) }
            loginButton
                .opacity(presenter.isValid ? 1 : 0.5)
                .disabled(!presenter.isValid)
                .padding(.top, 30)
        }
        .padding()
        .modifier(DarkModeViewModifier())
    }
    
    var loginButton: some View {
        Button(action: {
            presenter.signIn()
        }) {
            Text(LocalizationKeys.Login.submit.localizedKey)
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

struct SigninView_Previews: PreviewProvider {
    static var previews: some View {
        SigninRouter.composeView()
    }
}

struct SignInTextField: View {
    
    @Binding var contentText: String
    @Binding var isPasswordVisible: Bool
    var isSecure: Bool
    var textfieldImg: String
    var placeHolder: LocalizedStringKey
    var errorMessage: String?
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(placeHolder)
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .font(.headline)
                .opacity(0.5)
            HStack {
                Image(systemName: textfieldImg)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                if isSecure {
                    if isPasswordVisible {
                        TextField(placeHolder, text: $contentText)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .font(.headline)
                            .onChange(of: contentText) { _,newValue in
                                if contentText.count > 15 {
                                    contentText = String(contentText.prefix(15))
                                }
                            }
                            .frame(height: 20)
                    } else {
                        SecureField(placeHolder, text: $contentText)
                            .onChange(of: contentText) { _,newValue in
                                if contentText.count > 15 {
                                    contentText = String(contentText.prefix(15))
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
                    TextField(placeHolder, text: $contentText)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .font(.headline)
                        .frame(height: 20)
                }
            }
            .padding()
            .background(
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
