//
//  WorkoutViewViewModel.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 8/28/24.
//

import Foundation

class WorkoutViewViewModel: ObservableObject {
    
    // Enums for sheets
    @Published var activeSheet: ActiveSheet?
    @Published var activeAlert: ActiveAlert?
    
    // Functions
    @Published private var movementAction: (Movement) -> Void = {_ in }
    
    // Properties
    @Published var isNewWorkout: Bool = true
    @Published var title: String = "New Workout"
   
    // Workout end time properties
    @Published private var timer: Timer?
    
    
    // Messages
    @Published var cancelAlertMessage: String = ""
    @Published var saveAlertMessage: String = ""
    
    // Original workout for comparing if there is changes
    let originalWorkout: Workout?
    

    
    enum ActiveAlert: Identifiable {
        case exitWorkout
        case saveWorkout
        
        var id: Int {
            hashValue
        }
    }
    
    enum ActiveSheet: Identifiable {
        case endTimeSelector
        case startTimeSelector
        case editMovementSheet
        case movementSelector
        
        
        var id: Int {
            hashValue
        }
    }
    
    init(originalWorkout: Workout? = nil) {
            self.originalWorkout = originalWorkout
            self.isNewWorkout = originalWorkout == nil
            self.title = originalWorkout == nil ? "New Workout" : "Edit Workout"
    }
    
    
    func setMovementAction(movementAction: @escaping (Movement) -> Void) {
        self.movementAction = movementAction
    }
    
    func getMovementAction() -> (Movement) -> Void {
        return movementAction
    }
    
    func saveWorkout(workout: Workout) -> Bool {
        
        guard validateWorkout(workout: workout) else {
            return false
        }
        
        DatabaseManager.shared.saveWorkout(workout: workout)
        return true
    }
    
    func cancelWorkout(workout: Workout) -> Bool {
        cancelAlertMessage = ""
        if isNewWorkout {
            cancelAlertMessage = "Are you sure you wish to cancel"
            self.activeAlert = .exitWorkout
            return false
        } else if originalWorkout != workout {
            cancelAlertMessage = "Save unsaved changes?"
            self.activeAlert = .exitWorkout
            return false
        }
        return true
    }
    
    func validateWorkout(workout: Workout) -> Bool {
        saveAlertMessage = ""
        
        let hasEmptySets = workout.movements.contains { movement in
            movement.sets.contains { set in
                set.reps.isEmpty || set.weight.isEmpty
            }
        }
        
        guard !hasEmptySets else {
            saveAlertMessage = "Empty Sets"
            activeAlert = .saveWorkout
            return false
        }
        
        guard !workout.movements.isEmpty else {
            saveAlertMessage = "There are no movements. Workout must have movments."
            return false
        }
        
        if workout.name.isEmpty {
            workout.setName()
        }
        
        return true
    }
}



