//
//  WorkoutMovements.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 6/17/24.
//

import Foundation

class WorkoutMovement: ObservableObject, Equatable, Identifiable, NSCopying {
    var identifier = UUID()
    @Published var id: String
    @Published var name: String
    @Published var type: String
    @Published var bodyPart: String
    @Published var sets: [WorkoutMovementSet]
    @Published var notes: String
    
    init(id: String, name: String, type: String, bodyPart: String, sets: [WorkoutMovementSet], notes: String) {
        self.id = id
        self.name = name
        self.type = type
        self.bodyPart = bodyPart
        self.sets = sets
        self.notes = notes
    }
    
    init(movement: Movement) {
        self.id = movement.id
        self.name = movement.name
        self.type = movement.type
        self.bodyPart = movement.bodyPart
        self.sets = []
        self.notes = ""
    }

    func addSet() {
        self.sets.append(WorkoutMovementSet(weight: "", reps: ""))
    }
    
    func removeSet() -> Bool {
        let _ = self.sets.popLast() 
        if self.sets.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    func getSetCount() -> Int {
        return self.sets.count
    }
    
    func removeSet(index: Int) {
        self.sets.remove(at: index)
    }
    
    func getLastSetData(setNumber: Int) -> WorkoutMovementSet? {
        return DatabaseManager.shared.fetchLastSet(movementID: self.id, setNumber: setNumber + 1)
    }
    
    func getMovementNotes() -> String? {
        return DatabaseManager.shared.fetchMovementNotes(movementID: self.id)
    }
    
    static func == (lhs: WorkoutMovement, rhs: WorkoutMovement) -> Bool {
            return lhs.id == rhs.id &&
                   lhs.name == rhs.name &&
                   lhs.type == rhs.type &&
                   lhs.bodyPart == rhs.bodyPart &&
                   lhs.sets == rhs.sets &&
                   lhs.notes == rhs.notes
        }
    func copy(with zone: NSZone? = nil) -> Any {
        return WorkoutMovement(id: self.id, name: self.name, type: self.type, bodyPart: self.bodyPart, sets: self.sets, notes: self.notes)
    }
    
    func replaceMovement(movement: Movement) {
        self.id = movement.id
        self.name = movement.name
        self.bodyPart = movement.bodyPart
        self.type = movement.type
    }

}
