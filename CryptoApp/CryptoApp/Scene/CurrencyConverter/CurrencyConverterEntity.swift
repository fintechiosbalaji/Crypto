//
//  CurrencyConverterEntity.swift
//  CryptoApp
//
//  Created by Rockz on 29/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import Foundation

struct CurrencyData: Decodable {
    let data: [String: Double]
}

struct CurrencyList: Decodable {
    let data: [String: Datum]
}

// MARK: - Curency
struct Datum: Codable {
    let symbol, name, symbolNative: String
    let decimalDigits, rounding: Int
    let code, namePlural: String
    let type: TypeEnum

    enum CodingKeys: String, CodingKey {
        case symbol, name
        case symbolNative = "symbol_native"
        case decimalDigits = "decimal_digits"
        case rounding, code
        case namePlural = "name_plural"
        case type
    }
}

enum TypeEnum: String, Codable {
    case fiat = "fiat"
}

struct CurrencyConverterEntity: Hashable, CustomStringConvertible, Identifiable {
    let id = UUID()
    let symbol: String
    let name: String

    var description: String {
        "\(name) (\(symbol))"
    }
}
