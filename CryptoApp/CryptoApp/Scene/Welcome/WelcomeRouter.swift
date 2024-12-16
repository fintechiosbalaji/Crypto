//
//  WelcomeRouter.swift
//  CryptoApp
//
//  Created by Rockz on 14/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import SwiftUI

struct WelcomeRouter: WelcomeRouterProtocol {
    
    static func composeView() -> AnyView {
        let router = WelcomeRouter()
        let interactor = WelcomeInteractor()
        let presenter = WelcomePresenter(interactor: interactor, router: router)
        let view = WelcomeView(presenter: presenter)
        return AnyView(view)
    }
    
    func navigateToLoginIn() -> AnyView {
        SigninRouter.composeView()
    }
}
