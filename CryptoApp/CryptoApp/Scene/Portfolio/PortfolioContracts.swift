//
//  PortfolioContracts.swift
//  CryptoApp
//
//  Created by Rockz on 21/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import SwiftUI
import Combine

// MARK: - View Protocol

protocol PortfolioViewProtocol {
    
}

// MARK: - Presenter Protocol

protocol PortfolioPresenterProtocol {
    func loadData()
}

// MARK: - Interactor Protocol

protocol PortfolioInteractorProtocol {
    func fetchData() -> AnyPublisher<Result<[CryptoValueModel], NetworkError>, Never>
}

// MARK: - Router Protocol

protocol PortfolioRouterProtocol {
    static func composeView() -> AnyView
    func navigateToCryptoList() -> AnyView
    
}
