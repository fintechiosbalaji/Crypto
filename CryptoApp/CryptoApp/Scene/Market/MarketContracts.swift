//
//  MarketContracts.swift
//  CryptoApp
//
//  Created by Rockz on 17/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import SwiftUI
import Combine

// MARK: - View Protocol

protocol MarketViewProtocol {
    
}

// MARK: - Presenter Protocol

protocol MarketPresenterProtocol {
    func fetchMarketData()
}

// MARK: - Interactor Protocol

protocol MarketInteractorProtocol {
    func fetchMarketData() -> AnyPublisher<Result<[TestCrypto], HttpNetworkError>, Never>
}

// MARK: - Router Protocol

protocol MarketRouterProtocol {
    static func composeView() -> AnyView
}
