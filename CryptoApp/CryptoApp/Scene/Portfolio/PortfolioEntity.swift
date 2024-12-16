//
//  PortfolioEntity.swift
//  CryptoApp
//
//  Created by Rockz on 21/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import Foundation
import Combine

struct Portfolio: Codable {
    let portfolio: [CryptoCoin]
    let purchased: [CryptoPurchase] // Newly added property
}

struct CryptoCoin: Identifiable, Codable {
    let id: UUID  // Ensure UUID conforms to Codable explicitly
    let name: String
    let symbol: String
    let amountOwned: Double
    let weeklyValues: [Double]? // Weekly price values, optional in case it's not available
    
    // Computed property to generate the dates for the last 7 days
    var dates: [Date]? {
        guard let weeklyValues = weeklyValues, weeklyValues.count == 7 else {
            return nil
        }
        
        // Get the current date and create dates for the last 7 days
        var dateArray = [Date]()
        let calendar = Calendar.current
        
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: -i, to: Date()) {
                dateArray.insert(date, at: 0) // Insert at the start to get the correct order
            }
        }
        
        return dateArray
    }
    
    init(name: String, symbol: String, amountOwned: Double, weeklyValues: [Double]?) {
        self.id = UUID()  // Generate a new UUID when initializing
        self.name = name
        self.symbol = symbol
        self.amountOwned = amountOwned
        self.weeklyValues = weeklyValues
    }
}

struct CryptoPurchase: Codable {
    let name: String
    let symbol: String
    let amountOwned: Double
    let weeklyValues: [Double] // Holds 7 days of data
}

struct CryptoValueModel: Identifiable, Codable {
    let id = UUID()
    let type: String
    let data: [CryptoGraphData]
    let purchasedFlag: Bool
    
    var totalValue: Double {
        return data.reduce(0) { $0 + $1.value }
    }
    
    var idReturns: Double {
        guard let firstValue = data.first?.value, let lastValue = data.last?.value else {
            return 0
        }
        return lastValue - firstValue
    }
}

struct CryptoGraphData: Identifiable, Codable {
    let id = UUID()
    let date: String
    let value: Double
}

let portfolioMockData: [CryptoValueModel] = [
    CryptoValueModel(type: "BTC", data: [
        CryptoGraphData(date: "2024-11-01", value: 29000),
        CryptoGraphData(date: "2024-11-02", value: 31000),
        CryptoGraphData(date: "2024-11-03", value: 36000),
        CryptoGraphData(date: "2024-11-04", value: 12350),
        CryptoGraphData(date: "2024-11-05", value: 77020)
    ], purchasedFlag: true),  // Added purchased flag
    CryptoValueModel(type: "ETH", data: [
        CryptoGraphData(date: "2024-11-01", value: 4000),
        CryptoGraphData(date: "2024-11-02", value: 4050),
        CryptoGraphData(date: "2024-11-03", value: 50020),
        CryptoGraphData(date: "2024-11-04", value: 40500),
        CryptoGraphData(date: "2024-11-05", value: 33020)
    ], purchasedFlag: false),  // Added purchased flag
    CryptoValueModel(type: "RTH", data: [
        CryptoGraphData(date: "2024-11-01", value: 2000),
        CryptoGraphData(date: "2024-11-02", value: 12050),
        CryptoGraphData(date: "2024-11-03", value: 45520),
        CryptoGraphData(date: "2024-11-04", value: 5050),
        CryptoGraphData(date: "2024-11-05", value: 71020)
    ], purchasedFlag: true)
]
