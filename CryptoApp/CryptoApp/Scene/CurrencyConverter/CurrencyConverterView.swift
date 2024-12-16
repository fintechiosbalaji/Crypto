//
//  CurrencyConverterView.swift
//  CryptoApp
//
//  Created by Rockz on 29/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import SwiftUI
import AVKit

struct CurrencyConverterView: View, CurrencyConverterViewProtocol {
    
    @ObservedObject
    private var presenter: CurrencyConverterPresenter
    
    init(presenter: CurrencyConverterPresenter) {
        self.presenter = presenter
    }
    
    @AppStorage("theme")
    var isDarkMode: Bool = true
    @AppStorage("language")
    private var selectedLanguage = LocalizationService.shared.language
    @State private var isDropdownOpen = false
   
    var body: some View {
        ZStack {
            Color("primaryColor")
                .edgesIgnoringSafeArea(.all)
            ZStack {
                Color("alpha-primary-color")
                    .cornerRadius(20) // Ensure rounded corners for the background
                    .padding()
                
                VStack(alignment: .center) {
                    SearchableDropdownMenu(selectedOption: $presenter.selectedSourceCurrency, options: presenter.currencyConverterList)
                       
                    TextField("Enter Currency Value".localized(selectedLanguage), text: $presenter.currencyValue)
                        .padding(20)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    SearchableDropdownMenu(selectedOption: $presenter.selectedTargetCurrency, options: presenter.currencyConverterList)
                    
                    HStack(alignment: .center) {
                        Text(presenter.selectedSourceCurrency?.symbol ?? "")
                            .foregroundColor(isDarkMode ? .white : .black)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.title)
                        Spacer()
                        Button(action: {
                            presenter.swapCurrencies()
                        }) {
                            Image(systemName: "arrow.right.arrow.left")
                                .frame(width: 50, height: 50)
                                .foregroundColor(isDarkMode ? .white : .black)
                                .background(Color.orange)
                                .clipShape(Circle())
                        }
                        Spacer()
                        Text(presenter.selectedTargetCurrency?.symbol ?? "")
                            .foregroundColor(isDarkMode ? .white : .black)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.title)
                    }
                    TextField("Converted Currency Value".localized(selectedLanguage), text: $presenter.outputCurrencyValue)
                        .padding(20)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()
            }
            .frame(height: 450)
            .cornerRadius(10)
        }
        .modifier(DarkModeViewModifier())
        .onAppear {
            presenter.fetchCurrency()
        }
    }
}

struct CurrencyConverterView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyConverterRouter.composeView()
    }
}
