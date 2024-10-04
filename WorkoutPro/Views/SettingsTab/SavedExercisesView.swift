//
//  SavedExercisesView.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 6/5/24.
//

import SwiftUI

struct SavedExercisesView: View {
    @ObservedObject var savedMovements = SavedMovements.shared
    
    var body: some View {
        VStack {
            List {
                NavigationLink("Chest", destination: FilteredExercisesView(movements: $savedMovements.movements, bodyPart: "Chest"))
                NavigationLink("Back", destination: FilteredExercisesView(movements: $savedMovements.movements, bodyPart: "Back"))
                NavigationLink("Shoulders", destination: FilteredExercisesView(movements: $savedMovements.movements, bodyPart: "Shoulders"))
                NavigationLink("Biceps", destination: FilteredExercisesView(movements: $savedMovements.movements, bodyPart: "Biceps"))
                NavigationLink("Triceps", destination: FilteredExercisesView(movements: $savedMovements.movements, bodyPart: "Triceps"))
                NavigationLink("Legs", destination: FilteredExercisesView(movements: $savedMovements.movements, bodyPart: "Legs"))
                // Add more categories as needed
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("Categories")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    CreateMovementView(movement: Movement(id: UUID().uuidString, name: "", type: "", bodyPart: ""))
                } label: {
                    Image(systemName: "plus")
                }

            }
        }
    }
}

struct FilteredExercisesView: View {
    @Binding var movements: [Movement]
    @State var bodyPart: String
    
    var body: some View {
        VStack {
            List {
                ForEach(movements.indices.filter { movements[$0].bodyPart == bodyPart }, id: \.self) { index in
                    NavigationLink(movements[index].name, destination: CreateMovementView(header: "Edit Movement", movement: movements[index]))
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle(bodyPart)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    CreateMovementView(movement: Movement(id: UUID().uuidString, name: "", type: "", bodyPart: bodyPart))
                } label: {
                    Image(systemName: "plus")
                }

            }
        }

    }
}
    

#Preview {
    SavedExercisesView()
}
