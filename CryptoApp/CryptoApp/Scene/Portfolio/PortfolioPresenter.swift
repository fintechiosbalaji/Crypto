//
//  PortfolioPresenter.swift
//  CryptoApp
//
//  Created by Rockz on 21/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import Combine
import SwiftUI

class WalletBalanceViewModel: ObservableObject {
    @Published var balance: String = "₹ 50,234"
}

protocol PortfolioDataProtocol {
    var totalValue: Double { get set }
    var idReturns: Double { get set }
    var errorMessage: String { get set }
    var portfolioGraphData: [CryptoValueModel] { get set }
    var showingSheet: Bool { get set }
    var path: NavigationPath { get set }
    var balance: String { get set }
}

struct PortfolioData: PortfolioDataProtocol {
    var totalValue: Double = 0.0
    var idReturns: Double = 0.0
    var errorMessage: String = ""
    var portfolioGraphData: [CryptoValueModel] = []
    var showingSheet: Bool = false
    var path: NavigationPath = NavigationPath()
    var balance: String = "₹ 50,234"
}

final class PortfolioPresenter: PortfolioPresenterProtocol, ObservableObject {

    @Published var portfolioData: PortfolioDataProtocol = PortfolioData()
    private var cancellables = Set<AnyCancellable>()
    private let interactor: PortfolioInteractorProtocol
    let router: PortfolioRouterProtocol
    
    init(
        interactor: PortfolioInteractorProtocol,
        router: PortfolioRouterProtocol
    ) {
        self.interactor = interactor
        self.router = router
    }
    
    func loadData() {
        interactor.fetchData()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let portfolioData):
                    self?.portfolioData.portfolioGraphData = portfolioData
                    self?.portfolioData.idReturns = portfolioData.first?.idReturns ?? 0.0
                    self?.portfolioData.totalValue = portfolioData.filter { $0.purchasedFlag }.reduce(0) { $0 + $1.totalValue }
                case .failure(_):
                    // Handle failure, show error
                    self?.portfolioData.errorMessage = "Unable to load portfolio data. Please try again later."
                }
            }
            .store(in: &cancellables)
    }
    
    func buyAction() {
        self.portfolioData.path.append("CryptoListView")
        print("Buy action triggered")
    }
    
    func sellAction() {
        print("Sell action triggered")
    }
    
    func detailsAction() {
        print("Details action triggered")
    }
}
