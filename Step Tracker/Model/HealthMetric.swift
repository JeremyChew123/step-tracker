//
//  HealthMetric.swift
//  Step Tracker
//
//  Created by Jeremy Chew on 7/10/25.
//

import Foundation

struct HealthMetric: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}
