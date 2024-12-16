//
//  SettingsContracts.swift
//  CryptoApp
//
//  Created by Rockz on 16/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import SwiftUI

// MARK: - View Protocol

protocol SettingsViewProtocol {
    
}

// MARK: - Presenter Protocol
protocol SettingsPresenterProtocol {
    func loadSettings()
}

// MARK: - Interactor Protocol
protocol SettingsInteractorProtocol {
    func loadSettingsdata() -> [SettingsSection]
    func addLanguageObserver()
}

// MARK: - Router Protocol
protocol SettingsRouterProtocol {
    static func composeView() -> AnyView
}
