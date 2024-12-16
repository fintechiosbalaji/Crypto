//
//  ManageCardsView.swift
//  CryptoApp
//
//  Created by Rockz on 16/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import SwiftUI

struct ManageCardsView: View, ManageCardsViewProtocol {
    
    @ObservedObject
    private var presenter: ManageCardsPresenter
    @ObservedObject
    var walletBalanceViewModel: WalletBalanceViewModel

    init(presenter: ManageCardsPresenter, walletBalanceViewModel: WalletBalanceViewModel) {
        self.presenter = presenter
        self.walletBalanceViewModel = walletBalanceViewModel
    }
    
    @State private var showAddCardPopup = false
    @State private var showDeleteConfirmation = false
    @State private var cardToDeleteIndex: IndexSet?
    @AppStorage("theme") var isDarkMode: Bool = true
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    private var balance: String {
        let localizedBalanceText = LocalizationKeys.Portfolio.balance.localized(language)
        let balanceValue = walletBalanceViewModel.balance
        return String(format: "%@ %@", localizedBalanceText, balanceValue)
    }
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    Text(balance)
                        .foregroundColor(isDarkMode ? .white : .gray)
                    List {
                        ForEach(presenter.userCards) { card in
                            CardViewCell(card: card, presenter: presenter)
                                .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: confirmDelete)
                    }
                    .listStyle(.plain)
                    .background(Color.clear)
                    Button("Add Card".localizedKey, systemImage: "plus") {
                        showAddCardPopup = true
                    }
                    .applyCustomButtonStyle(bgColor: .orange)
                }
                .padding(.bottom, 44)
                .primaryBackground()
                .onAppear() {
                    presenter.loadCards()
                }
                .sheet(isPresented: $showAddCardPopup) {
                    CreditCardView(presenter: presenter, walletBalance: self.walletBalanceViewModel.balance)
                        .background(.green)
                }
                .alert(isPresented: $showDeleteConfirmation) {
                    Alert(
                        title: Text("Confirm Deletion"),
                        message: Text("Are you sure you want to delete this card?"),
                        primaryButton: .destructive(Text("Delete")) {
                            if let cardToDeleteIndex = cardToDeleteIndex {
                                presenter.deleteCard(at: cardToDeleteIndex)
                            }
                        },
                        secondaryButton: .cancel {
                            cardToDeleteIndex = nil
                        }
                    )
                }
               
            }
        }
        .modifier(DarkModeViewModifier())
    }
    /// Prompt user for delete confirmation
    private func confirmDelete(at offsets: IndexSet) {
        cardToDeleteIndex = offsets
        showDeleteConfirmation = true
    }
    /// Delete Card Function
    func deleteCard(at offsets: IndexSet) {
        presenter.deleteCard(at: offsets)
    }
    
    func showError(message: String) {
        print(message)
    }
}

struct CardViewCell: View {
    
    let card: Card
    var presenter: ManageCardsPresenter
    
    var body: some View {
        ZStack {
            // Card Background
            cardTypeGradient(for: CardType(rawValue: card.cardType) ?? .unowned)
                .frame(height: 150)
                .cornerRadius(10)
                .shadow(radius: 5)
            HStack(spacing: 16) {
                // Card Details
                cardDetails
                Spacer()
                // Card Type Logo
                cardTypeLogo
            }
            .padding(16)
        }
        .cornerRadius(10)
        .modifier(DarkModeViewModifier())
    }
    
