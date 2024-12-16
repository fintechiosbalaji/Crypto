//
//  ManageCardsContracts.swift
//  CryptoApp
//
//  Created by Rockz on 16/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import SwiftUI
import CoreData

// MARK: - View Protocol

protocol ManageCardsViewProtocol {
    func showError(message: String)
}

// MARK: - Presenter Protocol

protocol ManageCardsPresenterProtocol: AnyObject {
    func validateAndFormatExpiryDate(_ value: String) -> (String, String)
    func determineCardType(number: String) -> String
    func loadCards()
    func addCard(card: Card)
    func deleteCard(at offsets: IndexSet)
    func maskedCardNumber(_ number: String?) -> String
    func maskedExpirationDate(_ dateString: String?) -> String
    func validateInputs(cardNumber: String, expirationDate: String, cvv: String, cardType: String,userSelectedCardType: String)-> String?
}

// MARK: - Interactor Protocol
protocol ManageCardsInteractorProtocol: AnyObject {
    func maskedCardNumber(_ number: String?) -> String
    func maskedExpirationDate(_ dateString: String?) -> String
    func formatExpiryDate(_ value: String) -> (String, String)
    func validateCardType(number: String) -> String 
    func fetchCards() -> [UserCard]
    func saveCard(card: UserCard)
    func removeCard(at offsets: IndexSet)
    var context: NSManagedObjectContext { get }
    func validateInputs(cardNumber: String, expirationDate: String, cvv: String, cardType: String, userSelectedCardType: String)-> String?
}

// MARK: - Router Protocol

protocol ManageCardsRouterProtocol {
    static func composeView(context: NSManagedObjectContext) -> AnyView
}
