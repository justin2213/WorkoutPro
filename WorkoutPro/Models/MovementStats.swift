//
//  MovementStats.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 9/22/24.
//

import Foundation

struct MovementStats: Identifiable {
    let id = UUID().uuidString
    let date: Date
    let oneRepMax: Double
    let maxReps: Int
    let setCount: Int
}
