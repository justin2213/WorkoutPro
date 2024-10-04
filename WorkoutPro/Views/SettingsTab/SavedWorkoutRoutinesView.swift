//
//  SavedWorkoutRoutinesView.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 7/29/24.
//

import SwiftUI

struct SavedWorkoutRoutinesView: View {
    @ObservedObject var savedWorkouts = SavedWorkoutRoutines.shared
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(savedWorkouts.workouts.indices, id: \.self) { workoutIndex in
                    NavigationLink {
                        CreateWorkoutView(header: "Edit Workout", workout: savedWorkouts.workouts[workoutIndex], originalWorkout: savedWorkouts.workouts[workoutIndex].copy() as? SavedWorkout)
                        
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

struct SavedWorkoutRoutineInformationView: View {
    @StateObject var workout: SavedWorkout
    var body: some View {
            Group {
                HStack(spacing:0) {
                    VStack(alignment: .leading) {
                        Text(workout.name)
                            .font(.title)
                        Spacer()
                        ForEach(workout.movements.indices, id: \.self) { movementIndex in
                            Text(String(workout.movements[movementIndex].sets.count) + " x " + workout.movements[movementIndex].name)
                        }
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .foregroundStyle(Color.primary)
                .padding(.horizontal, 10)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(8)
            .padding(.vertical, 4)
            .padding(.horizontal, 15.0)
    }
}

#Preview {
    SavedWorkoutRoutinesView()
}
