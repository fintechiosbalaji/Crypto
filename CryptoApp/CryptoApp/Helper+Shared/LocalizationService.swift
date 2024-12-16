//
//  Localization.swift
//  CryptoApp
//
//  Created by Rockz on 16/12/24.
//

import Foundation
import SwiftUI

class LanguageManager: ObservableObject {
    @Published var currentLanguage: Language = LocalizationService.shared.language {
        didSet {
            LocalizationService.shared.language = currentLanguage
        }
    }
}

class LocalizationService {

    static let shared = LocalizationService()
    static let changedLanguage = Notification.Name("changedLanguage")

    private init() {}
    
    var language: Language {
        get {
            guard let languageString = UserDefaults.standard.string(forKey: "language") else {
                return .english_us
            }
            return Language(rawValue: languageString) ?? .english_us
        } set {
            if newValue != language {
                UserDefaults.standard.setValue(newValue.rawValue, forKey: "language")
                NotificationCenter.default.post(name: LocalizationService.changedLanguage, object: nil)
            }
        }
    }
}

/*
extension Bundle {
    private static var once: Bool = false
    
    static func setLanguage(_ language: String) {
        if !once {
            object_setClass(Bundle.main, PrivateBundle.self)
            once = true
        }
        UserDefaults.standard.set(language, forKey: "language")
        UserDefaults.standard.synchronize()
    }
}

private class PrivateBundle: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        guard let bundlePath = Bundle.main.path(forResource: UserDefaults.standard.string(forKey: "language"), ofType: "lproj"),
              let bundle = Bundle(path: bundlePath) else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}
*/
