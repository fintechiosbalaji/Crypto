//
//  ConstantText.swift
//  CryptoApp
//
//  Created by Rockz on 02/12/24.
//

import SwiftUI

struct LocalizationKeys {
    
    struct Welcome {
        static let title = "Welcome to the Future of Finance"
        static let description = "Your gateway to a world of cryptocurrencies. Buy, sell, and trade with ease."
        static let getStarted = "Get Started"
    }
    
    struct Login {
        static let loginSuccess = "Login successful!"
        static let email = "Email"
        static let password = "Password"
        static let forgot_password = "Forgot Password?"
        static let submit = "Submit"
        static let enterEmail = "Please enter email"
        static let enterValidEmail = "Please enter valid email"
        static let passwordEmpty = "Password is empty"
        static let passwordTooShort = "Password must be at least 8 characters long"
    }
    
    struct Portfolio {
        static let balance = "Wallet Balance:"
        static let buy = "Buy"
        static let sell = "Sell"
        static let investment = "Investment"
        static let idReturns = "ID returns"
        static let totalReturn = "Total Return"
        static let downloading = "Downloading…"
        static let fetchingData = "Fetching data, please wait..."
        static let currency = "Currency"
        static let price = "Price"
        static let date = "Date"
    }
    
    struct TabMenu {
        static let portfolio = "Portfolio"
        static let markets = "Markets"
        static let cards = "Cards"
        static let currencyExchange = "Convert"
        static let profile = "Profile"
    }
    
    struct Profile {
        static let profileSettings = "Profile Settings"
        static let viewProfile = "View Profile"
        static let editProfile = "Edit Profile"
        static let changePassword = "Change Password"
        static let notifications = "Notifications"
        static let accountSettings = "Account Settings"
        static let linkedAccounts = "Linked Accounts"
        static let deleteAccount = "Delete Account"
    }
    
    struct Settings {
        // Titles for Settings sections
        static let support = "Support"
        static let generalSettings = "General Settings"
        static let logout = "Logout"
        
        // Text for Settings items
        static let credits = "Credits"
        static let contactSupport = "Contact Support"
        static let termsAndConditions = "Terms and Conditions"
        static let privacyPolicy = "Privacy Policy"
        static let helpCenter = "Help Center"
        static let security = "Security"
        static let logoutText = "Logout"
    }
    
    struct ManageCard {
        static let cardNumber =  "Card Number"
        static let done =  "Done"
    }
}

