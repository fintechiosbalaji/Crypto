//
//  WelcomePresenter.swift
//  CryptoApp
//
//  Created by Rockz on 14/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import Combine

final class WelcomePresenter: WelcomePresenterProtocol, ObservableObject {
    
    @Published var WelcomeEntityName: String = ""
    private let interactor: WelcomeInteractorProtocol
    let router: WelcomeRouterProtocol
    
    init(
        interactor: WelcomeInteractorProtocol,
        router: WelcomeRouterProtocol
    ) {
        self.interactor = interactor
        self.router = router
    }
    
    func getWelcomeData() -> WelcomeEntity {
        return interactor.fetchWelcomeData()
    }
}
