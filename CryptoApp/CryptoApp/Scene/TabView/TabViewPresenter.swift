//
//  TabViewPresenter.swift
//  CryptoApp
//
//  Created by Rockz on 16/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import Combine

final class TabViewPresenter: TabViewPresenterProtocol, ObservableObject {
   
    private let interactor: TabViewInteractorProtocol
    private let router: TabViewRouterProtocol
    
    init(
        interactor: TabViewInteractorProtocol,
        router: TabViewRouterProtocol
    ) {
        self.interactor = interactor
        self.router = router
    }
}
