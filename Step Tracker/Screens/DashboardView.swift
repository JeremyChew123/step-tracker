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
    @State private var isShowingPermissionSheet = false
    @State private var selectedStat: HealthMetricContext = .steps
    @State private var isShowingAlert: Bool = false
    @State private var fetchError: STError = .noData
    
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
                        StepBarChart(chartData: ChartHelper.convert(data: hkManager.stepData))
                        StepPieChart(chartData: ChartMath.averageWeekdayCount(for: hkManager.stepData))
                    case .weight:
                        WeightLineChart(chartData: ChartHelper.convert(data: hkManager.weightData))
                        WeightDiffBarChart(chartData: ChartMath.averageDailyWeightDiffs(for: hkManager.weightDiffData))
                    }
                    
                    
                    
                }
            }
            .padding()
            .task {
                fetchHealthData()
            }
            .navigationTitle("Dashboard")
            .navigationDestination(for: HealthMetricContext.self) {metric in
                HealthDataListView(metric: metric)
            }
            .fullScreenCover(isPresented: $isShowingPermissionSheet, onDismiss: {
                fetchHealthData()
            }, content: {
                HealthKitPermissionPrimingView()
            })
            .alert(isPresented: $isShowingAlert, error: fetchError) {fetchError in
                //action buttons
            } message: {fetchError in
                Text(fetchError.failureReason)
            }
        }
        .tint(selectedStat == .steps ? .pink : .indigo)
    }
    private func fetchHealthData() {
        Task{
            do {
                async let steps = hkManager.fetchStepCount()
                async let weightsForLineChart = hkManager.fetchWeights(daysBack: 28)
                async let weightsForDiffBarChart = hkManager.fetchWeights(daysBack: 29)
                
                hkManager.stepData = try await steps
                hkManager.weightData = try await weightsForLineChart
                hkManager.weightDiffData = try await weightsForDiffBarChart
                
            } catch STError.authNotDetermined{
                isShowingPermissionSheet = true
            } catch STError.noData {
                fetchError = .noData
                isShowingAlert = true
            } catch {
                fetchError = .unableToCompleteRequest
                isShowingAlert = true
            }
        }
    }
}

#Preview {
    DashboardView()
        .environment(HealthKitManager())
}

