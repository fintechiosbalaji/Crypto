//
//  TabViewRouter.swift
//  CryptoApp
//
//  Created by Rockz on 16/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import SwiftUI

struct TabViewRouter: TabViewRouterProtocol {
    
    static func composeView() -> AnyView {
        let router = TabViewRouter()
        let interactor = TabViewInteractor()
        let presenter = TabViewPresenter(interactor: interactor, router: router)
        let view = TabViewView(presenter: presenter, selectedTab: 0)
        return AnyView(view)
    }
}
