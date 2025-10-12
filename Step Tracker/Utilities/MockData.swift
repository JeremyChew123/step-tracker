//
//  MockData.swift
//  Step Tracker
//
//  Created by Jeremy Chew on 11/10/25.
//

import Foundation

struct MockData {
    static var steps: [HealthMetric] {
        var array: [HealthMetric] = []
        
        for i in 0..<28 {
            let metric = HealthMetric(date: Calendar.current.date(byAdding: .day, value: -i, to: .now)!,
                                      value: .random(in: 4_000...15_000))
            array.append(metric)
        }
        return array
    }
    
    static var weights: [HealthMetric] {
        var array: [HealthMetric] = []
        
        for i in 0..<28 {
            let metric = HealthMetric(date: Calendar.current.date(byAdding: .day, value: -i, to: .now)!,
                                      value: .random(in: 160 + Double(i/3)...200 + Double(i/3)))
            array.append(metric)
        }
        return array
    }
    
    static var weightDiffs: [WeeklyChartData] {
        var array: [WeeklyChartData] = []
        
        for i in 0..<7 {
            let diff = WeeklyChartData(date: Calendar.current.date(byAdding: .day, value: -i, to: .now)!,
                                         value: .random(in: -3...3))
            array.append(diff)
        }
        return array
    }
}
