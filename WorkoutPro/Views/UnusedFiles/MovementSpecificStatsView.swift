//
//  MovementSpecificStatsView.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 9/22/24.
//

import SwiftUI
import Charts

struct MovementSpecificStatsView: View {
    @ObservedObject var viewModel: MovementSpecificStatsViewViewModel
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium // You can customize this
        return formatter
    }
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) { // Enable horizontal scrolling for the chart
                Chart(viewModel.movementStats) { data in
                    LineMark(
                        x: .value("Date", data.date),
                        y: .value("One Rep Max", data.oneRepMax)
                    )
                    .symbol(Circle().strokeBorder(lineWidth: 2)) // Use circles as symbols
                    .symbolSize(50) // Adjust the size of the symbol
                }
                .chartYScale(domain: 0...maxOneRepMax()) // Adjust Y scale if needed
                .aspectRatio(1, contentMode: .fit)
                .padding()
                .frame(minWidth: 500) // Ensure the chart has enough width to scroll
            }
            .padding()

            // List of all data points underneath the chart
          List { // Enable horizontal scrolling for the data points
              Text("\(viewModel.movement.name) Stats")
              ForEach(viewModel.movementStats.reversed(), id: \.id) { data in
                    HStack {
                        Text("Date: \(data.date, formatter: dateFormatter)") // Format the date as needed
                        Spacer()
                        Text("\(data.oneRepMax)") // Display One Rep Max
                    }
                }
            }
        }

    }

    // Calculate max one rep max to dynamically set the Y scale domain
    func maxOneRepMax() -> Double {
        viewModel.movementStats.map { $0.oneRepMax }.max() ?? 100
    }
}



#Preview {
    MovementSpecificStatsView(viewModel: MovementSpecificStatsViewViewModel(movement: Movement(id: "D0A85F34-F79E-4A21-A2E3-C6B4F073E4A9", name: "Bench Press", type: "Weight", bodyPart: "Chest")))
}
