//
//  ThemeManager.swift
//  CryptoApp
//
//  Created by Rockz on 04/12/24.
//

import SwiftUI

enum Theme: String, CaseIterable {
    case light
    case dark

    var scheme: ColorScheme {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

class ThemeManager: ObservableObject {
    @Published var currentTheme: Theme = .light
}
