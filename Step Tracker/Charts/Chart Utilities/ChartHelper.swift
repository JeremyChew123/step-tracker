//
//  ChartHelper.swift
//  Step Tracker
//
//  Created by Jeremy Chew on 13/10/25.
//

import Foundation
import Algorithms

struct ChartHelper {
    static func convert(data: [HealthMetric]) -> [DateValueChartData] {
        data.map {
            .init(date: $0.date, value: $0.value)
        }
    }
    
    static func parseSelectedDate(for data: [DateValueChartData], in selectedDate: Date?) -> DateValueChartData? {
        guard let selectedDate else { return nil }
        return data.first(where: {
            Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
        })
    }
    
    //static because you can use this function on ChartMath itself and not just an instance
    static func averageWeekdayCount(for metric: [HealthMetric]) -> [DateValueChartData] {
        let sortedByWeekday = metric.sorted(using: KeyPathComparator(\.date.weekdayInt))
        let weekdayArray = sortedByWeekday.chunked {$0.date.weekdayInt == $1.date.weekdayInt}
        
        var weeklyChartData: [DateValueChartData] = []
        
        for array in weekdayArray {
            guard let firstValue = array.first else { continue }
            let total = array.reduce(0) { $0+$1.value }
            let avgSteps = total/Double(array.count)
            
            weeklyChartData.append(.init(date: firstValue.date, value: avgSteps))
        }
        return weeklyChartData
    }
    
    static func averageDailyWeightDiffs(for metric: [HealthMetric]) -> [DateValueChartData] {
        var diffValues: [(date: Date, value: Double)] = []
        
        guard metric.count > 1 else { return []}
        
        for i in 1..<metric.count {
            let date = metric[i].date
            let value = metric[i].value - metric[i-1].value
            diffValues.append((date: date, value: value))
            print(diffValues)
        }
        print(diffValues)
        let sortByWeekday = diffValues.sorted(using: KeyPathComparator(\.date.weekdayInt))
        let weekdayArray = sortByWeekday.chunked {$0.date.weekdayInt == $1.date.weekdayInt}
        
        var weeklyChartData: [DateValueChartData] = []
        
        for array in weekdayArray {
            guard let firstValue = array.first else { continue }
            let total = array.reduce(0) { $0 + $1.value }
            let averageWeight = total / Double(array.count)
            
            weeklyChartData.append(.init(date: firstValue.date, value: averageWeight))
        }
        
        return weeklyChartData
    }
}
