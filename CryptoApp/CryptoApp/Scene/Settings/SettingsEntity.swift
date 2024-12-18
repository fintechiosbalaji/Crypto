//
//  SettingsEntity.swift
//  CryptoApp
//
//  Created by Rockz on 16/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import Foundation

// Language Model
struct LanguageModel {
    let language: Language
}

enum Language: String, CaseIterable {
    case english_us = "en"
    case french = "fr"
    case arabic = "ar"
    
    var displayName: String {
        switch self {
        case .english_us: return "English (US)"
        case .french: return "French"
     //   case .tamil: return "Tamil"
        case .arabic: return "Arabic"
        }
    }
}

struct SettingsSection: Identifiable {
    let id = UUID()
    let title: String
    let items: [SettingsItem]
}

struct SettingsItem: Identifiable {
    let id = UUID()
    let text: String
    let image: String?
    let url: String?
    
    init(text: String, image: String?, url: String? = nil) {
        self.text = text
        self.image = image
        if text == "Privacy Policy" {
            self.url = "https://www.kaspersky.com/resource-center/definitions/what-is-cryptocurrency"
        } else if text == "Terms and Conditions" {
            self.url = "https://crypto.com"
        } else {
            self.url = url
        }
    }
}

struct Video: Identifiable {
    let id = UUID()
    let title: String
    let url: String
    let description: String
}

let mockCryptoVideos: [Video] = [
    Video(title: "Introduction to Blockchain",
          url: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8",
          description: "Learn the basics of blockchain technology and how it works."),
    
    Video(title: "How Bitcoin Works",
          url: "https://youtu.be/ZyBpG8EEllc?si=PLUtORj3cE-ljCjV",
          description: "Understand the fundamentals of Bitcoin and its decentralized nature."),
    
    Video(title: "Ethereum and Smart Contracts",
          url: "https://youtu.be/ZyBpG8EEllc?si=PLUtORj3cE-ljCjV",
          description: "Explore Ethereum's blockchain and how smart contracts are transforming industries."),
    
    Video(title: "What is Cryptocurrency Mining?",
          url: "https://example.com/crypto-mining",
          description: "A deep dive into how cryptocurrency mining works and its role in the blockchain network."),
    
    Video(title: "Decentralized Finance (DeFi) Explained",
          url: "https://example.com/defi-explained",
          description: "An overview of Decentralized Finance (DeFi) and its impact on the financial system."),
    
    Video(title: "Understanding NFTs (Non-Fungible Tokens)",
          url: "https://example.com/nfts-explained",
          description: "Learn what NFTs are, how they work, and their role in the digital world."),
    
    Video(title: "Crypto Trading Strategies for Beginners",
          url: "https://example.com/crypto-trading-beginners",
          description: "Tips and strategies for beginners looking to trade cryptocurrencies."),
    
    Video(title: "The Future of Web 3.0",
          url: "https://example.com/web3-future",
          description: "Explore how Web 3.0 and blockchain technologies will revolutionize the internet."),
    
    Video(title: "How to Secure Your Crypto Wallet",
          url: "https://example.com/secure-crypto-wallet",
          description: "Best practices for keeping your cryptocurrency wallet safe and secure."),
    
    Video(title: "Top 5 Altcoins to Watch This Year",
          url: "https://example.com/top-altcoins-2024",
          description: "A list of promising altcoins with high growth potential.")
]


let mockSettings: [SettingsSection] = [
    SettingsSection(title: LocalizationKeys.Settings.support, items: [
        SettingsItem(text: LocalizationKeys.Settings.credits, image: "card-credit"),
        SettingsItem(text: LocalizationKeys.Settings.contactSupport, image: "telephone"),
        SettingsItem(text: LocalizationKeys.Settings.termsAndConditions,
                     image: "terms-and-conditions"),
        SettingsItem(text: LocalizationKeys.Settings.privacyPolicy,image: "insurance")
    ]),
    SettingsSection(title: LocalizationKeys.Settings.generalSettings, items: [
        SettingsItem(text: LocalizationKeys.Settings.helpCenter, image: "chat"),
        SettingsItem(text: LocalizationKeys.Settings.security, image: "security"),
    ]),
    SettingsSection(title: LocalizationKeys.Settings.logout, items: [
        SettingsItem(text: LocalizationKeys.Settings.logout, image: "logout"),
    ])
]
