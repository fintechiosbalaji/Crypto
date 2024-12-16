//
//  URLRouter.swift
//  Viper_Combine_SampleApp
//
//  Created by Erdem Papakçı on 17.07.2023.
//

import Foundation

enum URLRouter {
    case portfolio
    case fetchCrypto
    case currency(input: String, output: String)
    case fetchCurrency
    
    var path: String {
        switch self {
        case .portfolio:
            return "portfolio/chart"
        case .fetchCrypto:
            return "fetchCrypto"
        case .currency(let input, let output):
            return "latest?apikey=fca_live_wszbubSLdfPixfUUQETSlDxLs9Tn2zG0LDLRUi1M&currencies=\(output)&base_currency=\(input)"
        case .fetchCurrency:
            return "currencies?apikey=fca_live_wszbubSLdfPixfUUQETSlDxLs9Tn2zG0LDLRUi1M&currencies="
        }
    }
}
