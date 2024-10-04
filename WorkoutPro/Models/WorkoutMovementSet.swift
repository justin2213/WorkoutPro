//
//  WorkoutMovementsSets.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 6/17/24.
//

import Foundation

struct WorkoutMovementSet: Equatable {
    var weight: String
    var reps: String
    
    static func == (lhs: WorkoutMovementSet, rhs: WorkoutMovementSet) -> Bool {
        return lhs.weight == rhs.weight &&
               lhs.reps == rhs.reps
    }
}
