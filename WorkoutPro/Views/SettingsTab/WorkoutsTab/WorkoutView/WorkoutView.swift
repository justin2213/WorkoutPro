//
//  SwiftUIView2.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 8/26/24.
//

import SwiftUI


import SwiftUI

struct WorkoutView: View {
    @StateObject var workout: Workout = Workout()
    @StateObject var viewModel: WorkoutViewViewModel = WorkoutViewViewModel()
    @Environment(\.presentationMode) var isPresented
    @FocusState private var focusedField: FieldFocus? // State to manage the currently focused field
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { scrollViewProxy in
                Form {
                    header
                    ForEach(workout.movements.indices, id: \.self) { movementIndex in
                        
                        MovementView(
                            movement: workout.movements[movementIndex],
                            focusedField: $focusedField,
                            movementIndex: movementIndex,
                            showEditMovementSheet: { viewModel.activeSheet = .editMovementSheet },
                            deleteMovement: {
                                withAnimation(.easeInOut) {
                                    workout.removeMovement(movement: workout.movements[movementIndex])
                                }
                            },
                            showMovementSelectorSheet: { viewModel.activeSheet = .movementSelector },
                            setMovementAction: viewModel.setMovementAction // Pass the focused field binding
                        )
                        .transition(.move(edge: .trailing))
                        .id(FieldFocus.weight(movementIndex: movementIndex, setIndex: 0)) // Unique identifier for scrolling
                    }
                    
                    Section {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10.0)
                                .foregroundStyle(.clear)
                            Button("Add Movement") {
                                viewModel.setMovementAction(movementAction: workout.addMovement)
                                viewModel.activeSheet = .movementSelector
                            }
                        }
                    }
                }
                .workoutKeyboardStyle(focusedInput: $focusedField, values: FieldFocus.allCases(for: workout.movements))
                .navigationTitle(viewModel.title)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(workout.startTime.formattedMonthDay())
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Save") {
                            if viewModel.saveWorkout(workout: workout) {
                                isPresented.wrappedValue.dismiss()
                            }
                        }
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            if viewModel.cancelWorkout(workout: workout) {
                                isPresented.wrappedValue.dismiss()
                            }
                        }
                    }
                }
                .sheet(item: $viewModel.activeSheet) { sheet in
                    switch sheet {
                    case .endTimeSelector:
                        EndTimeSelectorView(endTime: workout.endTime, startTime: workout.startTime, setTime: workout.setEndTime)
                            .presentationDetents([.fraction(0.4)])
                    case .startTimeSelector:
                        StartTimeSelectorView(endTime: workout.endTime, startTime: workout.startTime, setTime: workout.setStartTime)
                            .presentationDetents([.fraction(0.4)])
                    case .editMovementSheet:
                        EditMovementSheet(workout: workout, movements: workout.movements)
                    case .movementSelector:
                        NavigationView {
                            MovementSelectorView(exerciseAction: viewModel.getMovementAction())
                        }
                    }
                }
                .actionSheet(item: $viewModel.activeAlert) { alert in
                    switch alert {
                    case .exitWorkout:
                        ActionSheet(
                            title: Text("Warning"),
                            message: Text(viewModel.cancelAlertMessage),
                            buttons: [
                                .default(Text("Save")) {
                                    if viewModel.saveWorkout(workout: workout) {
                                        isPresented.wrappedValue.dismiss()
                                    }
                                },
                                .destructive(Text("Exit")) {
                                    isPresented.wrappedValue.dismiss()
                                },
                                .cancel()
                            ]
                        )
                        
                    case .saveWorkout:
                        ActionSheet(
                            title: Text("Warning"),
                            message: Text("You have empty sets."),
                            buttons: [
                                .default(Text("Autofill")) {
                                    workout.autofill()
                                    if viewModel.saveWorkout(workout: workout) {
                                        isPresented.wrappedValue.dismiss()
                                    }
                                },
                                .default(Text("Clear and Continue")) {
                                    workout.removeAllEmptySets()
                                    if viewModel.saveWorkout(workout: workout) {
                                        isPresented.wrappedValue.dismiss()
                                    }
                                },
                                .cancel(Text("Cancel"))
                            ]
                        )
                    }
                }
                .onAppear {
                    if viewModel.originalWorkout == nil {
                        workout.startTimer()
                        if workout.movements.isEmpty {
                            viewModel.setMovementAction(movementAction: workout.addMovement)
                            viewModel.activeSheet = .movementSelector
                        }
                    }
                }
                .onChange(of: focusedField) { newFocus in
                    if let field = newFocus {
                        withAnimation {
                            scrollViewProxy.scrollTo(field, anchor: .center)
                        }
                    }
                }
            }
        }
    }
    
    var header: some View {
        Section {
            TextField("Name", text: $workout.name)
                .autocorrectionDisabled()
                .keyboardType(.alphabet)
                .focused($focusedField, equals: .workoutName)
                .id(FieldFocus.workoutName) // Unique identifier for scrolling
            HStack {
                Text("Start")
                Spacer()
                Button {
                    viewModel.activeSheet = .startTimeSelector
                } label: {
                    HStack {
                        Text(workout.startTime.formatted())
                        Image(systemName: "chevron.right")
                    }
                }
            }
            .buttonStyle(BorderlessButtonStyle())
            HStack {
                Text("End")
                Spacer()
                Button {
                    viewModel.activeSheet = .endTimeSelector
                } label: {
                    HStack {
                        Text(workout.endTime.formatted())
                        Image(systemName: "chevron.right")
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            NavigationLink("Notes") {
                NotesView(notes: workout.notes, saveNotes: workout.setNotes)
            }
        }
    }
}

struct NotesView: View {
    @State var notes: String
    let saveNotes: (String) -> Void
    @Environment(\.presentationMode) var isPresented
    var body: some View {
        VStack {
            TextEditor(text: $notes)
        }
        .navigationTitle("Notes")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    isPresented.wrappedValue.dismiss()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    saveNotes(notes)
                    isPresented.wrappedValue.dismiss()
                }
            }
        }
        .navigationBarBackButtonHidden()
        .padding()
    }
}

