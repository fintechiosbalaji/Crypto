//
//  CurrencyConverterInteractor.swift
//  CryptoApp
//
//  Created by Rockz on 29/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import Combine

final class CurrencyConverterInteractor: CurrencyConverterInteractorProtocol {
   
    let service: NetworkManagerProtocol
    
    init(service: NetworkManagerProtocol) {
        self.service = service
    }
    
    func fetchCurrencyList() -> AnyPublisher<Result<CurrencyList, HttpNetworkError>, Never> {
        self.service.get(type: CurrencyList.self,
                         router: .fetchCurrency,
                         parameters: nil,
                         headers: nil,
                         count: 1,
                         method: .get)
    }
    
    func fetchConversionRate(from: String, to: String)
               -> AnyPublisher<Result<CurrencyData, HttpNetworkError>, Never> {
        self.service.get(type: CurrencyData.self,
                         router: .currency(input: from, output: to),
                         parameters: nil,
                         headers: nil,
                         count: 1,
                         method: .get)
    }
}
