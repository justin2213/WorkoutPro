//
//  MovementSpecificStatsViewViewModel.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 9/24/24.
//

import Foundation

class MovementSpecificStatsViewViewModel: ObservableObject {
    @Published var movementStats: [MovementStats] = []
    @Published var movement: Movement
    init(movement: Movement){
        self.movement = movement
        self.movementStats = DatabaseManager.shared.calculateMovementStats(for: movement.id)
    }
}
