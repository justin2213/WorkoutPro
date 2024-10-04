//
//  Workout.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 6/17/24.
//

import Foundation

class Workout: ObservableObject, Equatable, NSCopying {
    
    @Published var id: String
    @Published var name: String
    @Published var startTime: Date
    @Published var endTime: Date
    @Published var notes: String
    @Published var movements: [WorkoutMovement]
    @Published private var timer: Timer?
    
    init(id: String, name: String, startTime: Date, endTime: Date, notes: String, movements: [WorkoutMovement]) {
        self.id = id
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
        self.notes = notes
        self.movements = movements
    }
    
    // Used for creating workout from saved workout
    init(name: String, movements: [WorkoutMovement]) {
        self.id = UUID().uuidString
        self.name = name
        self.startTime = Date()
        self.endTime = Date()
        self.notes = ""
        self.movements = movements
    }
    
    // Used for creating an empty new workout object
    init() {
        self.id = UUID().uuidString
        self.name = ""
        self.startTime = Date()
        self.endTime = Date()
        self.notes = ""
        self.movements = []
    }
    
    func addMovement(movement: Movement) {
        self.movements.append(WorkoutMovement(id: movement.id, name: movement.name, type: movement.type, bodyPart: movement.bodyPart, sets: [WorkoutMovementSet(weight: "", reps: "")], notes: ""))
    }
    
    func autofill() {
        for movement in movements {
            for setIndex in movement.sets.indices {
                if movement.sets[setIndex].weight.isEmpty && movement.sets[setIndex].reps.isEmpty {
                    if let set = DatabaseManager.shared.fetchLastSet(movementID: movement.id, setNumber: setIndex + 1) {
                        movement.sets[setIndex] = set
                    } else {
                        movement.sets.remove(at: setIndex)
                    }
                }
            }
        }
    }
    
    func setName() {
        var bodyParts: [String] = []
        for movement in self.movements {
            bodyParts.append(movement.bodyPart)
        }
        let uniqueBodyParts = Set(bodyParts).sorted()
        let containsBiceps = uniqueBodyParts.contains("Biceps")
            let containsTriceps = uniqueBodyParts.contains("Triceps")
            
            if containsBiceps && containsTriceps {
                print("Contains both Biceps and Triceps")
            }

        self.name = uniqueBodyParts.joined(separator: "/")
        
        switch self.name {
        case "Back/Biceps":
            self.name = "Pull"
        case "Biceps/Triceps":
            self.name = "Arms"
        case "Biceps/Chest/Triceps":
            self.name = "Arms/Chest"
        case "Biceps/Legs/Triceps":
            self.name = "Arms/Legs"
        case "Biceps/Shoulders/Triceps":
            self.name = "Arms/Shoulders"
        case "Chest/Shoulders/Triceps":
            self.name = "Push"
        case "Back/Biceps/Chest/Triceps":
            self.name = "Arms/Back/Chest"
        case "Back/Biceps/Legs/Triceps":
            self.name = "Arms/Back/Legs"
        case "Back/Biceps/Shoulders/Triceps":
            self.name = "Arms/Back/Shoulders"
        case "Biceps/Chest/Legs/Triceps":
            self.name = "Arms/Chest/Legs"
        case "Biceps/Chest/Shoulders/Triceps":
            self.name = "Arms/Chest/Shoulders"
        case "Biceps/Legs/Shoulders/Triceps":
            self.name = "Arms/Legs/Shoulders"
        case "Back/Biceps/Chest/Legs/Triceps":
            self.name = "Arms/Back/Chest/Legs"
        case "Back/Biceps/Chest/Shoulders/Triceps":
            self.name = "Upper Body"
        case "Back/Biceps/Legs/Shoulders/Triceps":
            self.name = "Arms/Back/Legs/Shoulders"
        case "Biceps/Chest/Legs/Shoulders/Triceps":
            self.name = "Arms/Chest/Legs/Shoulders"
        case "Back/Biceps/Chest/Legs/Shoulders/Triceps":
            self.name = "Full Body"
        default:
            break
        }
    }

    
    func setMovements(movments: [WorkoutMovement]) {
        self.movements = movements
    }
    
    func setNotes(notes: String) {
        self.notes = notes
    }
    
    func removeEmptyMovements() {
        self.movements = self.movements.filter { !$0.sets.isEmpty }
    }
    
    func removeMovement(movement: WorkoutMovement) {
        if let index = self.movements.firstIndex(where: { $0 == movement }) {
            self.movements.remove(at: index)
        }
        for movement in movements {
            print("Movement: \(movement.name)")
        }
    }
    
    func removeAllEmptySets() {
        for (index, movement) in self.movements.enumerated() {
            let filteredSets = movement.sets.filter { !$0.weight.isEmpty || !$0.reps.isEmpty }
            self.movements[index].sets = filteredSets
        }
    }
    
    func calcDuration() -> Int {
        let seconds = self.endTime.timeIntervalSince(self.startTime)
        let minutes = seconds / 60
        return Int(minutes.rounded())
    }
    
    static func == (lhs: Workout, rhs: Workout) -> Bool {
            return lhs.id == rhs.id &&
                   lhs.name == rhs.name &&
                   lhs.startTime == rhs.startTime &&
                   lhs.endTime == rhs.endTime &&
                   lhs.notes == rhs.notes &&
                   lhs.movements == rhs.movements
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
            let copyMovements = movements.map { $0.copy() as! WorkoutMovement }
            return Workout(id: self.id, name: self.name, startTime: self.startTime, endTime: self.endTime, notes: self.notes, movements: copyMovements)
        }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.endTime = Date()
        }
    }
    
    func pauseTimer() {
        timer?.invalidate()
    }
        
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func setStartTime(date: Date) {
        timer?.invalidate()
        self.startTime = date
    }
    
    func setEndTime(date: Date) {
        timer?.invalidate()
        self.endTime = date
    }
    
}
