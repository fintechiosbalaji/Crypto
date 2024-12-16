//
//  CurrencyConverterPresenter.swift
//  CryptoApp
//
//  Created by Rockz on 29/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import Combine
import Foundation

final class CurrencyConverterPresenter: CurrencyConverterPresenterProtocol, ObservableObject {
    
    @Published var currencyConverterList: [CurrencyConverterEntity] = []
    @Published var currencyValue: String = ""
    @Published var outputCurrencyValue: String = ""
    @Published var selectedSourceCurrency: CurrencyConverterEntity?{ didSet { clearConversionRate() } }
    @Published var selectedTargetCurrency: CurrencyConverterEntity?{ didSet { clearConversionRate() } }
    @Published var errorMessage: String = ""
    private var conversionRate: Double?
    private var cancellables: Set<AnyCancellable> = []
    private let interactor: CurrencyConverterInteractorProtocol
    private let router: CurrencyConverterRouterProtocol
    
    init(
        interactor: CurrencyConverterInteractorProtocol,
        router: CurrencyConverterRouterProtocol
    ) {
        self.interactor = interactor
        self.router = router
        self.setupValidationPipeline()
        self.setupCurrencyConversionPipeline()
    }
    
    private func clearConversionRate() { conversionRate = nil }
    
    private func setupValidationPipeline() {
        $currencyValue
            .debounce(for: 0.1, scheduler: RunLoop.main) // Process changes after 100ms
            .removeDuplicates()
            .map { value in
                self.filterInput(value, maxLength: 8)
            }
            .assign(to: \.currencyValue, on: self) // Update the property
            .store(in: &cancellables)
        
        $outputCurrencyValue
            .debounce(for: 0.1, scheduler: RunLoop.main) // Process changes after 100ms
            .removeDuplicates()
            .map { value in
                self.filterInput(value, maxLength: 8)
            }
            .assign(to: \.outputCurrencyValue, on: self) // Update the property
            .store(in: &cancellables)
    }
    
    private func filterInput(_ input: String, maxLength: Int) -> String {
        var filtered = input
            .filter { $0.isNumber || $0 == "." }
        let dotCount = filtered.filter { $0 == "." }.count
        if dotCount > 1 {
            filtered = String(filtered.dropLast())
        }
        return String(filtered.prefix(maxLength))
    }
    
    // Combine pipeline to update converted currency value
    private func setupCurrencyConversionPipeline() {
        Publishers.CombineLatest3($currencyValue, $selectedSourceCurrency, $selectedTargetCurrency)
            .debounce(for: .milliseconds(100), scheduler: RunLoop.main)
            .sink { [weak self] currencyValue, sourceCurrency, targetCurrency in
                self?.convertCurrency(currencyValue: currencyValue, sourceCurrency: sourceCurrency, targetCurrency: targetCurrency)
            }
            .store(in: &cancellables)
    }
    
    // Perform currency conversion based on selected currencies
    private func convertCurrency(currencyValue: String, sourceCurrency: CurrencyConverterEntity?, targetCurrency: CurrencyConverterEntity?) {
        guard let value = Double(currencyValue),
              let source = sourceCurrency,
              let target = targetCurrency else {
            self.outputCurrencyValue = ""
            return
        }
        if let rate = conversionRate, source.name == selectedSourceCurrency?.name, target.name == selectedTargetCurrency?.name { // Use cached conversion rate
            let convertedValue = value * rate
            self.outputCurrencyValue = String(format: "%.2f", convertedValue)
        } else {
            interactor.fetchConversionRate(from: source.name, to: target.name)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] result in
                    switch result {
                    case .success(let currencyData):
                        currencyData.data.forEach { _ , data in
                            self?.conversionRate = data
                            let convertedValue = value * data
                            self?.outputCurrencyValue = String(format: "%.2f", convertedValue)
                        }
                    case .failure(_):
                        self?.errorMessage = "Unable to load currency list. Please try again later."
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    // Swap the source and target currencies
    func swapCurrencies() {
        let temp = selectedSourceCurrency
        selectedSourceCurrency = selectedTargetCurrency
        selectedTargetCurrency = temp
    }
    
    func fetchCurrency() {
        interactor.fetchCurrencyList()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let currencyList):
                    self?.currencyConverterList = currencyList.data.map { keyValue in
                        let currency = keyValue.value
                        return CurrencyConverterEntity(symbol: currency.symbol, name: currency.code)
                    }
                case .failure(_):
                    self?.errorMessage = "Unable to load currency list. Please try again later."
                }
            }
            .store(in: &cancellables)
    }
}
