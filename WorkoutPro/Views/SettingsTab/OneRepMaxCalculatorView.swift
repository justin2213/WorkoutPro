//
//  OneRepMaxCalculatorView.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 8/7/24.
//

import SwiftUI

struct OneRepMaxCalculatorView: View {
    @StateObject var viewModel = OneRepMaxCalculatorViewViewModel()
    @FocusState var focusedInput: Field?
    
    enum Field: Int, Hashable, CaseIterable {
        case weight
        case reps
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Form {
                Section {
                    HStack {
                        Text("Weight:")
                        TextField("lbs", text: $viewModel.weight)
                            .focused($focusedInput, equals: .weight)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                  
                    HStack {
                        Text("Reps:")
                        TextField("Count", text: $viewModel.reps)
                            .focused($focusedInput, equals: .reps)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    if !viewModel.errorMessage.isEmpty {
                        HStack {
                            Image(systemName: "exclamationmark.circle")
                                .foregroundStyle(Color.red)
                            Text(viewModel.errorMessage)
                                .font(.caption)
                                .foregroundStyle(Color.red)
                        }
                    }
                } footer: {
                    HStack(alignment: .firstTextBaseline) {
                        Image(systemName: "exclamationmark.circle")
                        Text("This is only an estimate and does not reflect your true one-rep max. Use at your own discretion.")
                    }
                }

                // Smooth animation for the result section
                if !viewModel.oneRepMax.isEmpty {
                    Section {
                        ZStack {
                            RoundedRectangle(cornerSize: .zero)
                                .foregroundStyle(.clear)
                            VStack(spacing: 15) {
                                Text("Estimated One-Rep Max")
                                    .textCase(.none)
                                    .font(.title2)
                                    .bold()
                                    .foregroundStyle(.foreground)
                                VStack {
                                    Text(viewModel.oneRepMax)
                                        .font(.headline)
                                        .multilineTextAlignment(.center)
                                    Text("Your lift is \(String(format: "%.2f", viewModel.bodyWeightProportion)) times your bodyweight")
                                }
                            }
                        }
                        .listRowBackground(Color.clear)
                        // Adding smooth animation with a custom curve
                        .transition(.asymmetric(insertion: .move(edge: .top).combined(with: .opacity),removal: .opacity))
                        .animation(.easeInOut(duration: 0.6), value: viewModel.oneRepMax)
                    }
                }
                
                Section {
                    ZStack {
                        RoundedRectangle(cornerSize: .zero)
                            .foregroundStyle(.clear)
                        Button("Calculate") {
                            viewModel.calculateOneRepMax()
                        }
                    }
                }
            }
        }
        .formKeyboardStyle(focusedInput: $focusedInput)
        .navigationTitle("One-Rep Max Calculator")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    OneRepMaxCalculatorView()
}
