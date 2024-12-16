//
//  BarchartView.swift
//  CryptoApp
//
//  Created by Rockz on 26/11/24.
//

import Foundation
import Charts
import SwiftUI

// Bar chart view
struct BarChartView: View {
    let cryptos: [CryptoProfit]
    
    var body: some View {
        Chart(cryptos) { crypto in
            BarMark(
                x: .value("Crypto", crypto.name),
                y: .value("Profit Percentage", crypto.profitPercentage),
                width: 30
            )
            .foregroundStyle(by: .value("Crypto", crypto.name))
            .cornerRadius(5)
            .annotation(position: .trailing) {
                Text("\(crypto.name): \(crypto.profitPercentage, specifier: "%.1f")%")
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(.white)
                            }
        }
        .frame(height: 250)
        .chartLegend(position: .bottom, alignment: .bottomLeading)
    }
}

enum TimePeriod: String, CaseIterable {
    case weekly = "Weekly"
    case monthly = "Monthly"
    case custom = "Custom"
}

struct BarChartWithTimePeriodView: View {
    let cryptoList : [TestCrypto]
    
    @AppStorage("theme") var isDarkMode: Bool = true
    @State private var selectedTimePeriod: TimePeriod = .weekly
    @State private var startDate: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date() // One month ago
    @State private var endDate: Date = Date()
    @State private var showDatePickers = false
    
    var body: some View {
        VStack {
            Picker("Select Time Period", selection: $selectedTimePeriod) {
                ForEach(TimePeriod.allCases, id: \.self) { period in
                    Text(period.rawValue).tag(period)
                }
            }
            .padding(4)
            .background(isDarkMode ? .orange : .gray)
            .cornerRadius(10)
            .pickerStyle(SegmentedPickerStyle())
            if selectedTimePeriod == .custom {
                VStack {
                    DatePicker("Start Date", selection: $startDate, in: Calendar.current.date(byAdding: .month, value: -1, to: Date())!...Date.now, displayedComponents: [.date])
                        .foregroundColor(isDarkMode ? .white : .black)
                        .colorMultiply(Color.white)
                        .accentColor(.blue)
                    
                    DatePicker("End Date", selection: $endDate, in: startDate...Date.now, displayedComponents: [.date])
                        .foregroundColor(isDarkMode ? .white : .black)
                        .colorMultiply(Color.white)
                        .accentColor(.blue)
                }
                .padding()
                .alphaPrimaryBackground()
                .cornerRadius(10)
            }
            // Bar chart for purchased coins
            BarChartView(cryptos: filteredCryptos)
                .padding()
                .alphaPrimaryBackground()
                .cornerRadius(15)
        }
    }
    
    private var filteredCryptos: [CryptoProfit] {
        let purchasedCryptos = cryptoList.filter { $0.purchased }
        
        return purchasedCryptos.map { crypto in
            var filteredTrends: [(Date, Double)] = []
            
            // Process the price trends based on the selected time period
            switch selectedTimePeriod {
            case .weekly:
                filteredTrends = Array(crypto.priceTrends.prefix(7)).map { ($0.date ?? Date(), $0.value) } // Last 7 days
            case .monthly:
                filteredTrends = generateMonthlyTrends(for: crypto) // Last 30 days
            case .custom:
                filteredTrends = filterPriceTrends(for: crypto) // No filter, all available data
            }
            // Calculate profit percentage based on first and last value in the filtered trend
            let firstValue = filteredTrends.first?.1 ?? 0
            let lastValue = filteredTrends.last?.1 ?? 0
            let profitPercentage = firstValue > 0 ? ((lastValue - firstValue) / firstValue) * 100 : 0
            
            return CryptoProfit(name: crypto.name, profitPercentage: profitPercentage)
        }
    }
    
    private func filterPriceTrends(for crypto: TestCrypto) -> [(Date, Double)] {
        // Filter price trends based on the start and end dates
        return crypto.priceTrends.filter { trend in
            if let trendDate = trend.date {
                return trendDate >= startDate && trendDate <= endDate
            } else {
                return false
            }
        }.map { ($0.date ?? Date(), $0.value) }
    }
    
    private func generateMonthlyTrends(for crypto: TestCrypto) -> [(Date, Double)] {
        var monthlyTrends: [(Date, Double)] = []
        
        // For simplicity, we are using the first 7 days data as a base, and then simulating the rest of the month
        let weeklyData = Array(crypto.priceTrends.prefix(7)).map { ($0.date ?? Date(), $0.value) }
        monthlyTrends.append(contentsOf: weeklyData)
        
        // Generate 30 days of data
        let randomFluctuation: (Double) -> Double = { value in
            return value * Double.random(in: 0.95...1.05) // Adding a small random fluctuation
        }
        
        // Generate the next 23 days of data based on weekly data
        for i in 7..<30 {
            let lastPrice = monthlyTrends[i - 1].1
            let newPrice = randomFluctuation(lastPrice)
            let date = Calendar.current.date(byAdding: .day, value: i, to: Date())!
            monthlyTrends.append((date, newPrice))
        }
        return monthlyTrends
    }
    
}
