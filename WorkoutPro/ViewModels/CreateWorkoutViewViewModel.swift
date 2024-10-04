//
//  CreateWorkoutViewViewModel.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 7/28/24.
//

import Foundation

class CreateWorkoutViewViewModel: ObservableObject {
    @Published var isSelectingMovement: Bool = false
    @Published var errorMessage: String = ""
    @Published var showActionSheet: Bool = false
    
    init() {}
    
    func saveWorkout(workout: SavedWorkout) -> Bool {
        guard validate(workout: workout) else {
            return false
        }
        
        DatabaseManager.shared.saveWorkoutRoutine(workout: workout)
        return true
    }
    
    func validate(workout: SavedWorkout) -> Bool {
        
        errorMessage = ""
        showActionSheet = false
        
        guard !workout.name.isEmpty else {
            errorMessage = "Workout must have a name!"
            return false
        }
        
        guard !workout.movements.isEmpty else {
            errorMessage = "Workout must have at least one movement!"
            showActionSheet = true
            return false
        }
        
        return true
    }
    
    
    
}
