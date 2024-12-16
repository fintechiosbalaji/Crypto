//
//  CurrencyConverterRouter.swift
//  CryptoApp
//
//  Created by Rockz on 29/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import SwiftUI

struct CurrencyConverterRouter: CurrencyConverterRouterProtocol {
    
    static func composeView() -> AnyView {
        let router = CurrencyConverterRouter()
        let interactor = CurrencyConverterInteractor(service: NetworkManager())
        let presenter = CurrencyConverterPresenter(interactor: interactor, router: router)
        let view = CurrencyConverterView(presenter: presenter)
        return AnyView(view)
    }
}
