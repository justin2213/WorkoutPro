//
//  WorkoutProApp.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 6/3/24.
//

import SwiftUI
import UserNotifications

@main
struct WorkoutProApp: App {
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled: Bool = true
    var body: some Scene {
        WindowGroup {
            MainView()
                .preferredColorScheme(isDarkModeEnabled ? .dark : .light)
                .onAppear {
                    NotificationManager.shared.requestAuthorization()
                }
        }
    }
}
