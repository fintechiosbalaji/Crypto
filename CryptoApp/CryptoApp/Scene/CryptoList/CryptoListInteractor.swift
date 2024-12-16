//
//  CryptoListInteractor.swift
//  CryptoApp
//
//  Created by Rockz on 25/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import Combine
import SwiftUI

final class CryptoListInteractor: CryptoListInteractorProtocol {
    
    private let dependencies: CryptoListInteractorDependenciesProtocol
    let service: NetworkManagerProtocol
    
    init(dependencies: CryptoListInteractorDependenciesProtocol,service: NetworkManagerProtocol) {
        self.dependencies = dependencies
        self.service = service
    }
    
    func fetchData() -> AnyPublisher<Result<[TestCrypto], NetworkError>, Never> {
        return self.service.get(type: [TestCrypto].self,
                                router: .fetchCrypto,
                                parameters: nil,
                                headers: nil,
                                count: 0,
                                method: .get)
    }
}
