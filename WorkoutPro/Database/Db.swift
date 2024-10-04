//
//  Db.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 6/3/24.
//

import Foundation
import SQLite


class DatabaseManager {
    static let shared = DatabaseManager() // Singleton instance
    
    private let dbConnection: Connection?
    
    // Movements table in database
    let movementsTable = Table("Movements")
    let id = Expression<String>("MovementID")
    let name = Expression<String>("MovementName")
    let type = Expression<String>("MovementType")
    let bodyPart = Expression<String>("MovementBodyPart")
    
    //Workouts Table in database
    let workoutsTable = Table("Workouts")
    let workoutID = Expression<String>("WorkoutID")
    let workoutName = Expression<String>("WorkoutName")
    let workoutStartTime = Expression<Double>("WorkoutStartTime")
    let workoutEndTime = Expression<Double>("WorkoutEndTime")
    let workoutNotes = Expression<String>("WorkoutNotes")
    
    //WorkoutMovementsSets table in database
    let workoutMovementsSetsTable = Table("WorkoutMovementsSets")
    let setID = Expression<Int>("SetID")
    let wmWorkoutID = Expression<String>("WorkoutID")
    let movementID = Expression<String>("MovementID")
    let setNumber = Expression<Int>("SetNumber")
    let weight = Expression<Double>("Weight")
    let reps = Expression<Int>("Reps")
    let movementNotes = Expression<String>("MovementNotes")
    
    
    // SavedWorkoutRoutines table in database
    let savedWorkoutRoutinesTable = Table("SavedWorkoutRoutines")
    let savedWorkoutRoutineID = Expression<String>("SavedWorkoutRoutineID")
    let savedWorkoutRoutineName = Expression<String>("SavedWorkoutRoutineName")
    
    // SavedWorkoutRoutineMovements table in database
    let savedWorkoutRoutineMovementsTable = Table("SavedWorkoutRoutineMovements")
    let swRoutineID = Expression<String>("SavedWorkoutRoutineID")
    let swMovementID = Expression<String>("MovementID")
    let sets = Expression<Int>("Sets")
    
    // Badges table in database
    let badgesTable = Table("Badges")
    let badgeID = Expression<String>("BadgeID")
    let badgeName = Expression<String>("BadgeName")
    let badgeType = Expression<String>("BadgeType")
    let badgeDescription = Expression<String>("BadgeDescription")
    let badgeImage = Expression<String>("BadgeImage")
    let badgeAchieved = Expression<String>("BadgeAchieved")
    
    
    
    private init() {
        // Get the path to the documents directory
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unable to access documents directory")
        }
        
        let databaseURL = documentsURL.appendingPathComponent("WorkoutProDb.sqlite")
        
        // Copy the database file from the bundle to the documents directory if needed
        if !fileManager.fileExists(atPath: databaseURL.path) {
            if let bundleDatabaseURL = Bundle.main.url(forResource: "WorkoutProDb", withExtension: "sqlite") {
                do {
                    try fileManager.copyItem(at: bundleDatabaseURL, to: databaseURL)
                    print("Database copied to documents directory")
                } catch {
                    fatalError("Error copying database file: \(error.localizedDescription)")
                }
            } else {
                fatalError("Database file not found in bundle")
            }
        } else {
            print("Database already exists in documents directory")
        }
        
