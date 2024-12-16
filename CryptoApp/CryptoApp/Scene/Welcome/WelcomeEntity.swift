//
//  WelcomeEntity.swift
//  CryptoApp
//
//  Created by Rockz on 14/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import Foundation
import SwiftUI

struct WelcomeEntity {
    let welcomeText: String
    let descriptionText: String
}

let mockWelcome: WelcomeEntity = WelcomeEntity(
    welcomeText: LocalizationKeys.Welcome.title,
    descriptionText: LocalizationKeys.Welcome.description
)

