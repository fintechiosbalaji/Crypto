//
//  String.swift
//  CryptoApp
//
//  Created by Rockz on 14/11/24.
//

import Foundation
import SwiftUI

extension String {
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}

extension Double {
    var formatCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "₹"
        return formatter.string(from: NSNumber(value: self)) ?? "₹0.00"
    }
}


extension String {
//    var localizedKey: LocalizedStringKey {
//        return LocalizedStringKey(self)
//    }
    
    var localizedKey: LocalizedStringKey {
        // Get the current language from the LocalizationService
        let currentLanguage = LocalizationService.shared.language
        // Use the custom localized function to get the localized string for the selected language
        let localizedString = self.localized(currentLanguage)
        // Return a LocalizedStringKey with the localized value
        return LocalizedStringKey(localizedString)
    }
}

extension String {
    /// Localizes a string using given language from Language enum.
    /// - parameter language: The language that will be used to localized string.
    /// - Returns: localized string.
    func localized(_ language: Language) -> String {
        // Ensure the correct path for the language's .lproj folder
        guard let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj") else {
            return localized(bundle: .main)
        }
        let bundle = Bundle(path: path) ?? .main
        return localized(bundle: bundle)
    }
    
    /// Localizes a string using given language from Language enum.
    ///  - Parameters:
    ///  - language: The language that will be used to localized string.
    ///  - args:  dynamic arguments provided for the localized string.
    /// - Returns: localized string.
    func localized(_ language: Language, args arguments: CVarArg...) -> String {
        let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj")
        let bundle: Bundle
        if let path = path {
            bundle = Bundle(path: path) ?? .main
        } else {
            bundle = .main
        }
        return String(format: localized(bundle: bundle), arguments: arguments)
    }

    /// Localizes a string using self as key.
    /// - Parameters:
    ///   - bundle: the bundle where the Localizable.strings file lies.
    /// - Returns: localized string.
    private func localized(bundle: Bundle) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
}


