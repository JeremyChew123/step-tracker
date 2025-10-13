//
//  ChartDataTypes.swift
//  Step Tracker
//
//  Created by Jeremy Chew on 9/10/25.
//

import Foundation

struct WeeklyChartData: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    let value: Double
}
