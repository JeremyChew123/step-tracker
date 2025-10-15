//
//  WeightDiffBarChart.swift
//  Step Tracker
//
//  Created by Jeremy Chew on 12/10/25.
//

import SwiftUI
import Charts

struct WeightDiffBarChart: View {
    
    @State private var rawSelectedDate: Date?
    @State private var selectedDay: Date?
    
    var chartData: [DateValueChartData]
    
    var selectedData: DateValueChartData? {
        ChartHelper.parseSelectedDate(for: chartData, in: rawSelectedDate)
    }
    
    var body: some View {

        ChartContainer(chartType: .weightDiffBar) {
            Chart {
                if let selectedData {
                    ChartAnnotationView(data: selectedData, context: .weight)
                }
                
                ForEach(chartData) { weightDiff in
                    Plot {
                        BarMark(x: .value("day", weightDiff.date, unit: .day),
                                y: .value("weight", weightDiff.value)
                        )
                        .foregroundStyle(weightDiff.value <= 0 ? Color.mint.gradient : Color.indigo.gradient)
                    }
                    .accessibilityLabel(weightDiff.date.weekdayTitle) //x-axis
                    .accessibilityLabel("\(weightDiff.value.formatted(.number.precision(.fractionLength(1)).sign(strategy: .always()))) KG")
                }
            }
            .frame(height: 150)
            .chartXSelection(value: $rawSelectedDate.animation(.easeInOut))
            .chartXAxis{
                AxisMarks (values: .stride(by: .day)) {
                    AxisValueLabel(format: .dateTime.weekday(),centered: true)
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
                if chartData.isEmpty {
                    ChartEmptyView(systemImageName: "chart.bar", title: "No Data", description: "There is no weight data in the from the Health App")
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
    WeightDiffBarChart(chartData: MockData.weightDiffs)
}
