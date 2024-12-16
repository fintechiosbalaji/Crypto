//
//  WelcomeContracts.swift
//  CryptoApp
//
//  Created by Rockz on 14/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import SwiftUI

// MARK: - View Protocol

protocol WelcomeViewProtocol {
    
}

// MARK: - Presenter Protocol
protocol WelcomePresenterProtocol {
    var WelcomeEntityName: String { get set }
    func getWelcomeData() -> WelcomeEntity
}

// MARK: - Interactor Protocol
protocol WelcomeInteractorProtocol {
    func fetchWelcomeData() -> WelcomeEntity
}

// MARK: - Router Protocol
protocol WelcomeRouterProtocol {
    static func composeView() -> AnyView
    func navigateToLoginIn() -> AnyView
}
