//
//  SettingsRouter.swift
//  CryptoApp
//
//  Created by Rockz on 16/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import SwiftUI

struct SettingsRouter: SettingsRouterProtocol {
    
    static func composeView() -> AnyView {
        let router = SettingsRouter()
        let viewDependencies = SettingsViewDependencies()
        let interactor = SettingsInteractor()
        let presenter = SettingsPresenter(interactor: interactor, router: router)
        let view = SettingsView(presenter: presenter)
        return AnyView(view)
    }

}
