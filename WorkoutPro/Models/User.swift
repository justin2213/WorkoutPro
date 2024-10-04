//
//  User.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 6/4/24.
//

import Foundation

class User: ObservableObject {
    static let shared = User() // Singleton instance
    
    @Published var name: String = ""
    @Published var height: Int = 0
    @Published var weight: Int = 0
    @Published var gender: String = ""
    @Published var birthday: Date = Date()
    
    private init() {
        loadUserData()
    }
    
    func loadUserData() {
        if let nameData = UserDefaults.standard.data(forKey: "name") {
            do {
                let decoder = JSONDecoder()
                self.name = try decoder.decode(String.self, from: nameData)
            } catch {
                print("Failed to decode name: \(error)")
            }
        }
        
        if let heightData = UserDefaults.standard.data(forKey: "height") {
            do {
                let decoder = JSONDecoder()
                self.height = try decoder.decode(Int.self, from: heightData)
            } catch {
                print("Failed to decode height: \(error)")
            }
        }
        
        if let weightData = UserDefaults.standard.data(forKey: "weight") {
            do {
                let decoder = JSONDecoder()
                self.weight = try decoder.decode(Int.self, from: weightData)
            } catch {
                print("Failed to decode weight: \(error)")
            }
        }
        
        if let genderData = UserDefaults.standard.data(forKey: "gender") {
            do {
                let decoder = JSONDecoder()
                self.gender = try decoder.decode(String.self, from: genderData)
            } catch {
                print("Failed to decode gender: \(error)")
            }
        }
        
        if let birthdayData = UserDefaults.standard.data(forKey: "birthday") {
            do {
                let decoder = JSONDecoder()
                self.birthday = try decoder.decode(Date.self, from: birthdayData)
            } catch {
                print("Failed to decode birthday: \(error)")
            }
        }
    }
    
    func updateUser(name: String, height: Int, weight: Int, gender: String, birthday: Date) {
        do {
            let encoder = JSONEncoder()
            let nameData = try encoder.encode(name)
            UserDefaults.standard.set(nameData, forKey: "name")
            self.name = name
            
            let heightData = try encoder.encode(height)
            UserDefaults.standard.set(heightData, forKey: "height")
            self.height = height
            
            let weightData = try encoder.encode(weight)
            UserDefaults.standard.set(weightData, forKey: "weight")
            self.weight = weight
            
            let genderData = try encoder.encode(gender)
            UserDefaults.standard.set(genderData, forKey: "gender")
            self.gender = gender
            
            let birthdayData = try encoder.encode(birthday)
            UserDefaults.standard.set(birthdayData, forKey: "birthday")
            self.birthday = birthday
            
            print("Updated User")
        } catch {
            print("Failed to encode data: \(error)")
        }
    }
}
