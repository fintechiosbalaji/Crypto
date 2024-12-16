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
    
    func addLanguageObserver() {
        NotificationCenter.default.publisher(for: LocalizationService.changedLanguage)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.language = LocalizationService.shared.language
                
                self.languageModel = Language.allCases
            }.store(in: &cancellables)
    }
}

// Language Model 
struct LanguageModel {
    let language: Language
}

enum Language: String, CaseIterable {
    case english_us = "en"
    case french = "fr"
   // case tamil = "ta"
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
