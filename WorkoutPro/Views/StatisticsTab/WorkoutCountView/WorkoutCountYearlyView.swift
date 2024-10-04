//
//  WorkoutCountYearlyView.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 9/14/24.
//

import SwiftUI

import SwiftUI
import Charts

struct WorkoutCountYearlyView: View {
    
    @ObservedObject var viewModel: WorkoutCountViewViewModel
    @State var scrollPosition: TimeInterval = Date().timeIntervalSinceReferenceDate  // Start at current date
    
    @Environment(\.calendar) var calendar

    // Date range for the currently visible section
    var scrollPositionStart: Date {
        Date(timeIntervalSinceReferenceDate: scrollPosition)
    }
    
    var scrollPositionEnd: Date {
        scrollPositionStart.addingTimeInterval(3600 * 24 * 365 * 3) // 3 years displayed
    }
    
    var workoutsInLastYear: Int {
        let today = Date()
        guard let oneYearAgo = calendar.date(byAdding: .year, value: -1, to: today) else { return 0 }
        
        let workoutsInLastYear = viewModel.workoutsByYear.filter { workoutData in
            workoutData.date >= oneYearAgo && workoutData.date <= today
        }
        
        return workoutsInLastYear.reduce(0) { result, workoutData in
            result + workoutData.workoutCount
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Show total workouts for the last year
            Group {
                Text("You completed ") +
                Text("\(workoutsInLastYear) workouts ").bold().foregroundColor(Color.accentColor) +
                Text("this past year")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            
            Group {
                
                // Display the currently visible date range
                Text("\(scrollPositionStart.formatted(.dateTime.year())) – \(scrollPositionEnd.formatted(.dateTime.year()))")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                
                // Yearly workout chart with scrollable axes
                Chart(viewModel.workoutsByYear, id: \.date) {
                    BarMark(
                        x: .value("Year", $0.date, unit: .year),
                        y: .value("Workouts", $0.workoutCount)
                    )
                }
                .chartScrollableAxes(.horizontal)  // Horizontal scrolling
                .chartXVisibleDomain(length: 3600 * 24 * 365 * 3)  // Limit visible domain to 3 years
                .chartScrollPosition(x: $scrollPosition)  // Control scroll position
                .onAppear {
                    scrollPosition = Date().timeIntervalSinceReferenceDate  // Set scroll position on appear
                }
            }
        }
        .padding()
    }
}

#Preview {
    WorkoutCountYearlyView(viewModel: WorkoutCountViewViewModel())
        .aspectRatio(1, contentMode: .fit)
        .padding()
}
