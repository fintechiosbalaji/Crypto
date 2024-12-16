//
//  TabViewEntity.swift
//  CryptoApp
//
//  Created by Rockz on 16/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import Foundation

enum TabbedItems: Int, CaseIterable{
    case Portfolio
    case Markets
    case Card
    case currencyExchange
    case profile
    
    var title: String {
        switch self {
        case .Portfolio:
            return "Portfolio"
        case .Markets:
            return "Markets"
        case .Card:
            return "Cards"
        case .currencyExchange:
            return "Convert"
        case .profile:
            return "Profile"
        }
    }
    
    var iconName: String {
        switch self {
        case .Portfolio:
            return "line-chart"
        case .Markets:
            return "briefcase"
        case .Card:
            return "card"
        case .currencyExchange:
            return "exchange"
        case .profile:
            return "user"
        }
    }
}