        // Connect to SQLite database file
        do {
            dbConnection = try Connection(databaseURL.path)
            print("Connected to database at \(databaseURL.path)")
        } catch {
            print("Error connecting to database: \(error.localizedDescription)")
            dbConnection = nil
        }
    }
    
    func fetchMovements() -> [Movement] {
        
        var movements = [Movement]()
        
        guard let dbConnection = dbConnection else {
            return movements
        }
        
        do {
            for movement in try dbConnection.prepare(movementsTable) {
                let movement = Movement(
                    id: movement[id],
                    name: movement[name],
                    type: movement[type],
                    bodyPart: movement[bodyPart]
                )
                movements.append(movement)
            }
        } catch {
            print("Error fetching movements: \(error.localizedDescription)")
        }
        return movements
    }
    
    func fetchWorkouts() -> [Workout] {
        var workouts = [Workout]()
        guard let dbConnection = dbConnection else {
            return workouts
        }
        
        do {
            for workoutRow in try dbConnection.prepare(workoutsTable) {
                let workoutIdValue = workoutRow[workoutID]
                let workoutNameValue = workoutRow[workoutName]
                let workoutStartTimeValue = Date(timeIntervalSince1970: workoutRow[workoutStartTime])
                let workoutEndTimeValue = Date(timeIntervalSince1970: workoutRow[workoutEndTime])
                let workoutNotesValue = workoutRow[workoutNotes]
                
                var movements = [WorkoutMovement]()
                let setsQuery = workoutMovementsSetsTable.filter(wmWorkoutID == workoutIdValue)
                var movementDict = [String: WorkoutMovement]()
                
                for setRow in try dbConnection.prepare(setsQuery) {
                    let mId = setRow[movementID]
                    let setNum = setRow[setNumber]
                    let setWeight = setRow[weight]
                    let setReps = setRow[reps]
                    let movementNotesValue = setRow[movementNotes]
                    
                    let set = WorkoutMovementSet(weight: String(setWeight), reps: String(setReps))
                    if var movement = movementDict[mId] {
                        movement.sets.append(set)
                        movementDict[mId] = movement
                    } else {
                        if let movementRow = try dbConnection.pluck(movementsTable.filter(movementID == mId)) {
                            let movement = WorkoutMovement(
                                id: mId,
                                name: movementRow[name],
                                type: movementRow[type],
                                bodyPart: movementRow[bodyPart],
                                sets: [set],
                                notes: movementNotesValue
                            )
                            movementDict[mId] = movement
                        }
                    }
                }
                movements = Array(movementDict.values)
                let workout = Workout(
                    id: workoutIdValue,
                    name: workoutNameValue,
                    startTime: workoutStartTimeValue,
                    endTime: workoutEndTimeValue,
                    notes: workoutNotesValue,
                    movements: movements
                )
                workouts.append(workout)
            }
        } catch {
            print("Error fetching workouts: \(error.localizedDescription)")
        }
        return workouts
    }
    
    func saveMovement(movement: Movement) {
        
        guard let dbConnection = dbConnection else {
            print("Database connection not available")
            return
        }
        
        do {
            try dbConnection.transaction {
                // Check if the movement exists
                let query = movementsTable.filter(id == movement.id)
                if let _ = try dbConnection.pluck(query) {
                    // Update the existing movement
                    let update = query.update(
                        name <- movement.name,
                        type <- movement.type,
                        bodyPart <- movement.bodyPart
                    )
                    try dbConnection.run(update)
                    print("Movement updated successfully")
                } else {
                    // Insert new movement
                    let insert = movementsTable.insert(
                        id <- movement.id,
                        name <- movement.name,
                        type <- movement.type,
                        bodyPart <- movement.bodyPart
                    )
                    try dbConnection.run(insert)
                    print("Movement added successfully")
                }
                SavedMovements.shared.fetchMovements()
            }
        } catch let error {
            print("Error adding or updating movement: \(error)")
        }
    }
    
    func deleteMovement(movement: Movement) {
        
        guard let dbConnection = dbConnection else {
            print("Database connection not available")
            return
        }
        
        do {
              try dbConnection.transaction {
                  let deleteMovement = movementsTable.filter(id == movement.id)
                  if try dbConnection.run(deleteMovement.delete()) > 0 {
                      print("Movement deleted successfully")
                  } else {
                      print("Movement not found")
                  }
                  SavedMovements.shared.fetchMovements()
              }
          } catch let error {
              print("Error deleting movement: \(error)")
          }
    }
    
    func saveWorkout(workout: Workout) {
        guard let dbConnection = dbConnection else {
            print("Database connection not available")
            return
        }
        
        do {
            try dbConnection.transaction {
                // Check if workout is in db
                let query = workoutsTable.filter(workoutID == workout.id)
                print("Workout.id compared to actual value")
                print("86F492E6-71A6-4FC7-A4C2-7218B63B4453 = \(workout.id)")
                if let _ = try dbConnection.pluck(query) {
                    print("Workout Exists")
                    
                    // Update existing workout information
                    print(workout.name)
                    let updateWorkoutInformation = workoutsTable.update(
                        workoutID <- workout.id,
                        workoutName <- workout.name,
                        workoutStartTime <- workout.startTime.timeIntervalSince1970,
                        workoutEndTime <- workout.endTime.timeIntervalSince1970,
                        workoutNotes <- workout.notes
                    )
                    
                    // Delete existing workout sets to add new ones
                    let deleteWorkoutSets = workoutMovementsSetsTable.filter(wmWorkoutID == workout.id)
                    
                    try dbConnection.run(updateWorkoutInformation)
                    try dbConnection.run(deleteWorkoutSets.delete())
                    
                    // Insert new Sets
                    for movement in workout.movements {
                        for (index, set) in movement.sets.enumerated() {
                            let insertSet = workoutMovementsSetsTable.insert(
                                wmWorkoutID <- workout.id,
                                movementID <- movement.id,
                                setNumber <- index + 1,
                                weight <- Double(set.weight) ?? 0.0,
                                reps <- Int(set.reps) ?? 0,
                                movementNotes <- movement.notes
                            )
                            try dbConnection.run(insertSet)
                        }
                    }
                    print("Workout Updated Successfully")
                } else {
                    // Insert new workout
                    let insertWorkout = workoutsTable.insert(
                        workoutID <- workout.id,
                        workoutName <- workout.name,
                        workoutStartTime <- workout.startTime.timeIntervalSince1970,
                        workoutEndTime <- workout.endTime.timeIntervalSince1970,
                        workoutNotes <- workout.notes
                    )
                    try dbConnection.run(insertWorkout)
                    
                    // Insert new sets
                    for movement in workout.movements {
                        for (index, set) in movement.sets.enumerated() {
                            let insertSet = workoutMovementsSetsTable.insert(
                                wmWorkoutID <- workout.id,
                                movementID <- movement.id,
                                setNumber <- index + 1,
                                weight <- Double(set.weight) ?? 0.0,
                                reps <- Int(set.reps) ?? 0,
                                movementNotes <- movement.notes
                            )
                            try dbConnection.run(insertSet)
                        }
                    }
                }
            }
            print("Workout saved successfully")
            WorkoutHistoryViewViewModel.shared.fetchWorkouts()
        } catch let error {
            print("Failed to save workout: \(error)")
        }
    }
    
    func deleteWorkout(workout: Workout) -> Bool {
        guard let dbConnection = dbConnection else {
            print("Database connection not available")
            return false
        }
        
        do {
            try dbConnection.transaction {
                let deleteWorkout = workoutsTable.filter(workoutID == workout.id)
                let deleteWorkoutSets = workoutMovementsSetsTable.filter(wmWorkoutID == workout.id)
                try dbConnection.run(deleteWorkout.delete())
                try dbConnection.run(deleteWorkoutSets.delete())
            }
            print("Workout Deleted Successfully")
            return true
        } catch let error {
            print("Failed to delete workout: \(error)")
        }
        
        return false
    }
    
    
    
    
    func fetchLastSet(movementID: String, setNumber: Int) -> WorkoutMovementSet? {
        guard let dbConnection = dbConnection else {
            print("Database connection not available")
            return nil
        }
        
        print("Looking for set with movementID: \(movementID) and set number \(setNumber)")
        
        do {
            let query = workoutMovementsSetsTable
                .filter(self.movementID == movementID && self.setNumber == setNumber)
                .order(self.setID.desc)
                .limit(1)
            
            if let setRow = try dbConnection.pluck(query) {
                let weightValue = setRow[weight]
                let repsValue = setRow[reps]
                
                print("Found set!")
                print("Weight: \(weightValue)")
                print("Reps: \(repsValue)")
                return WorkoutMovementSet(weight: String(weightValue), reps: String(repsValue))
            }
        } catch {
            print("Error fetching the last set: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    
    func fetchMovementNotes(movementID: String) -> String? {
        guard let dbConnection = dbConnection else {
            print("Database connection not available")
            return nil
        }
        
        do {
            let query = workoutMovementsSetsTable
                .filter(self.movementID == movementID)
                .order(self.setID.desc)
                .limit(1)
            
            if let setRow = try dbConnection.pluck(query) {
                print("Movement notes Found: \(setRow[movementNotes])")
                if setRow[movementNotes].isEmpty {
                    return nil
                } else {
                    return setRow[movementNotes]
                }
                
            } else {
                print("No records found for movementID \(movementID)")
            }
        } catch {
            print("Error fetching Movement Notes: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    
    
    func getMostPastDate() -> Int {
        guard let dbConnection = dbConnection else {
            print("Database connection not available")
            return 0
        }
        
        do {
            // Fetch the earliest start time from the workouts table
            let query = workoutsTable.select(workoutStartTime.min)
            if let row = try dbConnection.pluck(query) {
                if let minStartTime = row[workoutStartTime.min] {
                    let date = Date(timeIntervalSince1970: minStartTime)
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.year], from: date)
                    return components.year ?? 0
                }
            }
        } catch {
            print("Error fetching the most past date: \(error.localizedDescription)")
        }
        
        return 0
    }
    
    
    func updateWorkoutInformation() {
        guard let dbConnection = dbConnection else {
            print("Database connection not available")
            return
        }
        do {
            try dbConnection.transaction {
                let query = workoutsTable.filter(workoutID == "86F492E6-71A6-4FC7-A4C2-7218B63B4453")
                if let _ = try dbConnection.pluck(query) {
                    print("Workout Exists")
                    // Delete existing workout
                    
                    let updateWorkoutInformation = workoutsTable.update(
                        workoutID <- "86F492E6-71A6-4FC7-A4C2-7218B63B4453",
                        workoutName <- "BItch motherfucker",
                        workoutStartTime <- Date().timeIntervalSince1970,
                        workoutEndTime <- Date().timeIntervalSince1970,
                        workoutNotes <- "Fuck this shit"
                    )
                    
                    try dbConnection.run(updateWorkoutInformation)
                }
            }
        } catch {
            print("Error updating workout: \(error.localizedDescription)")
        }
    }
    
    
    func saveWorkoutRoutine(workout: SavedWorkout) {
        guard let dbConnection = dbConnection else {
            print("Database connection not available")
            return
        }
        
        do {
            try dbConnection.transaction {
                let query = savedWorkoutRoutinesTable.filter(savedWorkoutRoutineID == workout.id)
                if let _ = try dbConnection.pluck(query) {
                    let updateSavedWorkoutInformation = savedWorkoutRoutinesTable.update(
                        savedWorkoutRoutineID <- workout.id,
                        savedWorkoutRoutineName <- workout.name
                    )
                    
                    let deleteSavedWorkoutRoutineMovements = savedWorkoutRoutineMovementsTable.filter(swRoutineID == workout.id)
                    
                    
                    try dbConnection.run(updateSavedWorkoutInformation)
                    try dbConnection.run(deleteSavedWorkoutRoutineMovements.delete())
                    
                    for movement in workout.movements {
                        let insertMovement = savedWorkoutRoutineMovementsTable.insert(
                            swRoutineID <- workout.id,
                            swMovementID <- movement.id,
                            sets <- movement.sets.count
                        )
                        try dbConnection.run(insertMovement)
                    }
                    
                    print("Saved Workout Routine Updated Successfully")
                } else {
                    let insertSavedWorkoutRoutine = savedWorkoutRoutinesTable.insert(
                        savedWorkoutRoutineID <- workout.id,
                        savedWorkoutRoutineName <- workout.name
                    )
                    try dbConnection.run(insertSavedWorkoutRoutine)
                    
                    for movement in workout.movements {
                        let insertMovement = savedWorkoutRoutineMovementsTable.insert(
                            swRoutineID <- workout.id,
                            swMovementID <- movement.id,
                            sets <- movement.sets.count
                        )
                        try dbConnection.run(insertMovement)
                    }
                    
                }
                
            }
            print("Workout Routine Saved Successfully")
            SavedWorkoutRoutines.shared.fetchWorkouts()
        } catch let error {
            print("Failed to save workout: \(error)")
        }
    }
    
    
    func fetchWorkoutRoutines() -> [SavedWorkout] {
        var workouts = [SavedWorkout]()
        guard let dbConnection = dbConnection else {
            return workouts
        }
        
        do {
            for workoutRow in try dbConnection.prepare(savedWorkoutRoutinesTable) {
                let savedWorkoutRoutineIDValue = workoutRow[savedWorkoutRoutineID]
                let savedWorkoutRoutineNameValue = workoutRow[savedWorkoutRoutineName]
                
                var movements = [WorkoutMovement]()
                let movementsQuery = savedWorkoutRoutineMovementsTable.filter(swRoutineID == savedWorkoutRoutineIDValue)
                
                for movementRow in try dbConnection.prepare(movementsQuery) {
                    let swMovementIDValue = movementRow[swMovementID]
                    let setsValue = movementRow[sets]
                    
                    if let movementRow = try dbConnection.pluck(movementsTable.filter(movementID == swMovementIDValue)) {
                        let movement = WorkoutMovement(
                            id: swMovementIDValue,
                            name: movementRow[name],
                            type: movementRow[type],
                            bodyPart: movementRow[bodyPart],
                            sets: Array(repeating: WorkoutMovementSet(weight: "", reps: ""), count: setsValue), // Placeholder sets
                            notes: ""
                        )
                        movements.append(movement)
                    }
                }
                
                let workout = SavedWorkout(
                    id: savedWorkoutRoutineIDValue,
                    name: savedWorkoutRoutineNameValue,
                    movements: movements
                )
                workouts.append(workout)
            }
        } catch {
            print("Error fetching workout routines: \(error.localizedDescription)")
        }
        return workouts
    }
    
    
    func fetchBadges() -> [Badge] {
        var badges = [Badge]()
        guard let dbConnection = dbConnection else {
            return badges
        }
        
        do {
            for badgeRow in try dbConnection.prepare(badgesTable) {
                let badge = Badge(
                    id: badgeRow[badgeID],
                    name: badgeRow[badgeName],
                    type: badgeRow[badgeType],
                    description: badgeRow[badgeDescription],
                    image: badgeRow[badgeImage],
                    achieved: (badgeRow[badgeAchieved] as NSString).boolValue
                )
                badges.append(badge)
            }
        } catch {
            print("Error fetching badges: \(error.localizedDescription)")
        }
        return badges
    }
    
    func fetchTotalSetsPerBodyPart() -> [String: Int] {
        var setsPerBodyPart = [String: Int]()
        
        guard let dbConnection = dbConnection else {
            return setsPerBodyPart
        }
        
        do {
            // Join WorkoutMovementsSets and Movements tables to get sets and corresponding body parts
            let query = workoutMovementsSetsTable
                .join(movementsTable, on: workoutMovementsSetsTable[movementID] == movementsTable[id])
            
            // Iterate through the query results
            for row in try dbConnection.prepare(query) {
                let bodyPartValue = row[movementsTable[bodyPart]]
                
                // Add to dictionary, summing the sets for each body part
                setsPerBodyPart[bodyPartValue, default: 0] += 1
            }
        } catch {
            print("Error fetching total sets per body part: \(error.localizedDescription)")
        }
        
        return setsPerBodyPart
    }
    
    func calculateMovementStats(for movementID: String) -> [MovementStats] {
        var movementStats = [MovementStats]()

        guard let dbConnection = dbConnection else {
            print("Database connection not available")
            return movementStats
        }

        do {
            // Get all entries for the specific movement from WorkoutMovementsSets
            let setsQuery = workoutMovementsSetsTable.filter(self.movementID == movementID)

            var statsByDate = [Date: (oneRepMax: Double, maxReps: Int, setCount: Int)]()
            
            for setRow in try dbConnection.prepare(setsQuery) {
                // Get the workout date from the Workout table
                if let workoutRow = try dbConnection.pluck(workoutsTable.filter(workoutID == setRow[wmWorkoutID])) {
                    let workoutDate = Date(timeIntervalSince1970: workoutRow[workoutStartTime])

                    let weight = setRow[weight]
                    let reps = setRow[reps]
                    let setOneRepMax = weight * (1 + Double(reps) / 30.0)
                    
                    // Get or initialize the stats for this date
                    if var stats = statsByDate[workoutDate] {
                        // Update stats for this date
                        stats.oneRepMax = max(stats.oneRepMax, setOneRepMax)
                        stats.maxReps = max(stats.maxReps, reps)
                        stats.setCount += 1
                        statsByDate[workoutDate] = stats
                    } else {
                        // Create new stats entry for this date
                        statsByDate[workoutDate] = (oneRepMax: setOneRepMax, maxReps: reps, setCount: 1)
                    }
                }
            }

            // Convert statsByDate dictionary to an array of MovementStats objects
            for (date, stats) in statsByDate {
                let movementStat = MovementStats(date: date, oneRepMax: stats.oneRepMax, maxReps: stats.maxReps, setCount: stats.setCount)
                movementStats.append(movementStat)
            }

        } catch {
            print("Error calculating movement stats: \(error.localizedDescription)")
        }

        return movementStats.sorted(by: {$0.date < $1.date})
    }
}



