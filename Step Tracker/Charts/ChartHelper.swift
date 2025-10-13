//
//  ChartHelper.swift
//  Step Tracker
//
//  Created by Jeremy Chew on 13/10/25.
//

import Foundation

struct ChartHelper {
    static func convert(data: [HealthMetric]) -> [DateValueChartData] {
        data.map {
            .init(date: $0.date, value: $0.value)
        }
    }
    
    static func averageValue(for data: [DateValueChartData]) -> Double {
        guard !data.isEmpty else { return 0 }
        let totalSteps = data.reduce(0) { $0 + $1.value} //there is date and value. we only want the value
        return totalSteps / Double(data.count)
    }
    
    static func parseSelectedDate(for data: [DateValueChartData], in selectedDate: Date?) -> DateValueChartData? {
        guard let selectedDate else { return nil }
        return data.first(where: {
            Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
        })
    }
}
