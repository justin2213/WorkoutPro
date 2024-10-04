//
//  MovementSelectorView.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 8/28/24.
//

import SwiftUI
import SwiftUI

struct MovementSelectorView: View {
    @Environment(\.presentationMode) var isPresented
    @State var exerciseAction: (Movement) -> Void

    var body: some View {
        VStack {
            List {
                NavigationLink("Chest", destination: FilteredMovementSelectorView(bodyPart: "Chest", exerciseAction: exerciseAction, onDismiss: { isPresented.wrappedValue.dismiss() }))
                NavigationLink("Back", destination: FilteredMovementSelectorView(bodyPart: "Back", exerciseAction: exerciseAction, onDismiss: { isPresented.wrappedValue.dismiss() }))
                NavigationLink("Shoulders", destination: FilteredMovementSelectorView(bodyPart: "Shoulders", exerciseAction: exerciseAction, onDismiss: { isPresented.wrappedValue.dismiss() }))
                NavigationLink("Biceps", destination: FilteredMovementSelectorView(bodyPart: "Biceps", exerciseAction: exerciseAction, onDismiss: { isPresented.wrappedValue.dismiss() }))
                NavigationLink("Triceps", destination: FilteredMovementSelectorView(bodyPart: "Triceps", exerciseAction: exerciseAction, onDismiss: { isPresented.wrappedValue.dismiss() }))
                NavigationLink("Legs", destination: FilteredMovementSelectorView(bodyPart: "Legs", exerciseAction: exerciseAction, onDismiss: { isPresented.wrappedValue.dismiss() }))
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Categories")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    isPresented.wrappedValue.dismiss()
                }
            }
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

struct FilteredMovementSelectorView: View {
    @ObservedObject var savedMovements = SavedMovements.shared
    @State var bodyPart: String
    @State var exerciseAction: (Movement) -> Void
    let onDismiss: () -> Void  // Use a non-escaping closure here

    var body: some View {
        VStack {
            List {
                ForEach(savedMovements.movements.indices.filter { savedMovements.movements[$0].bodyPart == bodyPart }, id: \.self) { index in
                    Button(savedMovements.movements[index].name) {
                        exerciseAction(savedMovements.movements[index])
                        onDismiss()  // Trigger dismiss explicitly
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle(bodyPart)
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
    MovementSelectorView(exerciseAction: { _ in })
}

#Preview {
    FilteredMovementSelectorView(bodyPart: "Chest", exerciseAction: { _ in }, onDismiss: {})
}
