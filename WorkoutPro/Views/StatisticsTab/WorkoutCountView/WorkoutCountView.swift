//
//  WorkoutCountView.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 9/14/24.
//

import SwiftUI

struct WorkoutCountView: View {
    @StateObject var viewModel = WorkoutCountViewViewModel()
    @State private var selectedTimeInterval = TimeInterval.week
    
    enum TimeInterval: String, CaseIterable, Identifiable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
        var id: Self { self }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Picker(selection: $selectedTimeInterval.animation()) {
                ForEach(TimeInterval.allCases) { interval in
                    Text(interval.rawValue)
                }
            } label: {
                Text("Time interval")
            }
            .pickerStyle(.segmented)
            
            switch selectedTimeInterval {
            case .week:
                WorkoutCountWeeklyView(viewModel: viewModel)
            case .month:
                WorkoutCountMonthlyView(viewModel: viewModel)
            case .year:
                WorkoutCountYearlyView(viewModel: viewModel)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Workout Totals")
    }
}

#Preview {
    WorkoutCountView()
}
