//
//  MarketEntity.swift
//  CryptoApp
//
//  Created by Rockz on 17/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import Foundation
import SwiftUI

struct MarketData: Decodable {
    let cryptoData: [CryptoType]
}

struct CryptoType: Decodable, Identifiable {
    var id = UUID()
    let type: String
    let data: [CryptoData]

    enum CodingKeys: String, CodingKey {
        case type
        case data
    }
}

struct CryptoData: Identifiable, Decodable {
    var id: UUID
    let date: Int
    let price: Double
    let currency: String

    enum CodingKeys: String, CodingKey {
        case date
        case price
        case currency
    }

    init(id: UUID = UUID(), date: Int, price: Double, currency: String) {
        self.id = id
        self.date = date
        self.price = price
        self.currency = currency
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try container.decode(Int.self, forKey: .date)
        self.price = try container.decode(Double.self, forKey: .price)
        self.currency = try container.decode(String.self, forKey: .currency)
        self.id = UUID() // Generate UUID here to ensure it's set correctly
    }
}
