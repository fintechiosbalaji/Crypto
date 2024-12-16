//
//  MarketRouter.swift
//  CryptoApp
//
//  Created by Rockz on 17/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import SwiftUI

struct MarketRouter: MarketRouterProtocol {
    
    static func composeView() -> AnyView {
        let router = MarketRouter()
        let network = NetworkManager()
        let interactor = MarketInteractor(service: network)
        let presenter = MarketPresenter(interactor: interactor, router: router)
        let view = MarketView(presenter: presenter)
        return AnyView(view)
    }
}
