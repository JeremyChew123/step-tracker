//
//  HealthDataListView.swift
//  Step Tracker
//
//  Created by Jeremy Chew on 6/10/25.
//

import SwiftUI

struct HealthDataListView: View {
    
    @Environment(HealthKitManager.self) private var hkManager
    @State private var isShowingAddDate = false
    @State private var addDataDate: Date = .now
    @State private var valueToAdd: String = ""
    
    var metric: HealthMetricContext
    var listData: [HealthMetric] {
        metric == .steps ? hkManager.stepData : hkManager.weightData
    }
    
    var body: some View {
        List(listData.reversed()) {data in
            HStack {
                Text(data.date, format: .dateTime.month().day().year())
                Spacer()
                Text(data.value, format: .number.precision(.fractionLength(metric == .steps ? 0 : 1)))
            }
        }
        .navigationTitle(metric.title)
        .sheet(isPresented: $isShowingAddDate) {
            addDataView
        }
        .toolbar{
            Button("Add Data", systemImage: "plus") {
                isShowingAddDate = true
            }
        }
    }
    
    var addDataView: some View { //if using it in this view, simple to do a var. Otherwise a struct will be better for multiple views
        NavigationStack { //need for title and toolbar
            Form {
                DatePicker("Date", selection: $addDataDate, displayedComponents: .date)
                HStack {
                    Text(metric.title)
                    Spacer()
                    TextField("Value", text: $valueToAdd)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 100)
                        .keyboardType(metric == .steps ? .numberPad : .decimalPad)
                }
            }
            .navigationTitle(metric.title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Data") {
                        Task {
                            if metric == .steps {
                                do {
                                    try await hkManager.addStepData(for: addDataDate, value: Double(valueToAdd)!)
                                    try await hkManager.fetchStepCount()
                                    isShowingAddDate = false
                                } catch STError.sharingDenied(let quantityType) {
                                    print("❌ Sharing denied for \(quantityType)")
                                } catch {
                                    
                                }
                            } else {
                                do {
                                    try await hkManager.addStepData(for: addDataDate, value: Double(valueToAdd)!)
                                    try await hkManager.fetchWeights()
                                    try await hkManager.fetchWeightsForDifferentials()
                                    isShowingAddDate = false
                                } catch STError.sharingDenied(let quantityType) {
                                    print("❌ Sharing denied for \(quantityType)")
                                } catch {
                                    
                                }
                            }
                        }
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Dismiss") {
                        isShowingAddDate = false
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack{
        HealthDataListView(metric: .steps)
            .environment(HealthKitManager())
    }
}
