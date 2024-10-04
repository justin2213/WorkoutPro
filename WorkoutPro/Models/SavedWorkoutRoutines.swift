//
//  SavedWorkoutRoutines.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 7/29/24.
//

import Foundation

class SavedWorkoutRoutines: ObservableObject {
    static let shared = SavedWorkoutRoutines() // Singleton instance
    
    @Published var workouts: [SavedWorkout]
    
    private init() {
        workouts = DatabaseManager.shared.fetchWorkoutRoutines()
    }
    
    func fetchWorkouts() {
        self.workouts = DatabaseManager.shared.fetchWorkoutRoutines()
    }
}
