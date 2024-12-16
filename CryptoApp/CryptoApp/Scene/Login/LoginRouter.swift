//
//  LoginRouter.swift
//  CryptoApp
//
//  Created by Rockz on 14/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import SwiftUI

struct LoginRouter: LoginRouterProtocol {
    
    static func composeView() -> AnyView {
        let router = LoginRouter()
        let interactor = LoginInteractor()
        let presenter = LoginPresenter(interactor: interactor, router: router)
        let view = LoginView(presenter: presenter)
        return AnyView(view)
    }
    
    func navigateToDashboard() -> AnyView {
        return TabViewRouter.composeView()
    }
}
