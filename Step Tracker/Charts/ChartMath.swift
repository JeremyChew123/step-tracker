//
//  ChartMath.swift
//  Step Tracker
//
//  Created by Jeremy Chew on 9/10/25.
//

import Foundation
import Algorithms

struct ChartMath {

    //static because you can use this function on ChartMath itself and not just an instance
    static func averageWeekdayCount(for metric: [HealthMetric]) -> [WeeklyChartData] {
        let sortedByWeekday = metric.sorted { $0.date.weekdayInt < $1.date.weekdayInt}
        let weekdayArray = sortedByWeekday.chunked {$0.date.weekdayInt == $1.date.weekdayInt}
        
        var weeklyChartData: [WeeklyChartData] = []
        
        for array in weekdayArray {
            guard let firstValue = array.first else { continue }
            let total = array.reduce(0) { $0+$1.value }
            let avgSteps = total/Double(array.count)
            
            weeklyChartData.append(.init(date: firstValue.date, value: avgSteps))
            print(weeklyChartData)
        }
        return weeklyChartData
    }
}
