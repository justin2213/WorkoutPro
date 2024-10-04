//
//  StatisticsView.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 6/5/24.
//

import SwiftUI
struct StatisticsView: View {
    @State var agreementText = ""
    @State var userAgreed = true
    @State private var current = 67.0
    @State private var minValue = 0.0
    @State private var maxValue = 100.00
    @State var isPresented = true

    func formatGaugeNumber(_ num: String) -> String {
        let number = Double(num) ?? 0
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2

        if number < 10_000 {
            return formatter.string(from: NSNumber(value: number)) ?? ""
        } else if number < 1_000_000 {
            let thousands = number / 1_000
            return "\(formatter.string(from: NSNumber(value: thousands)) ?? "")K"
        } else {
            let millions = number / 1_000_000
            return "\(formatter.string(from: NSNumber(value: millions)) ?? "")M"
        }
    }

    func formatNumberWithCommas(_ num: String) -> String {
        let number = Double(num) ?? 0
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? ""
    }


    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        WorkoutCountView()
                    } label: {
                        WorkoutCountViewNavLinkView()
                    }
                }
                
                Section {
                    NavigationLink {
                        MovementCategoryView()
                    } label: {
                        MovementCategoryNavLinkView()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Today")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text(getFormattedDate())
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Workout Statistics")
        }
    }

    private func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: Date())
    }
}

#Preview {
StatisticsView()
}
