//
//  OneRepMaxCalculatorViewViewModel.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 8/7/24.
//

import Foundation

class OneRepMaxCalculatorViewViewModel: ObservableObject {
    @Published var weight: String = ""
    @Published var reps: String = ""
    @Published var oneRepMax: String = ""
    @Published var bodyWeightProportion: Double = 0.0
    @Published var errorMessage: String = ""
    
    init() {}
    
    func calculateOneRepMax() {
        
        guard validate() else {
            return
        }
        
        var value =  (Double(weight) ?? 0.0) * (1 + (0.0333 * (Double(reps) ?? 0.0)))
        value = value.rounded(.down)
        bodyWeightProportion = value / Double(User.shared.weight)
        oneRepMax = String(value) + " lbs"
    }
    
    func validate() -> Bool {
        
        errorMessage = ""
        
        if weight.isEmpty {
            errorMessage = "You must enter a weight."
            return false
        }
        
        if reps.isEmpty {
            errorMessage = "You must enter a rep number."
            return false
        }
        
        return true
        
    }
    
}
