//
//  CryptoListView.swift
//  CryptoApp
//
//  Created by Rockz on 25/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import SwiftUI
import Charts

enum FilterOption: String, CaseIterable {
    case none = "None"
    case lowToHigh = "Price: Low to High"
    case highToLow = "Price: High to Low"
    case trends = "Trending"
}

struct CryptoListView: View, CryptoListViewProtocol {
    
    @ObservedObject
    private var presenter: CryptoListPresenter
    private let dependencies: CryptoListViewDependenciesProtocol
    @EnvironmentObject var navigationState: NavigationState
    @State private var searchText: String = ""
    @State var selectedFilter: FilterOption = .none
    @AppStorage("theme") var isDarkMode: Bool = true
    
    init(dependencies: CryptoListViewDependenciesProtocol, presenter: CryptoListPresenter) {
        self.dependencies = dependencies
        self.presenter = presenter
    }
    
    var body: some View {
        VStack {
            // Top Filter View
            SearchView(selectedFilter: $selectedFilter) // Pass the binding
            ZStack {
                Color("primaryColor")
                    .edgesIgnoringSafeArea(.all)
                List {
                    ForEach(filteredAndSortedCryptoList()) { crypto in
                        CryptoCell(crypto: crypto)
                            .listRowBackground(Color.clear)
                    }
                }
                .searchable(text: $searchText, prompt: "Search Crypto name")
                .applyListTopSpacingModifier()
                .navigationTitle("Crypto")
                .foregroundColor(.white)
            }
            .padding(.bottom, 44)
            .primaryBackground()
            .toolbarBackground(.hidden, for: .navigationBar)
            .onAppear {
                presenter.loadCryptoList()
            }
        } 
        .primaryBackground()
        .modifier(DarkModeViewModifier())
    }
    // Filter and Sort List Based on Selected Option
    private func filteredAndSortedCryptoList() -> [TestCrypto] {
        var cryptoList = searchText.isEmpty ? presenter.cryptoList : presenter.cryptoList.filter { crypto in
            crypto.name.lowercased().contains(searchText.lowercased()) ||
            crypto.symbol.lowercased().contains(searchText.lowercased())
        }
        
        switch selectedFilter {
        case .lowToHigh:
            cryptoList.sort { $0.currentPriceValue < $1.currentPriceValue }
        case .highToLow:
            cryptoList.sort { $0.currentPriceValue > $1.currentPriceValue }
        case .trends:
            cryptoList.sort { $0.priceTrends.last?.value ?? 0 > $1.priceTrends.last?.value ?? 0 }
        case .none:
            break
        }
        return cryptoList
    }
}

struct SearchView: View {
    
    @Binding var selectedFilter: FilterOption // Binding to allow the parent view to modify the state

    var body: some View {
        HStack {
            Text("Filter:")
                .foregroundColor(.white)
                .padding()
            Spacer()
            Picker("Filter", selection: $selectedFilter) {
                ForEach(FilterOption.allCases, id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(MenuPickerStyle()) // Using the context menu style for picker
            .foregroundColor(.white)
            .background(Color.gray.opacity(0.2)) // Add background color
            .cornerRadius(8)
            .frame(height: 10)
            .padding()
        }
        .primaryBackground()
    }
}

struct CryptoCell: View {
    let crypto: TestCrypto
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            HStack() {
                VStack(alignment: .leading) {
                    Text(crypto.name)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    Text(crypto.symbol)
                        .font(.subheadline)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    Text(crypto.currentPrice)
                        .font(.body)
                        .foregroundColor(.green)
                }
                .frame(width: 100, height: 60)
                Spacer()
                CustomChartViewTest(
                    title: "\(crypto.name) (\(crypto.symbol))",
                    data: chartData(for: crypto)
                )
            }
            .padding()
        }
        .gradientBackground(colors: [colorScheme == .dark ? (crypto.purchased ? .orange.opacity(0.2) : Color("alpha-primary-color")): (crypto.purchased ? .orange.opacity(0.2) : .secondary)])
        .frame(height: 100)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
    
    func chartData(for crypto: TestCrypto) -> [TestChartData] {
        let baseDate = Calendar.current.startOfDay(for: Date())
        let trendColor = marketTrendColor(for: crypto)
        
        return crypto.priceTrends.enumerated().compactMap { index, trend in
            guard let trendDate = Calendar.current.date(byAdding: .day, value: index, to: baseDate) else { return nil }
            return TestChartData(
                date: trendDate,
                value: trend.value,
                label: crypto.symbol,
                color: trendColor
            )
        }
    }
    
    func marketTrendColor(for crypto: TestCrypto) -> Color {
        guard let first = crypto.priceTrends.first?.date, let last = crypto.priceTrends.last?.date else {
            return .gray // Default color if no trends
        }
        return last > first ? .blue : .pink // Blue for upward, Red for downward
    }
}

