//
//  CustomChart.swift
//  CryptoApp
//
//  Created by Rockz on 25/11/24.
//

import SwiftUI
import Charts

struct CustomChartView: View {
    @State private var title: String
    @State private var data: [CharData]
    private let isShowLegend: Bool
    private let yMin: Double
    private let yMax: Double
    
    init(
        title: String,
        data: [CharData],
        isShowLegend: Bool = true
    ) {
        self.title = title
        self.data = data
        self.isShowLegend = isShowLegend
        self.yMin = data.map(\.value).min() ?? 0
        self.yMax = data.map(\.value).max() ?? 0
    }
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title3)
                .foregroundStyle(.gray)
            
            chartView
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Chart
private extension CustomChartView {
    var chartView: some View {
        Chart(data, id: \.id) {
            LineMark(
                x: .value("Time", $0.date, unit: .day),
                y: .value("Value", $0.value),
                series: .value("Series", $0.label)
            )
            .foregroundStyle($0.color)
            .foregroundStyle(by: .value("Series", $0.label))
            .interpolationMethod(.catmullRom)
            
            AreaMark(
                x: .value("Time", $0.date, unit: .day),
                yStart: .value("Min", data.map(\.value).min()!),
                yEnd: .value("Value", $0.value),
                series: .value("Series", $0.label)
            )
            .foregroundStyle(LinearGradient(
                colors: [$0.color.opacity(0.5), .clear],
                startPoint: .top,
                endPoint: .bottom
            ))
            .interpolationMethod(.catmullRom)
        }
        .chartXAxis {
            AxisMarks() {
                AxisValueLabel()
                    .foregroundStyle(.gray)
                AxisGridLine()
                    .foregroundStyle(.gray)
            }
        }
        .chartYScale(domain: yMin...yMax)
        .chartYAxis {
            AxisMarks(position: .leading) {
                AxisValueLabel()
                    .foregroundStyle(.gray)
                AxisGridLine()
                    .foregroundStyle(.gray)
            }
        }
        .chartLegend {
            legendsView
        }
    }
    
    @ViewBuilder
    var legendsView: some View {
        if isShowLegend {
            ScrollView(.horizontal) {
                HStack {
                    let colors = data.reduce(into: [String:Color](), { $0[$1.label] = $1.color }).map { ($0.key, $0.value) }
                    ForEach(Array(colors), id: \.0) { data in
                        HStack {
                            BasicChartSymbolShape.circle
                                .foregroundColor(data.1)
                                .frame(width: 8, height: 8)
                            Text(data.0)
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                    }
                }
                .padding()
            }
            .scrollIndicators(.never)
        }
    }
}

import SwiftUI

struct CharData: Identifiable {
    let id = UUID()
    var label: String
    var color: Color
    var date: Date
    var value: Double
    
    // Sample Data
    static let sampleData: [CharData] = [
        CharData(label: "Lighting", color: .blue, date: mockDate(0), value: 50),
        CharData(label: "Lighting", color: .blue, date: mockDate(1), value: 100),
        CharData(label: "Lighting", color: .blue, date: mockDate(2), value: 140),
        CharData(label: "Lighting", color: .blue, date: mockDate(3), value: 74),
        CharData(label: "Lighting", color: .blue, date: mockDate(4), value: 134),
        CharData(label: "Lighting", color: .blue, date: mockDate(5), value: 34),
        CharData(label: "Lighting", color: .blue, date: mockDate(6), value: 55),
        CharData(label: "Lighting", color: .blue, date: mockDate(7), value: 190),
        CharData(label: "Lighting", color: .blue, date: mockDate(8), value: 45),
        CharData(label: "Lighting", color: .blue, date: mockDate(9), value: 121),
    ]
    
    // Mock date generator
    static func mockDate(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: .now) ?? Date()
    }
    
    // Weekly data
    static func weeklyData() -> [CharData] {
        (0..<7).map { day in
            CharData(
                label: "Lighting",
                color: .blue,
                date: mockDate(day),
                value: Double.random(in: 30...200)
            )
        }
    }
    
    // Monthly data
    static func monthlyData() -> [CharData] {
        (0..<30).map { day in
            CharData(
                label: "Lighting",
                color: .blue,
                date: mockDate(day),
                value: Double.random(in: 50...300)
            )
        }
    }
    
    // Yearly data
    static func yearlyData() -> [CharData] {
        (0..<12).map { month in
            CharData(
                label: "Lighting",
                color: .blue,
                date: Calendar.current.date(byAdding: .month, value: month, to: .now) ?? Date(),
                value: Double.random(in: 500...2000)
            )
        }
    }
}

// MARK: - Custom Chart View
struct CustomChartViewTest: View {
    
    @State private var title: String
    @State private var data: [TestChartData]
    private let isShowLegend: Bool
    private let yMin: Double
    private let yMax: Double
    
    init(
        title: String,
        data: [TestChartData],
        isShowLegend: Bool = true
    ) {
        self.title = title
        self.data = data
        self.isShowLegend = isShowLegend
        self.yMin = data.map(\.value).min() ?? 0
        self.yMax = data.map(\.value).max() ?? 0
    }
    
    var body: some View {
        VStack {
            chartView
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Chart Extension
private extension CustomChartViewTest {
    var chartView: some View {
        Chart(data, id: \.id) {
            LineMark(
                x: .value("Time", $0.date, unit: .day),
                y: .value("Value", $0.value),
                series: .value("Series", $0.label)
            )
            .foregroundStyle($0.color)
            .interpolationMethod(.catmullRom)
            
            AreaMark(
                x: .value("Time", $0.date, unit: .day),
                yStart: .value("Min", data.map(\.value).min()!),
                yEnd: .value("Value", $0.value),
                series: .value("Series", $0.label)
            )
            .foregroundStyle(LinearGradient(
                colors: [$0.color.opacity(0.5), .clear],
                startPoint: .top,
                endPoint: .bottom
            ))
            .interpolationMethod(.catmullRom)
        }
        //        .chartXAxis {
        //            AxisMarks(position: .bottom, values: .automatic) {  value in
        //                AxisValueLabel()
        //                    .foregroundStyle(.gray)
        //                AxisGridLine()
        //                    .foregroundStyle(.gray)
        //            }
        //        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day)) { value in
                //                AxisValueLabel(format: .dateTime.day().month(), centered: true, orientation: .verticalReversed)
                //  .foregroundStyle(.gray)
                
                AxisGridLine()
                    .foregroundStyle(.gray)
            }
        }
        
        
        .chartYScale(domain: yMin...yMax)
        .chartYAxis {
            AxisMarks(position: .leading) {
                AxisGridLine()
                    .foregroundStyle(.gray)
            }
        }
        .chartLegend {
            legendsView
        }
    }
    
    @ViewBuilder
    var legendsView: some View {
        if isShowLegend {
            ScrollView(.horizontal) {
                HStack {
                    let colors = data.reduce(into: [String: Color](), { $0[$1.label] = $1.color }).map { ($0.key, $0.value) }
                    ForEach(Array(colors), id: \.0) { data in
                        HStack {
                            BasicChartSymbolShape.circle
                                .foregroundColor(data.1)
                                .frame(width: 8, height: 8)
                            Text(data.0)
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                    }
                }
                .padding()
            }
            .scrollIndicators(.never)
        }
    }
}
