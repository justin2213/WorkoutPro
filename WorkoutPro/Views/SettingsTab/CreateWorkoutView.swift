//
//  CreateWorkoutView.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 7/28/24.
//

import SwiftUI

struct CreateWorkoutView: View {
    @StateObject var workout: SavedWorkout
    @State var originalWorkout: SavedWorkout?
    @StateObject var viewModel = CreateWorkoutViewViewModel()
    @Environment(\.presentationMode) var isPresented
    @State var header: String
    @FocusState var focusedInput: Field?

    enum Field: Int, Hashable, CaseIterable {
        case name
    }

    init(header: String = "Create Workout", workout: SavedWorkout, originalWorkout: SavedWorkout? = nil) {
        _workout = StateObject(wrappedValue: workout)
        _originalWorkout = State(wrappedValue: originalWorkout)
        _header = State(initialValue: header)
    }

    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("Workout Name", text: $workout.name)
                        .focused($focusedInput, equals: .name)
                    if viewModel.errorMessage == "Workout must have a name!" {
                        HStack {
                            Image(systemName: "exclamationmark.circle")
                            Text(viewModel.errorMessage)
                        }
                        .foregroundStyle(Color.red)
                    }
                }

                Section {
                    if workout.movements.isEmpty {
                        ZStack {
                            RoundedRectangle(cornerRadius: 0)
                                .foregroundStyle(.clear)
                            Text("No Movements Added. Please add a movement")
                                .listRowBackground(Color.clear)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Color.gray)
                        }
                        .listRowBackground(Color.clear)
                    }
                    ForEach(workout.movements.indices, id: \.self) { movementIndex in
                        CreateWorkoutMovementView(movement: workout.movements[movementIndex], removeMovement: { workout.movements.remove(at: movementIndex) })
                    }
                } header: {
                    Text("Movements")
                        .textCase(.none)
                        .font(.title)
                        .bold()
                        .foregroundStyle(.foreground)
                }

                Section {
                    ZStack {
                        RoundedRectangle(cornerSize: .zero)
                            .foregroundStyle(.clear)
                        Button("Add Movement") {
                            viewModel.isSelectingMovement.toggle()
                        }
                    }
                }

            }
        }
        .formKeyboardStyle(focusedInput: $focusedInput)
        .navigationTitle("Create Workout")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden()
        .fullScreenCover(isPresented: $viewModel.isSelectingMovement) {
            NavigationView {
                MovementSelectorView(exerciseAction: workout.addMovement)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    if viewModel.saveWorkout(workout: workout) {
                        isPresented.wrappedValue.dismiss()
                    }
                }
            }

            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    if let originalWorkout = originalWorkout {
                        // Revert changes by copying originalWorkout data back into workout
                        workout.name = originalWorkout.name
                        workout.movements = originalWorkout.movements
                    }
                    isPresented.wrappedValue.dismiss()
                }
            }
        }
        .actionSheet(isPresented: $viewModel.showActionSheet) {
            ActionSheet(
                title: Text("Warning"),
                message: Text(viewModel.errorMessage),
                buttons: [
                    .default(Text("Continue Editing")) {},
                    .destructive(Text("Cancel")) {
                        if let originalWorkout = originalWorkout {
                            // Revert changes by copying originalWorkout data back into workout
                            workout.name = originalWorkout.name
                            workout.movements = originalWorkout.movements
                        }
                        isPresented.wrappedValue.dismiss()
                    }
                ]
            )
        }
    }
}

struct CreateWorkoutMovementView: View {
    @ObservedObject var movement: WorkoutMovement
    let removeMovement: () -> Void

    var body: some View {
        Stepper(
            onIncrement: {
                withAnimation {
                    movement.addSet()
                    print(movement.sets.count)
                }
            },
            onDecrement: {
                withAnimation {
                    if !movement.removeSet() {
                        removeMovement()
                    }
                    print(movement.sets.count)
                }
            },
            label: {
                Text("\(movement.sets.count) x \(movement.name)")
            }
        )
        .swipeActions {
            Button("Delete") {
                withAnimation {
                    removeMovement()
                }
            }
            .tint(.red)
        }
    }
}


#Preview {
    CreateWorkoutView( workout: SavedWorkout())
}
