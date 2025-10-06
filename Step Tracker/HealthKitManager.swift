//
//  HealthKitManager.swift
//  Step Tracker
//
//  Created by Jeremy Chew on 6/10/25.
//

import Foundation
import HealthKit
import Observation

@Observable class HealthKitManager {
    let store = HKHealthStore()
    let types: Set = [HKQuantityType(.stepCount), HKQuantityType(.bodyMass)]
}
