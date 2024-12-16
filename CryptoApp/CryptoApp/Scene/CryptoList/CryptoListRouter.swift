//
//  CryptoListRouter.swift
//  CryptoApp
//
//  Created by Rockz on 25/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import SwiftUI

struct CryptoListRouter: CryptoListRouterProtocol {
    
    static func composeView() -> AnyView {
        
        let router = CryptoListRouter()
        let network = NetworkManager()
        let interactorDependencies = CryptoListInteractorDependencies()
        let presenterDependencies = CryptoListPresenterDepenencies()
        let viewDependencies = CryptoListViewDependencies()
        
        let interactor = CryptoListInteractor(dependencies: interactorDependencies, service: network)
        let presenter = CryptoListPresenter(dependencies: presenterDependencies, interactor: interactor, router: router)
        let view = CryptoListView(dependencies: viewDependencies, presenter: presenter)
        
        return AnyView(view)
    }
    
   
}
