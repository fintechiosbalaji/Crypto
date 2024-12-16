//
//  MarketInteractor.swift
//  CryptoApp
//
//  Created by Rockz on 17/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//
import Combine
import SwiftUI

final class MarketInteractor: MarketInteractorProtocol {
    
    let service: NetworkManagerProtocol
    
    init(service: NetworkManagerProtocol) {
        self.service = service
    }
    
//    private let apiURL = "https://a81727e2-0654-4f1f-8a4e-83549fe959b2.mock.pstmn.io/linechart"
//    private var cancellables = Set<AnyCancellable>()
//    
//    func fetchMarketData() -> AnyPublisher<MarketData, Error> {
//        guard let url = URL(string: apiURL) else {
//            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
//        }
//        
//        return URLSession.shared.dataTaskPublisher(for: url)
//            .map { $0.data }
//            .decode(type: MarketData.self, decoder: JSONDecoder())
//            .eraseToAnyPublisher()
//    }
    
    func fetchMarketData() -> AnyPublisher<Result<[TestCrypto], NetworkError>, Never> {
        return self.service.get(type: [TestCrypto].self,
                                router: .fetchCrypto,
                                parameters: nil,
                                headers: nil,
                                count: 0,
                                method: .get)
    }
}
