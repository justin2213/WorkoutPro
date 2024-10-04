//
//  RegisterViewViewModel.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 6/5/24.
//

import Foundation

class RegisterViewViewModel: ObservableObject {
    @Published var name = ""
    @Published var height = ""
    @Published var weight = ""
    @Published var gender = ""
    @Published var birthday = Date()
    @Published var errorMessage = ""
    @Published var activeSheet: ActiveSheet?
    
    enum ActiveSheet: Identifiable {
        case heightSelector
        case weightSelector
        case genderSelector
        case birthdaySelector
        
        var id: Int {
            hashValue
        }
    }
    
    init() {}
    
    func createUser() {
        
        guard validate() else {
            return
        }
        
        User.shared.updateUser(name: name, height: height.convertHeightToInches(), weight: Int(weight) ?? 0, gender: gender, birthday: birthday)
    }
    
    func setHeight(height: String) {
        self.height = height
    }
    
    func setWeight(weight: String) {
        self.weight = weight
    }
    
    func setGender(gender: String) {
        self.gender = gender
    }
    
    func setBirthday(birthday: Date) {
        self.birthday = birthday
    }
    
    func validate() -> Bool {
        errorMessage = ""
        
        guard !name.isEmpty else {
            errorMessage = "You must enter your name to continue"
            return false
        }
        
        guard !height.isEmpty else {
            errorMessage = "You must enter your height to continue"
            return false
        }
        
        guard !weight.isEmpty else {
            errorMessage = "You must enter your weight to continue"
            return false
        }
        
        guard !gender.isEmpty else {
            errorMessage = "You must select a gender to continue"
            return false
        }
        
        guard let tenYearsAgo = Calendar.current.date(byAdding: .year, value: -10, to: Date()) else {
           return false
        }
           
       guard birthday <= tenYearsAgo else {
           errorMessage = "You must be at least 10 years old to continue"
           return false
       }
        
        
        
        return true
    }
    
}

