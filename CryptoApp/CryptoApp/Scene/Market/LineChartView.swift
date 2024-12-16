//
//  LineChartView.swift
//  CryptoApp
//
//  Created by Rockz on 18/11/24.
//

import SwiftUI
import Charts
import Foundation
import Combine



struct CryptoLineChartView: View {
    
    let data: [CryptoType]
    
    var body: some View {
        Chart(data, id: \.type) { dataSeries in
            ForEach(dataSeries.data) { data in
                LineMark(
                    x: .value("Year", data.date),
                    y: .value("Price", data.price)
                )
            }
            .foregroundStyle(by: .value("Currency", dataSeries.type))
            .symbol(by: .value("Currency", dataSeries.type))
        }
        .chartXScale(domain: 2018...2023) // Define a suitable range for years
        .chartYScale(domain: 0...70000)  // Adjust based on max price
        // .chartTitle("Cryptocurrency Price Trends")
        .aspectRatio(1, contentMode: .fit)
        .padding()
    }
}






import SwiftUI


struct UserPortfolioResponse: Decodable {
    let userPortfolio: UserPortfolio
    let coinDetails: [String: CoinDetails]
}

struct UserPortfolio: Decodable {
    let totalInvested: Double
    let totalProfitOrLoss: Double
    let cryptoSummary: [CryptoSummary]
}

struct CryptoSummary: Decodable {
    let coinId: String
    let coinName: String
    let investedAmount: Double
    let currentValue: Double
    let profitOrLoss: Double
    let graphData: GraphDataContainer
    
    var priceChange: Double {
           let change = currentValue - investedAmount
           let percentageChange = change / investedAmount
           return percentageChange
       }
}

struct GraphDataContainer: Decodable {
    let last1Month: [GraphData]
}

struct GraphData: Identifiable, Decodable {
    let id = UUID()
    let date: String
    let value: Double
}

struct CoinDetails: Decodable {
    let coinId: String
    let coinName: String
    let currentPrice: Double
    let priceGraph: PriceGraph
}

struct PriceGraph: Decodable {
    let today: [PriceData]
    let last5Days: [PriceData]
    let last7Days: [PriceData]
    let last1Month: [PriceData]
    let last1Year: [PriceData]
}

struct PriceData: Identifiable, Decodable {
    let id = UUID()
    let date: String?
    let time: String?
    let price: Double
}


// Define the chart data model
struct CryptoTypeTest: Identifiable {
    let id = UUID()
    let type: String
    let data: [GraphData]
}

struct TestView: View {
    @State private var portfolio: UserPortfolio?
    @State private var chartData: [CryptoTypeTest] = []

    var body: some View {
        VStack {
            if !chartData.isEmpty {
                CryptoLineChartView_Test(data: chartData)
            } else {
                Text("Loading data...")
            }
        }
        .onAppear {
            loadData()
        }
    }
    

