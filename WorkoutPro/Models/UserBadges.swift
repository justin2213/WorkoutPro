//
//  UserBadges.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 8/8/24.
//

import Foundation

class UserBadges: ObservableObject {
    static let shared = UserBadges() // Singleton instance
    
    @Published var badges: [Badge]
    
    private init() {
        self.badges = DatabaseManager.shared.fetchBadges()
    }
    
    func fetchBadges() {
        self.badges = DatabaseManager.shared.fetchBadges()
    }
}