enum FieldFocus: Hashable, RawRepresentable {
    typealias RawValue = Int
    
    case workoutName
    case weight(movementIndex: Int, setIndex: Int)
    case reps(movementIndex: Int, setIndex: Int)
    case notes(movementIndex: Int)
    
    init?(rawValue: Int) {
        // Define base values to ensure unique values for each case
        let baseWeight = 1000
        let baseReps = 2000
        let baseNotes = 3000
        
        // Decode values
        if rawValue == 0 {
            self = .workoutName
        } else if rawValue >= baseWeight && rawValue < baseReps {
            let movementIndex = (rawValue - baseWeight) / 100
            let setIndex = (rawValue - baseWeight) % 100
            self = .weight(movementIndex: movementIndex, setIndex: setIndex)
        } else if rawValue >= baseReps && rawValue < baseNotes {
            let movementIndex = (rawValue - baseReps) / 100
            let setIndex = (rawValue - baseReps) % 100
            self = .reps(movementIndex: movementIndex, setIndex: setIndex)
        } else if rawValue >= baseNotes {
            let movementIndex = (rawValue - baseNotes) / 100
            self = .notes(movementIndex: movementIndex)
        } else {
            return nil
        }
    }
    
    var rawValue: Int {
        // Define base values
        let baseWeight = 1000
        let baseReps = 2000
        let baseNotes = 3000
        
        switch self {
        case .workoutName:
            return 0
        case .weight(let movementIndex, let setIndex):
            return baseWeight + (movementIndex * 100) + setIndex
        case .reps(let movementIndex, let setIndex):
            return baseReps + (movementIndex * 100) + setIndex
        case .notes(let movementIndex):
            return baseNotes + (movementIndex * 100)
        }
    }
}

extension FieldFocus {
    static func allCases(for movements: [WorkoutMovement]) -> [FieldFocus] {
        var cases: [FieldFocus] = []
        
        // Add workoutName as the first field
        cases.append(.workoutName)
        
        // Iterate through movements and sets
        for (movementIndex, movement) in movements.enumerated() {
            for setIndex in 0..<movement.sets.count {
                cases.append(.weight(movementIndex: movementIndex, setIndex: setIndex))
                cases.append(.reps(movementIndex: movementIndex, setIndex: setIndex))
            }
            cases.append(.notes(movementIndex: movementIndex))
        }
        
        return cases
    }
}




#Preview {
    WorkoutView()
}
