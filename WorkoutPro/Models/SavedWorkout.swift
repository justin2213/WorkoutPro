//
//  SavedWorkout.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 7/29/24.
//

import Foundation

class SavedWorkout: ObservableObject,Equatable, NSCopying {
    @Published var id: String
    @Published var name: String
    @Published var movements: [WorkoutMovement]
    
    init(id: String,name: String, movements: [WorkoutMovement]) {
        self.id = id
        self.name = name
        self.movements = movements
    }
    
    init() {
        self.id = UUID().uuidString
        self.name = ""
        self.movements = []
    }
    
    func addMovement(movement: Movement) {
        self.movements.append(WorkoutMovement(id: movement.id, name: movement.name, type: movement.type, bodyPart: movement.bodyPart, sets: [WorkoutMovementSet(weight: "", reps: "")], notes: ""))
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
            let copyMovements = movements.map { $0.copy() as! WorkoutMovement }
            return SavedWorkout(id: self.id, name: self.name, movements: copyMovements)
        }
    
    func copy(from other: SavedWorkout) {
            self.name = other.name
        self.movements = other.movements.map { $0.copy() as! WorkoutMovement }
        }
    
    static func == (lhs: SavedWorkout, rhs: SavedWorkout) -> Bool {
            return lhs.id == rhs.id &&
                   lhs.name == rhs.name &&
                   lhs.movements == rhs.movements
    }
    
}