    func loadData() {
        let json = """
        {
            "userPortfolio": {
                "totalInvested": 5000.00,
                "totalProfitOrLoss": 350.00,
                "cryptoSummary": [
                    {
                        "coinId": "btc",
                        "coinName": "Bitcoin",
                        "investedAmount": 3000.00,
                        "currentValue": 3350.00,
                        "profitOrLoss": 350.00,
                        "graphData": {
                            "last1Month": [
                                {
                                    "date": "2024-10-20",
                                    "value": 30000
                                },
                                {
                                    "date": "2024-10-25",
                                    "value": 31000
                                },
                                {
                                    "date": "2024-11-01",
                                    "value": 32000
                                },
                                {
                                    "date": "2024-11-10",
                                    "value": 33500
                                }
                            ]
                        }
                    },
                    {
                        "coinId": "eth",
                        "coinName": "Ethereum",
                        "investedAmount": 2000.00,
                        "currentValue": 2000.00,
                        "profitOrLoss": 0.00,
                        "graphData": {
                            "last1Month": [
                                {
                                    "date": "2024-10-20",
                                    "value": 1800
                                },
                                {
                                    "date": "2024-10-25",
                                    "value": 1900
                                },
                                {
                                    "date": "2024-11-01",
                                    "value": 2000
                                },
                                {
                                    "date": "2024-11-10",
                                    "value": 2000
                                }
                            ]
                        }
                    }
                ]
            },
            "coinDetails": {
                "btc": {
                    "coinId": "btc",
                    "coinName": "Bitcoin",
                    "currentPrice": 33500.00,
                    "priceGraph": {
                        "today": [
                            {
                                "time": "09:00",
                                "price": 33000
                            },
                            {
                                "time": "12:00",
                                "price": 33200
                            },
                            {
                                "time": "15:00",
                                "price": 33400
                            },
                            {
                                "time": "18:00",
                                "price": 33500
                            }
                        ],
                        "last5Days": [
                            {
                                "date": "2024-11-15",
                                "price": 32500
                            },
                            {
                                "date": "2024-11-16",
                                "price": 32800
                            },
                            {
                                "date": "2024-11-17",
                                "price": 33000
                            },
                            {
                                "date": "2024-11-18",
                                "price": 33300
                            },
                            {
                                "date": "2024-11-19",
                                "price": 33500
                            }
                        ],
                        "last7Days": [
                            {
                                "date": "2024-11-13",
                                "price": 32000
                            },
                            {
                                "date": "2024-11-14",
                                "price": 32200
                            },
                            {
                                "date": "2024-11-15",
                                "price": 32500
                            },
                            {
                                "date": "2024-11-16",
                                "price": 32800
                            },
                            {
                                "date": "2024-11-17",
                                "price": 33000
                            },
                            {
                                "date": "2024-11-18",
                                "price": 33300
                            },
                            {
                                "date": "2024-11-19",
                                "price": 33500
                            }
                        ],
                        "last1Month": [
                            {
                                "date": "2024-10-20",
                                "price": 30000
                            },
                            {
                                "date": "2024-10-25",
                                "price": 31000
                            },
                            {
                                "date": "2024-11-01",
                                "price": 32000
                            },
                            {
                                "date": "2024-11-10",
                                "price": 33500
                            }
                        ],
                        "last1Year": [
                            {
                                "date": "2024-01-01",
                                "price": 20000
                            },
                            {
                                "date": "2024-03-01",
                                "price": 25000
                            },
                            {
                                "date": "2024-06-01",
                                "price": 28000
                            },
                            {
                                "date": "2024-09-01",
                                "price": 30000
                            },
                            {
                                "date": "2024-11-01",
                                "price": 33500
                            }
                        ]
                    }
                },
                "eth": {
                    "coinId": "eth",
                    "coinName": "Ethereum",
                    "currentPrice": 2000.00,
                    "priceGraph": {
                        "today": [
                            {
                                "time": "09:00",
                                "price": 1950
                            },
                            {
                                "time": "12:00",
                                "price": 1975
                            },
                            {
                                "time": "15:00",
                                "price": 1990
                            },
                            {
                                "time": "18:00",
                                "price": 2000
                            }
                        ],
                        "last5Days": [
                            {
                                "date": "2024-11-15",
                                "price": 1900
                            },
                            {
                                "date": "2024-11-16",
                                "price": 1920
                            },
                            {
                                "date": "2024-11-17",
                                "price": 1950
                            },
                            {
                                "date": "2024-11-18",
                                "price": 1980
                            },
                            {
                                "date": "2024-11-19",
                                "price": 2000
                            }
                        ],
                        "last7Days": [
                            {
                                "date": "2024-11-13",
                                "price": 1850
                            },
                            {
                                "date": "2024-11-14",
                                "price": 1880
                            },
                            {
                                "date": "2024-11-15",
                                "price": 1900
                            },
                            {
                                "date": "2024-11-16",
                                "price": 1920
                            },
                            {
                                "date": "2024-11-17",
                                "price": 1950
                            },
                            {
                                "date": "2024-11-18",
                                "price": 1980
                            },
                            {
                                "date": "2024-11-19",
                                "price": 2000
                            }
                        ],
                        "last1Month": [
                            {
                                "date": "2024-10-20",
                                "price": 1800
                            },
                            {
                                "date": "2024-10-25",
                                "price": 1900
                            },
                            {
                                "date": "2024-11-01",
                                "price": 2000
                            },
                            {
                                "date": "2024-11-10",
                                "price": 2000
                            }
                        ],
                        "last1Year": [
                            {
                                "date": "2024-01-01",
                                "price": 1500
                            },
                            {
                                "date": "2024-03-01",
                                "price": 1600
                            },
                            {
                                "date": "2024-06-01",
                                "price": 1700
                            },
                            {
                                "date": "2024-09-01",
                                "price": 1800
                            },
                            {
                                "date": "2024-11-01",
                                "price": 2000
                            }
                        ]
                    }
                }
            }
        }
        """
        if let data = json.data(using: .utf8) {
            do {
                let decoded = try JSONDecoder().decode(UserPortfolioResponse.self, from: data)
                portfolio = decoded.userPortfolio
                mapToCryptoType(decoded.coinDetails)
            } catch {
                print(String(data: data, encoding: .utf8) ?? "Invalid JSON data")

            }
        }
    }

    func mapToCryptoType(_ coinDetails: [String: CoinDetails]) {
        guard let portfolio = portfolio else { return }
        
        // Extract last 7 days data for both Bitcoin and Ethereum
        chartData = portfolio.cryptoSummary.compactMap { summary in
            if let coinDetail = coinDetails[summary.coinId] {
                // Map the last 7 days data
                let lineData = coinDetail.priceGraph.last1Month.map { GraphData(date: $0.date ?? "", value: $0.price) }
                return CryptoTypeTest(type: summary.coinName, data: lineData)
            }
            return nil
        }
    }
}

struct CryptoLineChartView_Test: View {
    let data: [CryptoTypeTest]
    
    var body: some View {
        ZStack {
            Chart(data, id: \.type) { dataSeries in
                ForEach(dataSeries.data) { data in
                    LineMark(
                        x: .value("Date", data.date),
                        y: .value("Price", data.value)  // Correctly map to `value`
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

