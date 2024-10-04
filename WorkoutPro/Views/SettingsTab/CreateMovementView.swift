//
//  CreateExerciseView.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 6/11/24.
//

import SwiftUI

struct CreateMovementView: View {
    @StateObject var viewModel: CreateExerciseViewViewModel
    @State var header: String
    @Environment(\.presentationMode) var isPresented
    @FocusState var focusedInput: Field?
    
    enum Field: Int, Hashable, CaseIterable {
        case name
    }
    
    init(header: String = "Create Movement", movement: Movement) {
        _viewModel = StateObject(wrappedValue: CreateExerciseViewViewModel(movement: movement))
        _header = State(initialValue: header)
    }
    
    
    var body: some View {
        VStack {
            Form {
                Section {
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundStyle(Color.red)
                    }
                    TextField("Movement Name", text: $viewModel.movement.name)
                        .focused($focusedInput, equals: .name)
                        .keyboardType(.alphabet)
                        .autocorrectionDisabled(true)
                    Picker("Movement Type", selection: $viewModel.movement.type) {
                        Text("Select")
                        Text("Reps").tag("Reps")
                        Text("Weight").tag("Weight")
                    }
                    Picker("Targets", selection: $viewModel.movement.bodyPart) {
                        Text("Select")
                        Text("Chest").tag("Chest")
                        Text("Back").tag("Back")
                        Text("Shoulders").tag("Shoulders")
                        Text("Biceps").tag("Biceps")
                        Text("Triceps").tag("Triceps")
                        Text("Legs").tag("Legs")
                    }
                    .pickerStyle(NavigationLinkPickerStyle())
                    
                } header: {
                    Text("Movement Information")
                } footer: {
                    HStack(alignment: .firstTextBaseline) {
                        Image(systemName: "questionmark.circle")
                        Text("This information is used for statistics across the application.")
                    }
                }
                
                if header == "Edit Movement" {
                    
                    ZStack {
                        RoundedRectangle(cornerSize: .zero)
                            .foregroundStyle(.clear)
                        Button {
                            viewModel.showAlert = true
                        } label: {
                            HStack {
                                Image(systemName: "trash")
                                Text("Delete Movement")
                            }
                            .foregroundStyle(Color.red)
                        }
                    }
                }
            }
        }
        .formKeyboardStyle(focusedInput: $focusedInput)
        .navigationTitle(header)
        .navigationBarBackButtonHidden(true)
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    isPresented.wrappedValue.dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    viewModel.saveMovement()
                    if viewModel.validate() {
                        isPresented.wrappedValue.dismiss()
                    }
                }
            }
        }
        .actionSheet(isPresented: $viewModel.showAlert) {
            ActionSheet(
                title: Text("Warning"),
                message: Text("Are you sure you want to delete this movement?"),
                buttons: [
                    .destructive(Text("Delete")) {
                        viewModel.deleteMovement()
                        isPresented.wrappedValue.dismiss()
                    },
                    .default(Text("Cancel")) {
                       
                    }
                ]
            )
        }
    }
}
#Preview {
    CreateMovementView(movement: Movement(id: UUID().uuidString, name: "", type: "", bodyPart: ""))
}
