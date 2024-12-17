//
//  SettingsInteractor.swift
//  CryptoApp
//
//  Created by Rockz on 16/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//
import Combine
import NotificationCenter
import SwiftUI

final class SettingsInteractor: SettingsInteractorProtocol {
    
    private var language = LocalizationService.shared.language
    private var cancellables = Set<AnyCancellable>()
    var languageModel:[Language] = []
    
    func loadSettingsdata() -> [SettingsSection] {
        return mockSettings
    }
}

