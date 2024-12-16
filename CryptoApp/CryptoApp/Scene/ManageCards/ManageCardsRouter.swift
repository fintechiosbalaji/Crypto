//
//  ManageCardsRouter.swift
//  CryptoApp
//
//  Created by Rockz on 16/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import SwiftUI
import CoreData

struct ManageCardsRouter: ManageCardsRouterProtocol {
    
    static func composeView(context: NSManagedObjectContext) -> AnyView {
        let router = ManageCardsRouter()
        let interactorDependencies = ManageCardsInteractorDependencies(context: context)
        let interactor = ManageCardsInteractor(dependencies: interactorDependencies)
        let presenter = ManageCardsPresenter(interactor: interactor, router: router)
        let view = ManageCardsView(presenter: presenter, walletBalanceViewModel: WalletBalanceViewModel())
        return AnyView(view)
    }
}
