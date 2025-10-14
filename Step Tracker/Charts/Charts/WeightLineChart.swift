//
//  WeightLineChart.swift
//  Step Tracker
//
//  Created by Jeremy Chew on 11/10/25.
//

import SwiftUI
import Charts

struct WeightLineChart: View {
    
    @State private var rawSelectedDate: Date?
    @State private var selectedDay: Date?
    
    var chartData: [DateValueChartData]
    
    var selectedData: DateValueChartData? {
        ChartHelper.parseSelectedDate(for: chartData, in: rawSelectedDate)
    }
    
    var minValue: Double {
        chartData.map {$0.value}.min() ?? 0
    }
    
    var average: Double {
        chartData.map { $0.value }.average
    }
    
    var body: some View {

        ChartContainer(chartType: .weightLine(average: average)) {
            Chart {
                if let selectedData {
                    ChartAnnotationView(data: selectedData, context: .weight)
                }
                
                if !chartData.isEmpty {
                    RuleMark(y: .value("Goal", 75))
                        .foregroundStyle(.mint)
                        .lineStyle(.init(lineWidth: 1, dash: [5]))
                        .accessibilityHidden(true)
                }
                ForEach(chartData) { weight in
                    Plot {
                        AreaMark(x: .value("Day", weight.date, unit: .day),
                                 yStart: .value("weight", weight.value),
                                 yEnd: .value("Min Value", minValue))
                        .foregroundStyle(Gradient(colors: [.indigo.opacity(0.5),.clear]))
                        
                        LineMark(x: .value("Day", weight.date, unit: .day),
                                 y: .value("Weight", weight.value))
                        .foregroundStyle(.indigo)
                        .interpolationMethod(.catmullRom)
                        .symbol(.circle)
                    }
                    .accessibilityLabel(weight.date.accesibilityDate) //x-axis
                    .accessibilityLabel("\(weight.value.formatted(.number.precision(.fractionLength(1)))) KG")
                }
            }
            .frame(height: 150)
            .chartXSelection(value: $rawSelectedDate.animation(.easeInOut))
            .chartYScale(domain: .automatic(includesZero: false))
            .chartXAxis{
                AxisMarks {
                    AxisValueLabel(format: .dateTime.month(.defaultDigits).day())
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine()
                        .foregroundStyle(Color.secondary.opacity(0.3))
                    AxisValueLabel()
                }
            }
            .overlay {
                if chartData.isEmpty{
                    ChartEmptyView(systemImageName: "chart.line.downtrend.xyaxis", title: "No Data", description: "There is no weight data in the from the Health App")
                }
            }
        }
        .sensoryFeedback(.selection, trigger: selectedDay)
        .onChange(of: rawSelectedDate) {oldValue, newValue in
            if oldValue?.weekdayInt != newValue?.weekdayInt {
                selectedDay = newValue
            }
        }
    }
}

#Preview {
    WeightLineChart(chartData: ChartHelper.convert(data: MockData.weights))
}
