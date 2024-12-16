//
//  Portfolio.swift
//  CryptoApp
//
//  Created by Rockz on 20/11/24.
//
/*
import SwiftUI
import Charts

struct PortfolioView_test: View {
    var body: some View {
        ZStack {
            Color("primaryColor") .edgesIgnoringSafeArea(.all)
            
            ScrollView() {
                Text("Total Value: $50,000")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                
               
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        CryptoCoinView(name: "Bitcoin", symbol: "BTC")
                        CryptoCoinView(name: "Ethereum", symbol: "ETH")
                        CryptoCoinView(name: "Litecoin", symbol: "LTC")
                        CryptoCoinView(name: "Bitcoin", symbol: "BTC")
                        CryptoCoinView(name: "Ethereum", symbol: "ETH")
                        CryptoCoinView(name: "Litecoin", symbol: "LTC")
                    }
                    .padding()
                }
           
                HStack {
                    Button(action: { /* Buy More action */ }) {
                        Text("Buy")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Button(action: { /* Sell action */ }) {
                        Text("Sell")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Button(action: { /* Details action */ }) {
                        Text("Details")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            
                PortfolioGraphView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                   
            }
            
        }
    }
}


//struct CryptoCoinView: View {
//    let name: String
//    let symbol: String
//    
//    var body: some View {
//        VStack {
//            Circle()
//                .fill(Color.white.opacity(0.3))
//                .frame(width: 80, height: 80)
//                .overlay(
//                    Text(symbol)
//                        .font(.largeTitle)
//                        .foregroundColor(.white)
//                )
//            Text(name)
//                .font(.headline)
//                .foregroundColor(.white)
//        }
//        .padding()
//    }
//}

struct CryptoLineChartView_Test_2: View {
    let data: [CryptoTypeTest]
    
    var body: some View {
        ZStack {
            Chart(data) { dataSeries in
                ForEach(dataSeries.data) { dataPoint in
                    LineMark(
                        x: .value("Date", dataPoint.date),
                        y: .value("Price", dataPoint.value)
                    )
                }
                .foregroundStyle(by: .value("Currency", dataSeries.type))
                .symbol(by: .value("Currency", dataSeries.type))
            }
            .chartXScale(domain: .automatic)
            .chartYScale(domain: 0...90000)  // Adjust max price range as needed
            .aspectRatio(1, contentMode: .fit)
            .padding()
        }
    }
}

class PortfolioViewModel: ObservableObject {
    @Published var portfolio: [CryptoTypeTest] = []
    
    func fetchPortfolio() {
        // Mock API response
        let jsonResponse = """
        {
            "portfolio": [
                {"name": "Bitcoin", "symbol": "BTC", "values": [30000, 31000, 29500, 32000, 31000]},
                {"name": "Ethereum", "symbol": "ETH", "values": [1000, 1050, 990, 1020, 1010]},
                {"name": "Litecoin", "symbol": "LTC", "values": [200, 210, 190, 220, 215]}
            ]
        }
        """
        let data = Data(jsonResponse.utf8)
        
        do {
            let portfolioData = try JSONDecoder().decode(PortfolioData.self, from: data)
            self.portfolio = portfolioData.portfolio.map { cryptoData in
                CryptoTypeTest(type: cryptoData.symbol,
                               data: zip(cryptoData.dates(),
                                                                  cryptoData.values).map { date, value in
                    GraphData(date: self.formatDate(date), value: value)
                })
            }
        } catch {
            print("Failed to decode JSON: \(error)")
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: date)
    }
}

struct PortfolioData: Codable {
    let portfolio: [CryptoTestData]
}

struct CryptoTestData: Codable {
    let name: String
    let symbol: String
    let values: [Double]
    
    // Generate dates for simplicity
    func dates() -> [Date] {
        return (0..<values.count).map { Date(timeIntervalSinceNow: -Double($0) * 86400) }
    }
}

struct PortfolioGraphView: View {
    @ObservedObject var viewModel = PortfolioViewModel()
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("My Portfolio")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                
                VStack {
                    if !viewModel.portfolio.isEmpty {
                        CryptoLineChartView_Test_2(data: viewModel.portfolio)
                            .gradientBackground(colors: [Color.white])
                           
                    } else {
                        Text("No data available")
                            .foregroundColor(.white)
                    }
                }
                
                Spacer()
            }
            .padding()
            .onAppear {
                viewModel.fetchPortfolio()
            }
        }
       
    }
}

struct PortfolioGraphView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioGraphView()
    }
}
*/
