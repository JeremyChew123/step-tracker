//
//  ChartContainer.swift
//  Step Tracker
//
//  Created by Jeremy Chew on 13/10/25.
//

import SwiftUI

struct ChartContainerConfiguration {
    let title: String
    let symbol: String
    let subtitle: String
    let context: HealthMetricContext
    let isNav: Bool
}

struct ChartContainer<Content: View>: View {
    
    let config: ChartContainerConfiguration
    
    @ViewBuilder var content: () -> Content //viewbuilder gives it curly braces which chart has
    
    var body: some View {
        VStack(alignment: .leading) {
            if config.isNav {
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
        NavigationLink(value: config.context){
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
            Label(config.title, systemImage: config.symbol)
                .font(.title3.bold())
                .foregroundStyle(config.context == .steps ? .pink : .indigo)
            
            Text(config.subtitle)
                .font(.caption)
        }
    }
}

#Preview {
    ChartContainer(config: .init(title: "Test Title", symbol: "figure", subtitle: "Test Subitle", context: .steps, isNav: true)) {
        Text("chart goes here")
            .frame(minHeight: 150)
    }
}
