//
//  WeeklyCountViewNavLink.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 9/15/24.
//

import SwiftUI

import SwiftUI
import Charts

struct WorkoutCountViewNavLinkView: View {
    @StateObject var viewModel = WorkoutCountViewViewModel()
    let sixMonthsAgo = Calendar.current.date(byAdding: .month, value: -6, to: Date())!

    
    @ViewBuilder
    var percentChanged: some View {
        if let changedWorkoutTotals = changedWorkoutTotals() {
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: isPositiveChange ? "arrow.up.right" : "arrow.down.right").bold()
                    .foregroundColor( isPositiveChange ? .green : .red)
                
                Text("Your workout totals have ") +
                Text(changedWorkoutTotals)
                    .bold() +
                Text(" in the last 3 months.")
            }
        }
        
        
        Chart(viewModel.workoutsByMonth.filter { $0.date >= sixMonthsAgo }, id: \.date) {
            BarMark(
                x: .value("Month", $0.date, unit: .month),
                y: .value("Workouts", $0.workoutCount)
            )
        }
        .frame(height: 70)
        .chartYAxis(.hidden)
        .chartXAxis(.hidden)
    }
    
    @ViewBuilder
    var hasNotChanged: some View {
        HStack(alignment: .firstTextBaseline) {
            Image(systemName: "arrow.right")
                .foregroundStyle(.gray)
            
            Text("Your workout totals have ") +
            Text("remained the same")
                .bold() +
            Text(" over the last 3 months.")
        }
    
        Chart(viewModel.workoutsByMonth.filter { $0.date >= sixMonthsAgo }, id: \.date) {
            BarMark(
                x: .value("Month", $0.date, unit: .month),
                y: .value("Workouts", $0.workoutCount)
            )
        }
        .frame(height: 70)
        .chartYAxis(.hidden)
        .chartXAxis(.hidden)
    }
    
    @ViewBuilder
    var notEnoughData: some View {
        HStack(alignment: .firstTextBaseline) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .foregroundStyle(.gray)
            Text("Trends")
        }
        
        Text("There is not enough data to show trends.")
            .frame(width: 275, height: 75, alignment: .trailing)
            .multilineTextAlignment(.center)
            .foregroundStyle(.gray)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            switch percentage {
            case -1.0:
                notEnoughData
            case 0.0:
                hasNotChanged
            default:
                percentChanged
            }
        }
    }
    
    func changedWorkoutTotals() -> String? {
        let percentage = percentage
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        
        
        guard let formattedPercentage = numberFormatter.string(from: NSNumber(value: percentage)) else {
            return nil
        }
        
        let changedDescription = percentage < 0 ? "decreased by " : "increased by "
        
        return changedDescription + formattedPercentage
    }
    
    var percentage: Double {
        viewModel.percentageChangeLast3Months() ?? -1.0
    }
    
    var isPositiveChange: Bool {
        percentage > 0
    }
}


#Preview {
    WorkoutCountViewNavLinkView()
}
