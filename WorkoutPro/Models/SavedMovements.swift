//
//  SavedMovements.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 6/6/24.
//

import Foundation

class SavedMovements: ObservableObject {
    static let shared = SavedMovements() // Singleton instance
    
    @Published var movements: [Movement]
    
    private init() {
        movements = DatabaseManager.shared.fetchMovements()
    }
    
    func fetchMovements() {
        self.movements = DatabaseManager.shared.fetchMovements()
    }
}
