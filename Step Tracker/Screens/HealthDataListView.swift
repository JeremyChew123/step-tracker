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
    @State private var isShowingAlert: Bool = false
    @State private var writeError: STError = .noData
    
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
                        .frame(width: 140)
                        .keyboardType(metric == .steps ? .numberPad : .decimalPad)
                }
            }
            .navigationTitle(metric.title)
            .alert(isPresented: $isShowingAlert, error: writeError) {writeError in
                switch writeError {
                case .authNotDetermined, .noData, .unableToCompleteRequest, .invalidData:
                    EmptyView()
                case .sharingDenied(_):
                    Button("Settings") {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }
                    Button("Cancel", role: .cancel) {}
                }
            } message: {writeError in
                Text(writeError.failureReason)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Data") {
                        guard let value = Double(valueToAdd) else {
                            writeError = .invalidData
                            isShowingAlert = true
                            valueToAdd = ""
                            return
                        }
                        Task {
                            if metric == .steps {
                                do {
                                    try await hkManager.addStepData(for: addDataDate, value: value)
                                    try await hkManager.fetchStepCount()
                                    isShowingAddDate = false
                                } catch STError.sharingDenied(let quantityType) {
                                    writeError = .sharingDenied(quantityType: quantityType)
                                    isShowingAlert = true
                                } catch {
                                    writeError = .unableToCompleteRequest
                                    isShowingAlert = true
                                }
                            } else {
                                do {
                                    try await hkManager.addStepData(for: addDataDate, value: value)
                                    try await hkManager.fetchWeights()
                                    try await hkManager.fetchWeightsForDifferentials()
                                    isShowingAddDate = false
                                } catch STError.sharingDenied(let quantityType) {
                                    writeError = .sharingDenied(quantityType: quantityType)
                                    isShowingAlert = true
                                } catch {
                                    writeError = .unableToCompleteRequest
                                    isShowingAlert = true
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
