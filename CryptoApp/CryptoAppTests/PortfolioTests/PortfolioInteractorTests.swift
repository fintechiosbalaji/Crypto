//
//  PortfolioInteractorTests.swift
//  CryptoAppTests
//
//  Created by Rockz on 18/12/24.
//

import XCTest
@testable import CryptoApp
import Nimble
import Combine

class MockNetworkManager: NetworkManagerProtocol {
    var result: Any?

    func get<T: Decodable>(
        type: T.Type,
        router: URLRouter,
        parameters: [String: Any]?,
        headers: [String: String]?,
        count: Int,
        method: RequestMethod
    ) -> AnyPublisher<Result<T, HttpNetworkError>, Never> {
        if let result = result as? Result<T, HttpNetworkError> {
            return Just(result)
                .eraseToAnyPublisher()
        }
        return Just(Result.failure(.unknownError))
            .eraseToAnyPublisher()
    }
    
    func buildRequest(router: URLRouter, parameters: [String: Any]?, headers: [String: String]?, count: Int, method: RequestMethod) -> URLRequest? {
        // Mock implementation
        return nil
    }
}

final class PortfolioInteractorTests: XCTestCase  {
    
    var interactor: PortfolioInteractor!
    var mockService: MockNetworkManager!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        mockService = MockNetworkManager()
        interactor = PortfolioInteractor(service: mockService)
    }

    override func tearDownWithError() throws {
        cancellables.removeAll()
        mockService = nil
        super.tearDown()
    }
    
    func testFetchDataSuccess() throws {
        let expectedData = portfolioMockData
        mockService.result = Result<[CryptoValueModel], HttpNetworkError>.success(expectedData)
        waitUntil { done in
            self.interactor.fetchData()
                .sink { result in
                    expect(result).to(beSuccess())
                    done()
                }
                .store(in: &self.cancellables)
        }
    }

    func testFetchDataFailure() throws {
        mockService.result = Result<[CryptoValueModel], HttpNetworkError>.failure(.unknownError)
        waitUntil { done in
            self.interactor.fetchData()
                .sink { result in
                    expect(result).to(beFailure())
                    done()
                }
                .store(in: &self.cancellables)
        }
    }
}
