//
//  EditMovementSheet.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 7/3/24.
//

import SwiftUI

struct EditMovementSheet: View {
    @ObservedObject var workout: Workout
    @State var movements: [WorkoutMovement]
    @State private var editMode = EditMode.active
    @Environment(\.presentationMode) var isPresented

    var body: some View {
        NavigationView {
            List {
                ForEach(movements) { movement in
                    Text(movement.name)
                }
                .onDelete(perform: onDelete)
                .onMove(perform: onMove)
            }
            .navigationBarTitle("Movements")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        isPresented.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement:.topBarTrailing) {
                    Button("Done") {
                        workout.movements = movements
                        isPresented.wrappedValue.dismiss()
                    }
                }
            }
            .overlay(
                VStack {
                    Divider()
                        .background(Color.gray)
                        .frame(height: 1)
                    Spacer()
                }
            )
            .environment(\.editMode, $editMode)
        }
    }

    private func onDelete(offsets: IndexSet) {
        movements.remove(atOffsets: offsets)
    }

    private func onMove(source: IndexSet, destination: Int) {
       movements.move(fromOffsets: source, toOffset: destination)
    }

}

#Preview {
    EditMovementSheet(workout: Workout(id: UUID().uuidString, name: "Chest workout", startTime: Date(), endTime: Date(), notes: "", movements: [
        WorkoutMovement(id: UUID().uuidString, name: "Bench Press", type: "Weight", bodyPart: "Chest", sets: [WorkoutMovementSet(weight: "", reps: "")], notes: ""),
        WorkoutMovement(id: UUID().uuidString, name: "Incline Dumbbell Press", type: "Weight", bodyPart: "Chest", sets: [WorkoutMovementSet(weight: "", reps: "")], notes: ""),
        WorkoutMovement(id: UUID().uuidString, name: "Lat Pulldown", type: "Weight", bodyPart: "Back", sets: [WorkoutMovementSet(weight: "", reps: "")], notes: ""),
        WorkoutMovement(id: UUID().uuidString, name: "Deadlift", type: "Weight", bodyPart: "Back", sets: [WorkoutMovementSet(weight: "", reps: "")], notes: ""),
        WorkoutMovement(id: UUID().uuidString, name: "Row", type: "Weight", bodyPart: "Back", sets: [WorkoutMovementSet(weight: "", reps: "")], notes: "")
    ]), movements: [
        WorkoutMovement(id: UUID().uuidString, name: "Bench Press", type: "Weight", bodyPart: "Chest", sets: [WorkoutMovementSet(weight: "", reps: "")], notes: ""),
        WorkoutMovement(id: UUID().uuidString, name: "Incline Dumbbell Press", type: "Weight", bodyPart: "Chest", sets: [WorkoutMovementSet(weight: "", reps: "")], notes: ""),
        WorkoutMovement(id: UUID().uuidString, name: "Lat Pulldown", type: "Weight", bodyPart: "Back", sets: [WorkoutMovementSet(weight: "", reps: "")], notes: ""),
        WorkoutMovement(id: UUID().uuidString, name: "Deadlift", type: "Weight", bodyPart: "Back", sets: [WorkoutMovementSet(weight: "", reps: "")], notes: ""),
        WorkoutMovement(id: UUID().uuidString, name: "Row", type: "Weight", bodyPart: "Back", sets: [WorkoutMovementSet(weight: "", reps: "")], notes: "")
    ])
}
