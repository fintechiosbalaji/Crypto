//
//  CryptoListContracts.swift
//  CryptoApp
//
//  Created by Rockz on 25/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import SwiftUI
import Combine


// MARK: - View Protocol

protocol CryptoListViewProtocol {
    
}

// MARK: - Presenter Protocol

protocol CryptoListPresenterProtocol {
    func loadCryptoList()
}

// MARK: - Interactor Protocol

protocol CryptoListInteractorProtocol {
    func fetchData() -> AnyPublisher<Result<[TestCrypto], HttpNetworkError>, Never>
}

// MARK: - Router Protocol

protocol CryptoListRouterProtocol {
    static func composeView() -> AnyView
}
