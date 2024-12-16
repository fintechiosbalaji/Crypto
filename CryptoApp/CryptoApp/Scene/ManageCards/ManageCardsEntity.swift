//
//  ManageCardsEntity.swift
//  CryptoApp
//
//  Created by Rockz on 16/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import Foundation

struct CardTypeEntity: Hashable, Identifiable, CustomStringConvertible {
    var description: String
    let id = UUID()
    let name: String
}

struct Card : Identifiable {
    var id = UUID()
    let cardNumber: String
    let cvv: String
    let cardType: String
    let expirationDate: String
    let logoImage: String
}

enum TabItemType {
  case profile(settingsSections: [SettingsSection])
  case card
  case other(title: String)
}

// Define your CardType enum with available card types
enum CardType:String {
    case visa
    case master
    case amex
    case unowned
}

let mockCardType = [
    CardTypeEntity(description: "Visa", name: "Visa") ,
    CardTypeEntity(description: "Master", name:"Master"),
    CardTypeEntity(description: "Amex", name:"Amex")
]
