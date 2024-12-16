//
//  ValidationEnums.swift
//  CryptoApp
//
//  Created by Rockz on 14/11/24.
//

import Foundation

public enum UsernameValidation {
    case emptyUsername
    case inValidUsername
    case validUsername
    var errorMessage: String? {
        switch self {
        case .emptyUsername:
            return "Please enter username"
        case .inValidUsername:
            return "Invalid username"
        case .validUsername:
            return nil
        }
    }
}


public enum PasswordValidation {
    case empty

    var errorMessage: String? {
        switch self {
        case .empty:
            return "Please enter password"
        default:
            return nil
        }
    }
}
