//
//  SettingsEntity.swift
//  CryptoApp
//
//  Created by Rockz on 16/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import Foundation

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
