//
//  PortfolioView.swift
//  CryptoApp
//
//  Created by Rockz on 21/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import SwiftUI
import Charts

struct PortfolioView: View, PortfolioViewProtocol {
    
    @ObservedObject
    private var presenter: PortfolioPresenter
    @ObservedObject var walletBalanceViewModel: WalletBalanceViewModel
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    init(presenter: PortfolioPresenter, walletBalanceViewModel: WalletBalanceViewModel) {
        self.presenter = presenter
        self.walletBalanceViewModel = walletBalanceViewModel
    }
    
    private var balance: String {
        let localizedBalanceText = LocalizationKeys.Portfolio.balance.localized(language)
        let balanceValue = walletBalanceViewModel.balance
        return String(format: "%@ %@", localizedBalanceText, balanceValue)
    }
    
    var body: some View {
        NavigationStack(path: $presenter.portfolioData.path) {
            ZStack {
                Color("primaryColor")
                    .edgesIgnoringSafeArea(.top)
                ScrollView {
                    VStack (spacing: 20) {
                        Text(balance)
                            .valueStyle()
                            .frame(maxWidth: .infinity, maxHeight: 25)
                        InvestmentProfitView(
                            investedAmount: presenter.portfolioData.totalValue,
                            profitOrLoss: presenter.portfolioData.idReturns
                        )
                        HStack {
                            ActionButton(title: LocalizationKeys.Portfolio.buy, backgroundColor: .green, action: presenter.buyAction)
                            ActionButton(title: LocalizationKeys.Portfolio.sell, backgroundColor: .red, action: presenter.sellAction)
                        }
                        VStack {
                            CryptoMultiLineChartView(data: presenter.portfolioData.portfolioGraphData.filter({ $0.purchasedFlag}))
                                .gradientBackground(colors: [Color.white])
                        }
                    }
                    .padding()
                }
                .onAppear {
                    presenter.loadData()
                }
                .navigationDestination(for: String.self) { view in
                    if view == "CryptoListView" {
                        presenter.router.navigateToCryptoList()
                    }
                }
                .navigationBarBackButtonHidden(true)
                .padding(.bottom, 20)
                .primaryBackground()
            }
            .edgesIgnoringSafeArea(.top)
            .modifier(DarkModeViewModifier())
        }
    }
}

struct InvestmentProfitView: View {
    
    let investedAmount: Double
    let profitOrLoss: Double
    //  total return as a percentage
    var totalReturn: Double {
        guard investedAmount != 0 else { return 0 }
        return (profitOrLoss / investedAmount) * 100
    }
    
    var body: some View {
        HStack {
            // Investment Section
            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizationKeys.Portfolio.investment.localizedKey)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                Text(formatCurrency(investedAmount))
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            // Profit Section
            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizationKeys.Portfolio.idReturns.localizedKey)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                HStack(spacing: 6) {
                    Text(formatCurrency(abs(profitOrLoss)))
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                    Image(systemName: profitOrLoss >= 0 ? "arrow.up" : "arrow.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(profitOrLoss >= 0 ? .green : .red)
                }
            }
            // Total Return Section
            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizationKeys.Portfolio.totalReturn.localizedKey)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                Text(String(format: "%.2f%%", totalReturn))
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(totalReturn >= 0 ? .green : .red)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .gradientBackground(colors: [Color.blue, Color.purple])
    }
    
    func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "₹"
        return formatter.string(from: NSNumber(value: value)) ?? "₹0.00"
    }
}

struct CryptoMultiLineChartView: View {
    
    let data: [CryptoValueModel]
    
    var body: some View {
        ZStack {
            if data.isEmpty {
                EmptyView()
                .progressLoader(
                        progressMessage: LocalizationKeys.Portfolio.downloading,
                        additionalMessage: LocalizationKeys.Portfolio.fetchingData
                    )
            } else {
                Chart(data, id: \.type) { dataSeries in
                    ForEach(dataSeries.data) { data in
                        LineMark(
                            x: .value(LocalizationKeys.Portfolio.date.localizedKey, data.date),
                            y: .value(LocalizationKeys.Portfolio.price.localizedKey, data.value)
                        )
                    }
                    .foregroundStyle(by: .value(LocalizationKeys.Portfolio.currency.localizedKey, dataSeries.type))
                    .symbol(by: .value(LocalizationKeys.Portfolio.currency.localizedKey, dataSeries.type))
                }
                .chartXScale(domain: .automatic)
                .chartYScale(domain: 0...90000)
                .aspectRatio(1, contentMode: .fit)
                .padding()
            }
        }
    }
}

struct CryptoCoinView: View {
    let name: String
    let symbol: String
    
    var body: some View {
        VStack {
            Circle()
                .fill(Color.white.opacity(0.2))
                .frame(width: 80, height: 80)
                .overlay(
                    Text(symbol)
                        .font(.headline)
                        .foregroundColor(.white)
                )
            Text(name)
                .font(.subheadline)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }
}

