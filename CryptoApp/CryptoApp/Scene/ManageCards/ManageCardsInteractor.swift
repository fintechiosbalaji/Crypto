//
//  ManageCardsInteractor.swift
//  CryptoApp
//
//  Created by Rockz on 16/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//
import Combine
import CoreData

final class ManageCardsInteractor: ManageCardsInteractorProtocol {
    
    private let dependencies: ManageCardsInteractorDependenciesProtocol
    
    init(dependencies: ManageCardsInteractorDependenciesProtocol) {
        self.dependencies = dependencies
    }
    
    var context: NSManagedObjectContext {
        return dependencies.context
    }
    
    func fetchCards() -> [UserCard] {
        // Fetch cards from Core Data
        let request: NSFetchRequest<UserCard> = UserCard.fetchRequest()
        do {
            return try dependencies.context.fetch(request)
        } catch {
            print("Failed to fetch cards: \(error)")
            return []
        }
    }
    
    func saveCard(card: UserCard) {
        // Save card to Core Data
        context.insert(card)
        do {
            try context.save()
        } catch {
            print("Failed to save card: \(error)")
        }
    }
    
    func removeCard(at offsets: IndexSet) {
        for index in offsets {
            let card = fetchCards()[index]
            context.delete(card)
        }
        do {
            try context.save()
        } catch {
            print("Failed to delete card: \(error)")
        }
    }
    
    func validateCardType(number: String) -> String {
        if number.count >= 4 {
            let firstFourDigits = number.prefix(4)
            
            if firstFourDigits.hasPrefix("4") {
                return "visa"
            } else if firstFourDigits.hasPrefix("5") && ["1", "2", "3", "4", "5"].contains(firstFourDigits.suffix(1)) {
                return "master"
            } else if ["34", "37"].contains(String(firstFourDigits.prefix(2))) {
                return "amex"
            } else {
                return "Unknown"
            }
        } else {
            return "Unknown"
        }
    }
    
    func formatExpiryDate(_ value: String) -> (String, String) {
        var errorMessage = ""
        let digits = value.filter { "0123456789".contains($0) }
        
        if digits.count <= 2 {
            if let monthInt = Int(digits), monthInt > 0 && monthInt <= 12 {
                return (digits, errorMessage)
            } else {
                errorMessage = "Invalid month. Please enter a value between 01 and 12."
                return (digits, errorMessage)
            }
        } else if digits.count > 2 {
            let month = digits.prefix(2)
            let year = digits.suffix(from: digits.index(digits.startIndex, offsetBy: 2))
            
            if let monthInt = Int(month), monthInt > 0 && monthInt <= 12 {
                return ("\(month)/\(year.prefix(2))", errorMessage)
            } else {
                errorMessage = "Invalid month. Please enter a value between 01 and 12."
                return ("\(month)/\(year.prefix(2))", errorMessage)
            }
        }
        return (value, errorMessage)
    }
    
    func maskedCardNumber(_ number: String?) -> String {
        guard let number = number else { return "N/A" }
        let maskedLength = number.count - 4
        let maskedString = String(repeating: "*", count: maskedLength)
        return "\(maskedString)\(String(number.suffix(4)))"
    }
    
    func maskedExpirationDate(_ dateString: String?) -> String {
        guard let dateString = dateString else { return "N/A" }
        let components = dateString.split(separator: "/")
        guard components.count == 2 else { return "N/A" }
        return "\(components[0])/**" // Mask month, display year
    }
    
    func validateInputs(cardNumber: String, expirationDate: String, cvv: String, cardType: String, userSelectedCardType: String) -> String? {
        // Check if any field is empty
        if cardNumber.isEmpty || expirationDate.isEmpty || cvv.isEmpty || cardType.isEmpty {
            return "All fields are required. Please fill in all details."
        }
        
        // Validate card number (minimum 16 digits, numeric only)
        if cardNumber.count < 16 || cardNumber.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil {
            return "Card number must be at least 16 digits and contain only numbers."
        }
        
        // Validate expiration date (valid month)
        if let month = Int(expirationDate.prefix(2)), month < 1 || month > 12 {
            return "Invalid month in expiration date. Please enter a value between 01 and 12."
        }
        
        if cvv.count < 3 {
            return "Invalid cvv"
        }
        
        if userSelectedCardType.lowercased() != cardType.lowercased() {
            return "Invalid selected card type or entered card number."
        }
        
        
        // All validations passed
        return nil
    }
}
