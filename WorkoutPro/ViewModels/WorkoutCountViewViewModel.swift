//
//  WorkoutCountViewViewModel.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 9/14/24.
//

import Foundation

class WorkoutCountViewViewModel: ObservableObject {
    @Published var workouts = WorkoutHistoryViewViewModel.shared.workouts
    
    init() {}
    
    var workoutsByWeek: [(date: Date, workoutCount: Int)] {
        let workoutsByWeek = workoutsGroupedByWeek(workouts: workouts)
        return totalWorkoutsPerDate(workoutsByDate: workoutsByWeek)
    }

    var workoutsByMonth: [(date: Date, workoutCount: Int)] {
        let workoutsByMonth = workoutsGroupedByMonth(workouts: workouts)
        return totalWorkoutsPerDate(workoutsByDate: workoutsByMonth)
    }
    
    var workoutsByYear: [(date: Date, workoutCount: Int)] {
           let workoutsByYear = workoutsGroupedByYear(workouts: workouts)
           return totalWorkoutsPerDate(workoutsByDate: workoutsByYear)
       }

    func workoutsGroupedByWeek(workouts: [Workout]) -> [Date: [Workout]] {
        var workoutsByWeek: [Date: [Workout]] = [:]
        
        let calendar = Calendar.current
        for workout in workouts {
            // Find the start of the week for the workout startTime
            guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: workout.startTime)) else { continue }
            if workoutsByWeek[startOfWeek] != nil {
                workoutsByWeek[startOfWeek]!.append(workout)
            } else {
                workoutsByWeek[startOfWeek] = [workout]
            }
        }
        
        return workoutsByWeek
    }

    func workoutsGroupedByMonth(workouts: [Workout]) -> [Date: [Workout]] {
        var workoutsByMonth: [Date: [Workout]] = [:]
        
        let calendar = Calendar.current
        for workout in workouts {
            // Find the start of the month for the workout startTime
            guard let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: workout.startTime)) else { continue }
            if workoutsByMonth[startOfMonth] != nil {
                workoutsByMonth[startOfMonth]!.append(workout)
            } else {
                workoutsByMonth[startOfMonth] = [workout]
            }
        }
        
        return workoutsByMonth
    }
    
    func workoutsGroupedByYear(workouts: [Workout]) -> [Date: [Workout]] {
        var workoutsByYear: [Date: [Workout]] = [:]
        
        let calendar = Calendar.current
        for workout in workouts {
            // Find the start of the year for the workout startTime
            guard let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: workout.startTime)) else { continue }
            if workoutsByYear[startOfYear] != nil {
                workoutsByYear[startOfYear]!.append(workout)
            } else {
                workoutsByYear[startOfYear] = [workout]
            }
        }
        
        return workoutsByYear
    }

    func totalWorkoutsPerDate(workoutsByDate: [Date: [Workout]]) -> [(date: Date, workoutCount: Int)] {
        var totalWorkouts: [(date: Date, workoutCount: Int)] = []
        
        for (date, workouts) in workoutsByDate {
            let workoutCountForDate = workouts.count
            totalWorkouts.append((date: date, workoutCount: workoutCountForDate))
        }
        
        return totalWorkouts
    }
    
    func percentageChangeLast3Months() -> Double? {
        let months = workoutsByMonth.sorted(by: { $0.date > $1.date }) // Sort in descending order
        
        guard months.count >= 6 else {
            return nil
        }
        
        let last3Months = months.prefix(3)
        let previous3Months = months.dropFirst(3).prefix(3)
        
        let last3Total = last3Months.reduce(0) { $0 + $1.workoutCount }
        let previous3Total = previous3Months.reduce(0) { $0 + $1.workoutCount }
        
        guard previous3Total > 0 else {
            return nil
        }
        
        let percentageChange = Double(last3Total) / Double(previous3Total) - 1.0
        
        
        if abs(percentageChange) < 0.1 {
            return 0
        } else {
            return percentageChange
        }
    }
}
