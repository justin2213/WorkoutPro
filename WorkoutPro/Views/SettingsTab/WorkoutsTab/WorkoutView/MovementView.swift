//
//  SwiftUIView.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 8/26/24.
//

import SwiftUI

import Foundation

struct MovementView: View {
    @ObservedObject var movement: WorkoutMovement
    @State private var isEditing: Bool = false
    @State var isShowingNotes: Bool = true
    @FocusState.Binding var focusedField: FieldFocus? // Binding to manage the currently focused field
    @State var movementIndex: Int
    
    let showEditMovementSheet: () -> Void
    let deleteMovement: () -> Void
    let showMovementSelectorSheet: () -> Void
    let setMovementAction: (@escaping (Movement) -> Void) -> Void

    var body: some View {
        Section {
            VStack(spacing: 5) {
                Text(movement.name)
                    .autocorrectionDisabled()
                    .keyboardType(.alphabet)
                    .padding(5)
                Divider()
            }
            .listRowSeparator(.hidden)
            .listRowSpacing(0)
            
            ForEach(movement.sets.indices, id: \.self) { setIndex in
                VStack(spacing: 0) { // Remove spacing between VStack elements
                    HStack {
                        Image(systemName: "\(setIndex + 1).circle")
                            .resizable(resizingMode: .stretch)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .padding(.trailing, 10)
                            .fontWeight(.light)
                            .foregroundStyle(!movement.sets[setIndex].weight.isEmpty && !movement.sets[setIndex].reps.isEmpty ?  .primary : .tertiary)
                        Divider()
                        Spacer()
                        VStack(spacing: 1) {
                            if !movement.sets[setIndex].weight.isEmpty {
                                Text("Weight")
                                    .font(.footnote)
                                    .foregroundStyle(.tertiary)
                            }
                            TextField("Weight", text: Binding(
                                get: {
                                    movement.sets[setIndex].weight
                                },
                                set: { newValue in
                                    movement.sets[setIndex].weight = newValue
                                    withAnimation {
                                        isEditing = !newValue.isEmpty
                                    }
                                }
                            ))
                            .autocorrectionDisabled()
                            .keyboardType(.decimalPad)
                            .focused($focusedField, equals: .weight(movementIndex: movementIndex, setIndex: setIndex))
                            .id(FieldFocus.weight(movementIndex: movementIndex, setIndex: setIndex))
                        }
                        .multilineTextAlignment(.center)
                        .frame(height: 34)
                        Spacer()
                        Divider()
                        Spacer()
                        VStack(spacing: 1) {
                            if !movement.sets[setIndex].reps.isEmpty {
                                Text("Reps")
                                    .font(.footnote)
                                    .foregroundStyle(.tertiary)
                            }
                            TextField("Reps", text: Binding(
                                get: {
                                    movement.sets[setIndex].reps
                                },
                                set: { newValue in
                                    movement.sets[setIndex].reps = newValue
                                    withAnimation {
                                        isEditing = !newValue.isEmpty
                                    }
                                }
                            ))
                            .autocorrectionDisabled()
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .reps(movementIndex: movementIndex, setIndex: setIndex))
                            .id(FieldFocus.reps(movementIndex: movementIndex, setIndex: setIndex))
                        }
                        .multilineTextAlignment(.center)
                        .frame(height: 34)
                        Spacer()
                    }
                    .offset(y: -2)
                    
                    
                    Divider()
                }
                .listRowSeparator(.hidden)
                .listRowSpacing(0)
                .padding(0)
                .transition(.move(edge: .bottom)) // Add a move transition from the bottom
                .animation(.easeInOut, value: movement.sets) // Apply animation to the list
                .swipeActions {
                    Button("Delete") {
                        withAnimation {
                            movement.removeSet(index: setIndex)
                            if movement.sets.isEmpty {
                                deleteMovement()
                            }
                        }
                    }
                    .tint(.red)
                }
            }
            
            if isShowingNotes {
                VStack {
                    TextField("Notes", text: $movement.notes)
                        .autocorrectionDisabled()
                        .keyboardType(.alphabet)
                        .listRowSeparator(.hidden)
                        .focused($focusedField, equals: .notes(movementIndex: movementIndex))
                        .id(FieldFocus.notes(movementIndex: movementIndex))
                    Divider()
                }
                .listRowSpacing(0)
                .transition(.move(edge: .bottom)) // Add a move transition from the bottom
                .animation(.easeInOut, value: isShowingNotes) // Apply animation to the visibility
            }
            
            HStack(alignment: .center) {
                
                Button("Add Set") {
                    withAnimation {
                        movement.addSet()
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
                .frame(width: 100, height: 30, alignment: .leading)
                
                Spacer()
                Menu {
                    Button(action: {
                        deleteMovement()
                    }) {
                        Label("Delete", systemImage: "trash")
                    }
                    
                    Button(action: {
                        showEditMovementSheet()
                    }) {
                        Label("Reorder Movements", systemImage: "arrow.up.and.down.righttriangle.up.fill.righttriangle.down.fill")
                    }
                    
                    Button(action: {
                        setMovementAction(movement.replaceMovement)
                        showMovementSelectorSheet()
                    }) {
                        Label("Replace Movement", systemImage: "arrow.2.squarepath")
                    }
                    Button(action: {
                        withAnimation {
                            isShowingNotes.toggle()
                        }
                    }) {
                        Label("Toggle Notes", systemImage: "pencil")
                    }
                    Button(action: {
                        // Statistics Action
                    }) {
                        Label("Statistics", systemImage: "chart.bar.fill")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .resizable(resizingMode: .stretch)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 25)
                }
                .padding(.trailing, 15)
            }
            .listRowSeparator(.hidden)
            
        }
        
    }
}

