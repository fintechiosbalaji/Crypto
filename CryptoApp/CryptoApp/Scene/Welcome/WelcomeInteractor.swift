//
//  WelcomeInteractor.swift
//  CryptoApp
//
//  Created by Rockz on 14/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

final class WelcomeInteractor: WelcomeInteractorProtocol {
    
    func fetchWelcomeData() -> WelcomeEntity {
        return mockWelcome
    }
}
