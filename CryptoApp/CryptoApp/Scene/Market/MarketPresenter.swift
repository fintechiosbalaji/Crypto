//
//  MarketPresenter.swift
//  CryptoApp
//
//  Created by Rockz on 17/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import Combine
import SwiftUI

final class MarketPresenter: MarketPresenterProtocol, ObservableObject {
    
    private let interactor: MarketInteractorProtocol
    private let router: MarketRouterProtocol
    
    @Published var cryptoDataSeries: [TestCrypto] = []
    @Published var errorMessage: String? = nil
    @Published var showError: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    init(
        interactor: MarketInteractorProtocol,
        router: MarketRouterProtocol
    ) {
        self.interactor = interactor
        self.router = router
    }
    
    func fetchMarketData() {
        interactor.fetchMarketData()
        //            .sink(receiveCompletion: { completion in
        //                if case let .failure(error) = completion {
        //                    print("Decoding error: \(error)")
        //                    self.errorMessage = error.localizedDescription
        //                    self.showError = true
        //                }
        //            }, receiveValue: { marketData in
        //                // Transform nested structure to a flat array
        //                self.cryptoDataSeries = marketData.cryptoData
        //            })
        //            .store(in: &cancellables)
        
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let cryptoListData):
                    let actualCryptoList = cryptoListData.map { crypto in
                        let trendsWithDates = generateLast7DaysValues(values: crypto.priceTrends.map { $0.value })
                        var updatedCrypto = crypto
                        updatedCrypto.priceTrends = trendsWithDates
                        return updatedCrypto
                    }
                    self.cryptoDataSeries = actualCryptoList
                case .failure(let error):
                    // Handle failure, show error
                    self.errorMessage = "Unable to load portfolio data. Please try again later."
                    self.showError = true
                }
            }
            .store(in: &cancellables)
    }
}
