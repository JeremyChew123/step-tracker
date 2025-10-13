//
//  ChartContainer.swift
//  Step Tracker
//
//  Created by Jeremy Chew on 13/10/25.
//

import SwiftUI

struct ChartContainer<Content: View>: View {
    
    let title: String
    let symbol: String
    let subtitle: String
    let context: HealthMetricContext
    let isNav: Bool
    
    @ViewBuilder var content: () -> Content //viewbuilder gives it curly braces which chart has
    
    var body: some View {
        VStack(alignment: .leading) {
            if isNav {
                navigationLinkView
            } else {
                titleView
                    .padding(.bottom, 12)
                    .foregroundStyle(.secondary)
            }
            content()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
    
    var navigationLinkView: some View {
        NavigationLink(value: context){
            HStack {
                titleView
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding(.bottom, 12)
        }
        .foregroundStyle(.secondary)
    }
    
    var titleView: some View {
        VStack(alignment: .leading) {
            Label(title, systemImage: symbol)
                .font(.title3.bold())
                .foregroundStyle(context == .steps ? .pink : .indigo)
            
            Text(subtitle)
                .font(.caption)
        }
    }
}

#Preview {
    ChartContainer(title: "test", symbol: "figure.walk", subtitle: "test subtitle", context: .steps, isNav: true) {
        Text("chart goes here")
            .frame(minHeight: 150)
    }
}
