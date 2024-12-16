//
//  PieChartView.swift
//  CryptoApp
//
//  Created by Rockz on 26/11/24.
//

import Foundation
import SwiftUI
import Charts

struct CryptoProfit : Identifiable {
    let id = UUID()
    let name: String
    let profitPercentage: Double
}


struct CryptoProfitSectorChart: View {
    
    let cryptoList : [TestCrypto]
    
    var purchasedCryptos: [CryptoProfit] {
        // Filter purchased cryptos
        let purchased = cryptoList.filter { $0.purchased }  // Use cryptoList from Singleton
        let totalValue = purchased.reduce(0) { $0 + ($1.priceTrends.last?.value ?? 0.0) }
        
        return purchased.map { crypto in
            let lastValue = crypto.priceTrends.last?.value ?? 0
            let percentage = totalValue > 0 ? (lastValue / totalValue) * 100 : 0
            return CryptoProfit(name: crypto.name, profitPercentage: percentage)
        }
    }
    
    var body: some View {
        Chart(purchasedCryptos) { crypto in
            SectorMark(
                angle: .value(
                    Text(verbatim: crypto.name),
                    crypto.profitPercentage
                ),
                innerRadius: .ratio(0.6),
                angularInset: 8
            )
            .foregroundStyle(
                by: .value(
                    Text(verbatim: crypto.name),
                    crypto.name
                )
            )
            .annotation(position: .overlay, alignment: .center) { // Add text labels
                Text("\(crypto.name): \(crypto.profitPercentage, specifier: "%.1f")%")
                    .font(.caption)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .frame(height: 250)
        .alphaPrimaryBackground()
        .cornerRadius(15)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}


