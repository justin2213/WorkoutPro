//
//  SavedWorkoutRoutineSelectorView.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 9/1/24.
//

import SwiftUI

struct SavedWorkoutRoutineSelectorView: View {
    @ObservedObject var savedWorkouts = SavedWorkoutRoutines.shared
    @Environment(\.presentationMode) var isPresented
    let workoutAction: (SavedWorkout) -> Void
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(savedWorkouts.workouts.indices, id: \.self) { workoutIndex in
                        Button {
                            isPresented.wrappedValue.dismiss()
                            workoutAction(savedWorkouts.workouts[workoutIndex])
                        } label: {
                            SavedWorkoutRoutineInformationView(workout: savedWorkouts.workouts[workoutIndex])
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Workout Routines")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        isPresented.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        CreateWorkoutView(workout: SavedWorkout())
                    } label: {
                        Image(systemName: "plus")
                    }
                    
                }
            }
        }
    }
}

#Preview {
    SavedWorkoutRoutineSelectorView(workoutAction: { _ in })
}
