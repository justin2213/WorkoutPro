//
//  MovementCategoryViewViewModel.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 9/17/24.
//

import Foundation

class MovementCategoryViewViewModel: ObservableObject {
    
    @Published var movementCategoryData: [String: Int]
    
    init() {
        self.movementCategoryData = DatabaseManager.shared.fetchTotalSetsPerBodyPart()
    }
    
    func mostSetsCategory() -> (String, Int)? {
        guard !movementCategoryData.isEmpty else {
            return nil // Return nil if there are no categories
        }
        
        // Find the category with the maximum number of sets
        let mostSets = movementCategoryData.max { a, b in a.value < b.value }
    
        // Return the result as a tuple
        return mostSets
    }
    
    var totalSets: Int {
        return movementCategoryData.values.reduce(0, +)
    }
    
    var mostSetsCategoryPercentage: String? {
        guard let bestCategory = mostSetsCategory() else { return nil }
        
        let percentage = Double(bestCategory.1) / Double(totalSets)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        
        guard let formattedPercentage = numberFormatter.string(from: NSNumber(value: percentage)) else {
            return nil
        }
        
        return formattedPercentage
    }
}
