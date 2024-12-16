//
//  TabViewContracts.swift
//  CryptoApp
//
//  Created by Rockz on 16/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import SwiftUI

// MARK: - View Protocol

protocol TabViewViewProtocol {
    
}

// MARK: - Presenter Protocol

protocol TabViewPresenterProtocol {
}

// MARK: - Interactor Protocol

protocol TabViewInteractorProtocol {
//func loadTabViewData() -> [TabItem]
}

// MARK: - Router Protocol

protocol TabViewRouterProtocol {
    static func composeView() -> AnyView
}
