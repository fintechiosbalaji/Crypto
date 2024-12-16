//
//  MarketView.swift
//  CryptoApp
//
//  Created by Rockz on 17/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
import Charts

struct MarketView: View, MarketViewProtocol {
    
    @ObservedObject
    private var presenter: MarketPresenter
    @AppStorage("theme") var isDarkMode: Bool = true
    
    init(presenter: MarketPresenter) {
        self.presenter = presenter
    }
    
    var body: some View {
        ZStack {
            Color("primaryColor")
                .edgesIgnoringSafeArea(.top)
            ScrollView {
                VStack(spacing: 20) {
                    if presenter.cryptoDataSeries.isEmpty {
                        EmptyView()
                        .progressLoader(
                                progressMessage: LocalizationKeys.Portfolio.downloading,
                                additionalMessage: LocalizationKeys.Portfolio.fetchingData
                            )
                    } else {
                        CryptoProfitSectorChart(cryptoList: presenter.cryptoDataSeries)
                        BarChartWithTimePeriodView(cryptoList: presenter.cryptoDataSeries)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .padding(.bottom, 20)
            .primaryBackground()
        }
        .edgesIgnoringSafeArea(.top) // Avoids overlap with status bar
        .modifier(DarkModeViewModifier())
        .onAppear {
            presenter.fetchMarketData()
        }
    }
}

struct MarketView_Previews: PreviewProvider {
    static var previews: some View {
        MarketRouter.composeView()
    }
}