    private var cardDetails: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(presenter.maskedCardNumber(card.cardNumber))
                .font(.headline)
                .foregroundColor(.white)
            Text("EXP: \(presenter.maskedExpirationDate(card.expirationDate))")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            Text("CVV: ***")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
    }
    
    private var cardTypeLogo: some View {
        Image(card.cardType)
            .resizable()
            .scaledToFit()
            .frame(width: 80, height: 50)
            .padding(.top, 8)
    }
    
    func cardTypeGradient(for type: CardType) -> LinearGradient {
        switch type {
        case .visa:
            return LinearGradient(
                gradient: Gradient(colors: [.blue, .purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .master:
            return LinearGradient(
                gradient: Gradient(colors: [.orange, .red]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        default:
            return LinearGradient(
                gradient: Gradient(colors: [.gray, .black]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

struct CreditCardView: View {
    // MARK: - States
    @State private var cardNumber: String = ""
    @State private var cvv: String = ""
    @State private var expirationDate: String = ""
    @State private var cardType: String = ""
    @State private var errorMessage: String = ""
    // MARK: - Environment
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    // MARK: - Dependencies
    @ObservedObject
    var presenter: ManageCardsPresenter
    let walletBalance: String
    
    private var balance: String {
        let localizedBalanceText = LocalizationKeys.Portfolio.balance.localized(language)
        return String(format: "%@ %@", localizedBalanceText, walletBalance)
    }
    // MARK: - Body
    var body: some View {
        ZStack {
            Color("primaryColor")
                .edgesIgnoringSafeArea(.all)
            ZStack {
                Color("alpha-primary-color")
                    .cornerRadius(20) // Ensure rounded corners for the background
                    .padding()
                VStack(spacing: 16) {
                    Text(balance)
                        .valueStyle()
                        .foregroundColor(.white)
                    CardTypePicker(presenter: self.presenter)
                    // Card Display
                    cardView
                        .padding()
                    // Error Message
                    if !errorMessage.isEmpty {
                        errorText
                    }
                    // Submit Button
                    submitButton
                }
                .padding()
            }
            .frame(maxHeight: 550)
            .cornerRadius(10)
            .modifier(DarkModeViewModifier())
        }.onDisappear {
            self.presenter.selectedCardType = nil
        }
    }
    
    private var submitButton: some View {
        Button(action: handleSubmit) {
            Text(LocalizationKeys.ManageCard.done.localizedKey)
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(isFormValid ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 4)
        }
        .disabled(!isFormValid)
        .padding(.horizontal, 16)
    }
    
    private var isFormValid: Bool {
        presenter.selectedCardType != nil
    }
    
    private var cardView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing))
                .frame(maxWidth: .infinity, maxHeight: 180)
                .shadow(radius: 10)
            
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Image("chip")
                        .resizable()
                        .frame(width: 40, height: 30)
                        .padding(.leading, 8)
                    Spacer()
                    Image(cardType)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 40)
                        .padding(.trailing, 8)
                }
                
                InputField(
                    placeholder: LocalizationKeys.ManageCard.cardNumber,
                    text: $cardNumber,
                    keyboardType: .numberPad
                )
                .onChange(of: cardNumber) { _,newValue in
                    cardType = presenter.determineCardType(number: newValue)
                }
                
                HStack(spacing: 16) {
                    InputField(
                        placeholder: "MM/YY",
                        text: $expirationDate,
                        keyboardType: .numberPad
                    )
                    .onChange(of: expirationDate) { _,newValue in
                        let formattedDate = presenter.validateAndFormatExpiryDate(newValue)
                        expirationDate = formattedDate.0
                        errorMessage = formattedDate.1
                    }
                    
                    InputField(
                        placeholder: "CVV",
                        text: $cvv,
                        keyboardType: .numberPad,
                        isSecure: true
                    )
                    .onChange(of: cvv) { _,newValue in
                        if newValue.count > 3 {
                            cvv = String(newValue.prefix(3))
                        }
                    }
                }
            }
            .padding(16)
        }
        .modifier(DarkModeViewModifier())
    }
    
    private var errorText: some View {
        Text(errorMessage)
            .font(.callout)
            .foregroundColor(.red)
            .padding(.top, 8)
            .multilineTextAlignment(.center)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
    }
    
    private func handleSubmit() {
        if let validationError = presenter.validateInputs(
            cardNumber: cardNumber,
            expirationDate: expirationDate,
            cvv: cvv,
            cardType: cardType,
            userSelectedCardType: presenter.selectedCardType?.description ?? ""
        ) {
            errorMessage = validationError
            return
        }
        
        let card = Card(
            cardNumber: cardNumber,
            cvv: cvv,
            cardType: cardType,
            expirationDate: expirationDate,
            logoImage: ""
        )
        presenter.addCard(card: card)
        presentationMode.wrappedValue.dismiss()
    }
}

struct InputField: View {
    var placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false
    
    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder.localizedKey, text: $text)
                    .keyboardType(keyboardType)
            }
        }
        .padding(.horizontal, 16)
        .background(Color.white.opacity(0.15))
        .cornerRadius(5)
        .foregroundColor(.white)
        .frame(height: 35)
    }
}

struct CardTypePicker: View {
    @ObservedObject var presenter: ManageCardsPresenter
    init(presenter: ManageCardsPresenter) {
        self.presenter = presenter
    }
    var body: some View {
        VStack {
            Text("Select Card Type")
                .font(.body)
            Picker("Card Type", selection:  $presenter.selectedCardType) {
                ForEach(presenter.cardTypeList, id: \.self) { cardType in
                    Text(cardType.name)
                        .tag(cardType as CardTypeEntity?)
                }
            }
            .pickerStyle(SegmentedPickerStyle()) // Change style as needed
        }
        .padding()
    }
}
