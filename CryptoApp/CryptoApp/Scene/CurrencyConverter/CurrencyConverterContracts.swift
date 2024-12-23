//
//  CurrencyConverterContracts.swift
//  CryptoApp
//
//  Created by Rockz on 29/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import SwiftUI
import Combine

// MARK: - View Protocol

protocol CurrencyConverterViewProtocol {
    
}

// MARK: - Presenter Protocol

protocol CurrencyConverterPresenterProtocol {
    func fetchCurrency()
}

// MARK: - Interactor Protocol

protocol CurrencyConverterInteractorProtocol {
    func fetchConversionRate(from: String, to: String) -> AnyPublisher<Result<CurrencyData, HttpNetworkError>, Never>
    func fetchCurrencyList() -> AnyPublisher<Result<CurrencyList, HttpNetworkError>, Never>
}

// MARK: - Router Protocol

protocol CurrencyConverterRouterProtocol {
    static func composeView() -> AnyView
}
