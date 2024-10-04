//
//  CreateExerciseViewViewModel.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 6/11/24.
//

import Foundation

class CreateExerciseViewViewModel: ObservableObject {
    @Published var errorMessage = ""
    @Published var movement: Movement
    @Published var showAlert: Bool = false
    
    init(movement: Movement) {
        self.movement = movement
    }
    
    func saveMovement() {
        guard validate() else {
            return
        }
        DatabaseManager.shared.saveMovement(movement: movement)
    }
    
    func validate() -> Bool {
        errorMessage = ""
        guard !movement.name.isEmpty else {
            errorMessage = "Movement must have a name."
            return false
        }
        guard !movement.bodyPart.isEmpty else {
            errorMessage = "Movement must target a body part."
            return false
        }
        
        guard !movement.type.isEmpty else {
            errorMessage = "Movement type must be specified."
            return false
        }
        
        return true
    }
    
    
    func deleteMovement() {
        DatabaseManager.shared.deleteMovement(movement: movement)
    }
}
