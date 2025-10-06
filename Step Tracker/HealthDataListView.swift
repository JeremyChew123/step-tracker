//
//  HealthDataListView.swift
//  Step Tracker
//
//  Created by Jeremy Chew on 6/10/25.
//

import SwiftUI

struct HealthDataListView: View {
    
    var metric: HealthMetricContext
    @State private var isShowingAddDate = false
    @State private var addDataDate: Date = .now
    @State private var valueToAdd: String = ""
    
    var body: some View {
        List(0..<28) {i in
            HStack {
                Text(Date(), format: .dateTime.month().day().year())
                Spacer()
                Text(10000, format: .number.precision(.fractionLength(metric == .steps ? 0 : 1)))
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
                        //Add Code Later
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
    }
}
