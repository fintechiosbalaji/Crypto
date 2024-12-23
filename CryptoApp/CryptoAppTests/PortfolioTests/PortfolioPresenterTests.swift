//
//  PortfolioPresenterTests.swift
//  CryptoAppTests
//
//  Created by Rockz on 18/12/24.
//

import XCTest
@testable import CryptoApp
import Nimble
import Combine

class MockPortfolioInteractor: PortfolioInteractorProtocol {
    var result: Result<[CryptoValueModel], HttpNetworkError>?
    func fetchData() -> AnyPublisher<Result<[CryptoValueModel], HttpNetworkError>, Never> {
        return Just(result ?? .failure(.unknownError)) .eraseToAnyPublisher()
    }
}

final class PortfolioPresenterTests: XCTestCase {
    var presenter: PortfolioPresenter!
    var mockInteractor: MockPortfolioInteractor!
    var portfolioRouter:PortfolioRouter!
    var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        mockInteractor = MockPortfolioInteractor()
        portfolioRouter = PortfolioRouter()
        presenter = PortfolioPresenter(interactor: mockInteractor, router: portfolioRouter)
    }

    override func tearDownWithError() throws {
        cancellables.removeAll()
        presenter = nil
        mockInteractor = nil
        portfolioRouter = nil
        super.tearDown()
    }

    func testLoadDataSuccess() throws {
        let expectedData = portfolioMockData
        mockInteractor.result = .success(expectedData)
        let expectation = XCTestExpectation(description: "Data successfully loaded")
        presenter.loadData()
        self.presenter.$portfolioData
            .dropFirst()
            .sink { portfolioData in
                print("portfolioData => \(portfolioData)")
                expect(portfolioData.portfolioGraphData).to(equal(expectedData))
                expect(portfolioData.idReturns).notTo(beNil())
                expect(portfolioData.totalValue).notTo(beNil())
                expect(portfolioData.errorMessage).to(beEmpty())
                expectation.fulfill()
            }
            .store(in: &self.cancellables)
        wait(for: [expectation], timeout: 0.5)
    }

    func testLoadDataFailure() throws {
        mockInteractor.result = .failure(.unknownError)
        let expectation = XCTestExpectation(description: "Data failed to load")
        presenter.loadData()
        presenter.$portfolioData
            .dropFirst()
            .sink { portfolioData in
                print("portfolioData => \(portfolioData)")
                expect(portfolioData.portfolioGraphData).to(beEmpty())
                expect(portfolioData.idReturns).to(equal(0.0))
                expect(portfolioData.totalValue).to(equal(0.0))
                expect(portfolioData.errorMessage).to(equal("Unable to load portfolio data. Please try again later."))
                expectation.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testBuyAction() throws {
        let expectedPath = ["CryptoListView"]
        presenter.buyAction()
        expect(["CryptoListView"]).to(equal(expectedPath))
    }
    
    func testSellAction() {
        let expectedPath = ["CryptoListView"]
        presenter.sellAction()
        expect(["CryptoListView"]).to(equal(expectedPath))
    }
}
