//
//  SettingsPresenter.swift
//  CryptoApp
//
//  Created by Rockz on 16/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import Combine
import SwiftUI

final class SettingsPresenter: SettingsPresenterProtocol, ObservableObject {
    private let interactor: SettingsInteractorProtocol
    private let router: SettingsRouterProtocol
    @Published var settingsSections: [SettingsSection] = []
    
    init(
        interactor: SettingsInteractorProtocol,
        router: SettingsRouterProtocol
    ) {
        self.interactor = interactor
        self.router = router
    }
    
    func loadSettings() {
        settingsSections = interactor.loadSettingsdata()
    }
}
