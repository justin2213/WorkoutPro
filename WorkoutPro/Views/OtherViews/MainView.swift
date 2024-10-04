//
//  ContentView.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 6/3/24.
//

import SwiftUI

struct MainView: View {
    @StateObject var user = User.shared
    var body: some View {
        if !user.name.isEmpty {
            accountView
        } else {
            RegisterView()
        }
    }
        
    @ViewBuilder
    var accountView: some View {
        TabView {
           StatisticsView()
                .tabItem {
                    Label("Statistics", systemImage: "chart.bar.xaxis.ascending")
                }
            WorkoutHistoryView()
                .tabItem {
                    Label("Workouts", systemImage: "dumbbell")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    MainView()
}
