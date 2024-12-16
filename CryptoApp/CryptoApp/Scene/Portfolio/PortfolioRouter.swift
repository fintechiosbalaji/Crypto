//
//  PortfolioRouter.swift
//  CryptoApp
//
//  Created by Rockz on 21/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import SwiftUI

struct PortfolioRouter: PortfolioRouterProtocol {
    
    static func composeView() -> AnyView {
        let router = PortfolioRouter()
        let network = NetworkManager()
        let interactor = PortfolioInteractor( service: network)
        let presenter = PortfolioPresenter( interactor: interactor, router: router)
        let view = PortfolioView(presenter: presenter, walletBalanceViewModel: WalletBalanceViewModel())
        return AnyView(view)
    }
    
    func navigateToCryptoList() -> AnyView {
        CryptoListRouter.composeView()
    }
}
