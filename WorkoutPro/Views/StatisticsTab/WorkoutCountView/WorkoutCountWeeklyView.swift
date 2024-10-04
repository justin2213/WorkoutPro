import SwiftUI
import Charts

struct WorkoutCountWeeklyView: View {

    @ObservedObject var viewModel: WorkoutCountViewViewModel
    @State var scrollPosition: TimeInterval = Date().timeIntervalSinceReferenceDate  // Start at current date

    @Environment(\.calendar) var calendar

    // Date range for the currently visible section
    var scrollPositionStart: Date {
        Date(timeIntervalSinceReferenceDate: scrollPosition)
    }
    
    var scrollPositionEnd: Date {
        scrollPositionStart.addingTimeInterval(3600 * 24 * 7 * 4) // 10 weeks displayed
    }
    
    var workoutsInLastWeek: Int {
        let today = Date()
        guard let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: today) else { return 0 }
        
        let workoutsInLastWeek = viewModel.workoutsByWeek.filter { workoutData in
            workoutData.date >= oneWeekAgo && workoutData.date <= today
        }
        
        return workoutsInLastWeek.reduce(0) { result, workoutData in
            result + workoutData.workoutCount
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Group {
                // Show total workouts for the last week
                Text("You completed ") +
                Text("\(workoutsInLastWeek) workouts ").bold().foregroundColor(Color.accentColor) +
                Text("this past week")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            
            Group {
                // Display the currently visible date range
                Text("\(scrollPositionStart.formatted(.dateTime.month().day())) – \(scrollPositionEnd.formatted(.dateTime.month().day().year()))")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                
                // Weekly workout chart with scrollable axes
                Chart(viewModel.workoutsByWeek, id: \.date) {
                    BarMark(
                        x: .value("Week", $0.date, unit: .weekOfYear),
                        y: .value("Workouts", $0.workoutCount)
                    )
                }
                .chartScrollableAxes(.horizontal)  // Horizontal scrolling
                .chartXVisibleDomain(length: 3600 * 24 * 7 * 4)  // Limit visible domain to 10 weeks
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
    WorkoutCountWeeklyView(viewModel: WorkoutCountViewViewModel())
        .aspectRatio(1, contentMode: .fit)
        .padding()
}
