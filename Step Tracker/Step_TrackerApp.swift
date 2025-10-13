//
//  Step_TrackerApp.swift
//  Step Tracker
//
//  Created by Jeremy Chew on 5/10/25.
//

import SwiftUI

@main
struct Step_TrackerApp: App {
    
    let hkManger = HealthKitManager()
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environment(hkManger)
        }
    }
}
