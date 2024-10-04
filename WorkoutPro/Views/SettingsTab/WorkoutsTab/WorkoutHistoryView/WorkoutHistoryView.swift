//
//  TestView.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 7/28/24.
//

import SwiftUI

struct Constants {
    static let padding15: CGFloat = 15.0
}

struct ListHeaderView: View {
    let title: String
    @State private var isPinned: Bool = false

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text(title)
                    .font(.headline)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(isPinned ? Color(UIColor.secondarySystemGroupedBackground) : Color.clear)
                    .background(ignoresSafeAreaEdges: .horizontal)
                    .foregroundColor(Color.primary)
                    .onChange(of: geometry.frame(in: .global).minY) { oldValue, newValue in
                        isPinned = newValue <= 100 // Assuming navigation bar height is 44
                    }
            }
        }
        .frame(height: 30)
    }
}


struct WorkoutHistoryView: View {
    @StateObject var viewModel = WorkoutHistoryViewViewModel.shared
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                    Spacer()
                    // Iterate through years and months, filtering workouts
                    ForEach(viewModel.years.sorted(by: >), id: \.self) { year in
                        ForEach(viewModel.months.indices.sorted(by: >), id: \.self) { monthIndex in
                            let filteredWorkouts = viewModel.filterWorkouts(year: year, month: monthIndex + 1)
                            if !filteredWorkouts.isEmpty {
                                Section {
                                    ForEach(filteredWorkouts, id: \.id) { workout in
                                        HStack {
                                            if viewModel.isEditingWorkouts {
                                                Button {
                                                    withAnimation {
                                                        viewModel.deleteWorkout(workoutID: workout.id)
                                                    }
                                                } label: {
                                                    Image(systemName: "minus.circle.fill")
                                                        .resizable()
                                                        .frame(width: 25, height: 25, alignment: .center)
                                                        .padding(.leading)
                                                        .foregroundStyle(Color.white, Color.red)
                                                }
                                            }
                                            WorkoutHistoryInformationView(workout: workout, isEditing: viewModel.isEditingWorkouts, formatDate: viewModel.formatDuration, setViewedWorkout: viewModel.setOldViewedWorkout)
                                                .padding(.vertical, 8) // Add vertical padding for spacing
                                                .transition(AnyTransition.move(edge: .trailing).combined(with: .opacity)) // Slide off with fade
                                        }
                                    }
                                    .onDelete { indexSet in
                                        withAnimation {
                                            indexSet.forEach { index in
                                                let workout = filteredWorkouts[index]
                                                viewModel.deleteWorkout(workoutID: workout.id)
                                            }
                                        }
                                    }
                                } header: {
                                    ListHeaderView(title: "\(viewModel.months[monthIndex]) \(String(year))")
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchWorkouts()
            }
            .fullScreenCover(item: $viewModel.activeFullScreenCover) { fullScreenCover in
                switch fullScreenCover {
                case .workout:
                    WorkoutView(workout: viewModel.viewedWorkout, viewModel: viewModel.viewedWorkoutViewModel)
                case .routineSelector:
                    SavedWorkoutRoutineSelectorView(workoutAction: viewModel.setRoutineViewedWorkout)
                }
            }
            .navigationTitle("Workout History")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(viewModel.isEditingWorkouts == true ? "Done" : "Edit") {
                        withAnimation {
                            viewModel.isEditingWorkouts.toggle()
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("New workout") {
                            viewModel.setViewedWorkout()
                        }
                        Button("Saved Workout") {
                            viewModel.activeFullScreenCover = .routineSelector
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .environment(\.editMode, $editMode)
        }
    }
}


struct WorkoutHistoryInformationView: View {
    @StateObject var workout: Workout
    @State var isEditing: Bool
    let formatDate: (Int) -> String
    let setViewedWorkout: (Workout) -> Void

    var body: some View {
        Button {
            setViewedWorkout(workout)
        } label: {
            Group {
                HStack(spacing:0) {
                    VStack(alignment: .leading) {
                        Text(workout.startTime.formattedMonthDay())
                            .font(.title)
                        Text(workout.name)
                        Text(formatDate(workout.calcDuration()))
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
}

#Preview {
    WorkoutHistoryView()
}
