//
//  CryptoListPresenter.swift
//  CryptoApp
//
//  Created by Rockz on 25/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import Combine
import SwiftUI

class CryptoListSingleton : ObservableObject {
    static let shared = CryptoListSingleton()
    @Published var cryptoList: [TestCrypto] = []
    private init() { }
}

final class CryptoListPresenter: CryptoListPresenterProtocol, ObservableObject {
    
    @Published var cryptoList: [TestCrypto] = []
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String = ""
    private var dependencies: CryptoListPresenterDependenciesProtocol
    private let interactor: CryptoListInteractorProtocol
    private let router: CryptoListRouterProtocol
    @ObservedObject var cryptoSharedList = CryptoListSingleton.shared
    
    init(
        dependencies: CryptoListPresenterDependenciesProtocol,
        interactor: CryptoListInteractorProtocol,
        router: CryptoListRouterProtocol
    ) {
        self.dependencies = dependencies
        self.interactor = interactor
        self.router = router
    }
    
    func loadCryptoList() {
        // cryptoList = interactor.getCryptoList()
        //        interactor.fetchData()
        //            .receive(on: DispatchQueue.main)
        //            .sink { [weak self] completion in
        //                switch completion {
        //                case .failure(let error):
        //                    print("Error fetching data: \(error.localizedDescription)")
        //                    self?.errorMessage = "Unable to load portfolio data. Please try again later."
        //                case .finished:
        //                    break
        //                }
        //            } receiveValue: { [weak self] cryptoListData in
        //                guard let self = self else { return }
        //
        //                let actualCryptoList = cryptoListData.map { crypto in
        //                    let trendsWithDates = generateLast7DaysValues(values: crypto.priceTrends.map { $0.value })
        //                    var updatedCrypto = crypto
        //                    updatedCrypto.priceTrends = trendsWithDates
        //                    return updatedCrypto
        //                }
        //                self.cryptoList = actualCryptoList
        //                self.cryptoSharedList.cryptoList = actualCryptoList
        //
        //            }
        //            .store(in: &cancellables)
        //    }
        
        interactor.fetchData()
            .sink { result in
                switch result {
                case .success(let cryptoListData):
                    // Handle success, update the view
                    let actualCryptoList = cryptoListData.map { crypto in
                        let trendsWithDates = generateLast7DaysValues(values: crypto.priceTrends.map { $0.value })
                        var updatedCrypto = crypto
                        updatedCrypto.priceTrends = trendsWithDates
                        return updatedCrypto
                    }
                    self.cryptoList = actualCryptoList
                    self.cryptoSharedList.cryptoList = actualCryptoList
                case .failure(let error):
                    // Handle failure, show error
                    self.errorMessage = "Unable to load portfolio data. Please try again later."
                }
            }
            .store(in: &cancellables)
    }
}
