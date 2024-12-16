//
//  CryptoListEntity.swift
//  CryptoApp
//
//  Created by Rockz on 25/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import Foundation
import SwiftUI

struct CryptoListEntity: Identifiable {
    let id = UUID()
    let name : String
}

let mockCryptoList: CryptoListEntity = CryptoListEntity(name: "CryptoListEntity.swift")

import SwiftUI
import Charts

// MARK: - Chart Data Model
struct TestChartData: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
    let label: String
    let color: Color
}

// MARK: - Crypto Data
struct TestCrypto: Identifiable, Codable {
    let id = UUID()
    let name: String
    let symbol: String
    var currentPrice: String
    var priceTrends: [PriceTrend]
    var purchased: Bool
}

extension TestCrypto {
    var currentPriceValue: Double {
        let cleanedPrice = currentPrice.replacingOccurrences(of: "₹", with: "").replacingOccurrences(of: ",", with: "")
        return Double(cleanedPrice) ?? 0.0
    }
}

struct PriceTrend: Codable {
    let value: Double
    var date: Date? = Date()
}


// MARK: - Date Utilities
func last7Days() -> [Date] {
    let calendar = Calendar.current
    let today = Date()
    return (0..<7).compactMap { calendar.date(byAdding: .day, value: -$0, to: today) }.reversed()
}

func generateLast7DaysValues(values: [Double]) -> [PriceTrend] {
    let dates = last7Days() // Helper to get the last 7 dates
    return zip(dates, values).map { PriceTrend(value: $0.1, date: $0.0) }
}


// New model to hold the date and value pair
struct PriceTrendWithDate: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}



//let sampleCryptos: [TestCrypto] = {
//    let last7DaysDates = last7Days()
//    return [
//        TestCrypto(
//            name: "Bitcoin",
//            symbol: "BTC",
//            currentPrice: "₹64,000",
//            priceTrends: zip(last7DaysDates, [58000, 62000, 64000, 63000, 61000, 58000, 57000]).map { ($0.0, $0.1) },
//            purchased: true // User purchased this coin
//        ),
//        TestCrypto(
//            name: "Ethereum",
//            symbol: "ETH",
//            currentPrice: "₹4,000",
//            priceTrends: zip(last7DaysDates, [3900, 3950, 4000, 4050, 4100, 4200, 4300]).map { ($0.0, $0.1) },
//            purchased: true
//        ),
//        TestCrypto(
//            name: "Cardano",
//            symbol: "ADA",
//            currentPrice: "₹2.10",
//            priceTrends: zip(last7DaysDates, [2.0, 2.05, 2.08, 2.10, 2.12, 2.15, 2.20]).map { ($0.0, $0.1) },
//            purchased: false
//        ),
//        TestCrypto(
//            name: "Ripple",
//            symbol: "XRP",
//            currentPrice: "₹50.30",
//            priceTrends: zip(last7DaysDates, [48.0, 49.5, 50.0, 50.5, 50.3, 51.0, 52.0]).map { ($0.0, $0.1) },
//            purchased: false
//        ),
//        TestCrypto(
//            name: "Litecoin",
//            symbol: "LTC",
//            currentPrice: "₹7,500",
//            priceTrends: zip(last7DaysDates, [7200, 7300, 7400, 7500, 7450, 7550, 7600]).map { ($0.0, $0.1) },
//            purchased: false
//        )
//    ]
//}()
//


