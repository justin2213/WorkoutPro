//
//  Badge.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 8/7/24.
//

import Foundation

class Badge: Identifiable {
    @Published var id: String
    @Published var name: String
    @Published var type: String
    @Published var description: String
    @Published var image: String
    @Published var achieved: Bool
    
    init(id: String, name: String, type: String, description: String, image: String, achieved: Bool) {
        self.id = id
        self.name = name
        self.type = type
        self.description = description
        self.image = image
        self.achieved = achieved
    }
}
