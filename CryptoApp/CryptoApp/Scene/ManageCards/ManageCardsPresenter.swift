//
//  ManageCardsPresenter.swift
//  CryptoApp
//
//  Created by Rockz on 16/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import Combine
import CoreData

final class ManageCardsPresenter: ManageCardsPresenterProtocol, ObservableObject {
    
    @Published var userCards: [Card] = []
    @Published var cardTypeList: [CardTypeEntity] = []
    @Published var selectedCardType: CardTypeEntity?
    
    private let interactor: ManageCardsInteractorProtocol
    private let router: ManageCardsRouterProtocol
    
    init(
        interactor: ManageCardsInteractorProtocol,
        router: ManageCardsRouterProtocol
    ) {
        self.interactor = interactor
        self.router = router
        self.cardTypeList = mockCardType
    }
    
    func loadCards() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            let encryptedCards = self.interactor.fetchCards()
            let decryptedCards = encryptedCards.compactMap { self.decryptCardDetails($0) }
            DispatchQueue.main.async {
                self.userCards = decryptedCards
                
            }
        }
    }
    
    private func decryptCardDetails(_ cardDetail: UserCard) -> Card? {
        guard let cardNumber = decryptData(cardDetail.cardNumber ?? ""),
              let expiryDate = decryptData(cardDetail.expiryDate ?? ""),
              let cvv = decryptData(cardDetail.cvv ?? ""),
              let cardType = decryptData(cardDetail.type ?? "")
        else {
            return nil
        }
        print(cardNumber, expiryDate, cvv, cardType)
        return Card(cardNumber: cardNumber,
                    cvv: cvv,
                    cardType: cardType,
                    expirationDate: expiryDate,
                    logoImage: "")
    }
    
    func addCard(card: Card) {
        if let encryptedCardNumber = encryptData(card.cardNumber),
           let encryptedExpiryDate = encryptData(card.expirationDate),
           let encryptedCVV = encryptData(card.cvv),
           let encryptedCardType = encryptData(card.cardType) {
            let newCard = UserCard(context: interactor.context)
            newCard.cardNumber = encryptedCardNumber
            newCard.expiryDate = encryptedExpiryDate
            newCard.cvv = encryptedCVV
            newCard.type = encryptedCardType
            
            interactor.saveCard(card: newCard)
            loadCards()
        }
    }
    
    func deleteCard(at offsets: IndexSet) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            self.interactor.removeCard(at: offsets)
            DispatchQueue.main.async {
                self.loadCards()
            }
        }
    }
    
    func validateAndFormatExpiryDate(_ value: String) -> (String, String) {
        return interactor.formatExpiryDate(value)
    }
    
    func determineCardType(number: String) -> String {
        return interactor.validateCardType(number: number)
    }
    
    func maskedCardNumber(_ number: String?)-> String {
        return self.interactor.maskedCardNumber(number)
    }
    
    func maskedExpirationDate(_ dateString: String?)-> String {
        return self.interactor.maskedExpirationDate(dateString)
    }
    
    func validateInputs(cardNumber: String, expirationDate: String, cvv: String, cardType: String, userSelectedCardType: String) -> String? {
        return interactor.validateInputs(cardNumber: cardNumber, expirationDate: expirationDate, cvv: cvv, cardType: cardType, userSelectedCardType: userSelectedCardType)
        
    }
}
