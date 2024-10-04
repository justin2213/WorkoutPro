//
//  WorkoutCountMonthlyView.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 9/14/24.
//

import SwiftUI

import SwiftUI
import Charts

struct WorkoutCountMonthlyView: View {
    
    @ObservedObject var viewModel: WorkoutCountViewViewModel
    @State var scrollPosition: TimeInterval = Date().timeIntervalSinceReferenceDate  // Start at current date
    
    @Environment(\.calendar) var calendar

    // Date range for the currently visible section
    var scrollPositionStart: Date {
        Date(timeIntervalSinceReferenceDate: scrollPosition)
    }
    
    var scrollPositionEnd: Date {
        scrollPositionStart.addingTimeInterval(3600 * 24 * 30 * 4) // 6 months displayed
    }
    
    var workoutsInLastMonth: Int {
        let today = Date()
        guard let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: today) else { return 0 }
        
        let workoutsInLastMonth = viewModel.workoutsByMonth.filter { workoutData in
            workoutData.date >= oneMonthAgo && workoutData.date <= today
        }
        
        return workoutsInLastMonth.reduce(0) { result, workoutData in
            result + workoutData.workoutCount
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Show total workouts for the last month
            
            Group {
                Text("You completed ") +
                Text("\(workoutsInLastMonth) workouts ").bold().foregroundColor(Color.accentColor) +
                Text("this past month")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                
            }
            Group {
                // Display the currently visible date range
                Text("\(scrollPositionStart.formatted(.dateTime.month().day())) – \(scrollPositionEnd.formatted(.dateTime.month().day().year()))")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                
                // Monthly workout chart with scrollable axes
                Chart(viewModel.workoutsByMonth, id: \.date) {
                    BarMark(
                        x: .value("Month", $0.date, unit: .month),
                        y: .value("Workouts", $0.workoutCount)
                    )
                }
                .chartScrollableAxes(.horizontal)  // Horizontal scrolling
                .chartXVisibleDomain(length: 3600 * 24 * 30 * 4)  // Limit visible domain to 6 months
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
    WorkoutCountMonthlyView(viewModel: WorkoutCountViewViewModel())
        .aspectRatio(1, contentMode: .fit)
        .padding()
}
