//
//  PortfolioInteractor.swift
//  CryptoApp
//
//  Created by Rockz on 21/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import Combine
import Foundation

final class PortfolioInteractor: PortfolioInteractorProtocol {
    
    let service: NetworkManagerProtocol
    
    init(service: NetworkManagerProtocol) {
        self.service = service
    }
    
    func fetchData() -> AnyPublisher<Result<[CryptoValueModel], HttpNetworkError>, Never> {
        self.service.get(type: [CryptoValueModel].self,
                         router: .portfolio,
                         parameters: nil,
                         headers: nil,
                         count: 0,
                         method: .get)
    }
}
