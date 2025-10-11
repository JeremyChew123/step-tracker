//
//  WeightLineChart.swift
//  Step Tracker
//
//  Created by Jeremy Chew on 11/10/25.
//

import SwiftUI
import Charts

struct WeightLineChart: View {
    
    var chartData: [HealthMetric]
    var selectedStat: HealthMetricContext
    
    var body: some View {
        VStack {
            NavigationLink(value: selectedStat){
                HStack {
                    VStack(alignment: .leading) {
                        Label("Weight", systemImage: "figure.walk")
                            .font(.title3.bold())
                            .foregroundStyle(.indigo)
                        
                        Text("Avg: 180 lbs")
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                }
                .padding(.bottom, 12)
            }
            .foregroundStyle(.secondary)
            
            Chart {
                ForEach(chartData) { weight in
                    AreaMark(x: .value("Day", weight.date, unit: .day),
                             y: .value("Weight", weight.value))
                    .foregroundStyle(Gradient(colors: [.blue,.clear]))
                    
                    LineMark(x: .value("Day", weight.date, unit: .day),
                             y: .value("Weight", weight.value))
                    
                    
                }
            }
            .frame(height: 150)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))

    }
}

#Preview {
    WeightLineChart(chartData: MockData.weights, selectedStat: .weight)
}
