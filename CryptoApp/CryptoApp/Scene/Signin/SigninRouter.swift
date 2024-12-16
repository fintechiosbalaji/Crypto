//
//  SigninRouter.swift
//  CryptoApp
//
//  Created by Rockz on 09/12/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import SwiftUI

struct SigninRouter: SigninRouterProtocol {
    
    static func composeView() -> AnyView {
        let router = SigninRouter()
        let interactor = SigninInteractor(loginValidation: LoginValidation())
        let presenter = SigninPresenter(interactor: interactor, router: router)
        let view = SigninView(presenter: presenter)
        return AnyView(view)
    }
    
    func navigateToDashboard() -> AnyView {
        TabViewRouter.composeView()
    }
}
