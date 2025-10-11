//
//  DashboardView.swift
//  Step Tracker
//
//  Created by Jeremy Chew on 5/10/25.
//

import SwiftUI
import Charts

enum HealthMetricContext: CaseIterable, Identifiable {
    case steps, weight
    
    var id: Self {self}
    
    var title: String {
        switch self {
        case .steps: return "Steps"
        case .weight: return "Weight"
        }
    }
}

struct DashboardView: View {
    
    @Environment(HealthKitManager.self) private var hkManager
    @AppStorage("hasSeenPermissionPriming") private var hasSeenPermissionPriming = false
    @State private var isShowingPermissionSheet = false
    var isSteps: Bool { selectedStat == .steps}
    @State private var selectedStat: HealthMetricContext = .steps
    

    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                //Main VStack
                VStack(spacing: 20) {
                    
                    //Picker
                    Picker("Selected Stat", selection: $selectedStat) {
                        ForEach(HealthMetricContext.allCases) {
                            Text($0.title)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    switch selectedStat {
                    case .steps:
                        StepBarChart(chartData: hkManager.stepData, selectedStat: selectedStat)
                        StepPieChart(chartData: ChartMath.averageWeekdayCount(for: hkManager.stepData))
                    case .weight:
                        WeightLineChart(chartData: hkManager.weightData, selectedStat: selectedStat)
                    }
                    
                    
                    
                }
            }
            .padding()
            .task {
                await hkManager.fetchStepCount()
                await hkManager.fetchWeights()
                isShowingPermissionSheet = !hasSeenPermissionPriming
            }
            .navigationTitle("Dashboard")
            .navigationDestination(for: HealthMetricContext.self) {metric in
                HealthDataListView(metric: metric)
            }
            .sheet(isPresented: $isShowingPermissionSheet, onDismiss: {
                //fetch health data
            }, content: {
                HealthKitPermissionPrimingView(hasSeen: $hasSeenPermissionPriming)
            })
        }
        .tint(isSteps ? .pink : .indigo)
    }
}

#Preview {
    DashboardView()
        .environment(HealthKitManager())
}

