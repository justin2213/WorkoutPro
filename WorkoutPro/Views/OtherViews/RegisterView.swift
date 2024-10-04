//
//  RegisterView.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 6/5/24.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewViewModel()
    @FocusState var focusedInput: field?
    
    enum field: Int, Hashable, CaseIterable {
        case name
    }

    var body: some View {
        NavigationStack {
            VStack {
                Text("WorkoutPro")
                    .font(.title)
                Form {
                    Section {
                        TextField("Name", text: $viewModel.name)
                            .focused($focusedInput, equals: .name)
                            .keyboardType(.alphabet)
                            .autocorrectionDisabled(true)
                        HStack {
                            Text("Height")
                            Spacer()
                            Button {
                                viewModel.activeSheet = .heightSelector
                            } label: {
                                HStack(spacing: 3) {
                                    Text(viewModel.height == "" ? "Set" : viewModel.height)
                                    Image(systemName: "chevron.up.chevron.down")
                                        .resizable(resizingMode: .stretch)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 12, height: 12)
                                }
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                        
                        HStack {
                            Text("Weight")
                            Spacer()
                            Button {
                                viewModel.activeSheet = .weightSelector
                            } label: {
                                HStack(spacing: 3) {
                                    Text(viewModel.weight == "" ? "Set" : "\(viewModel.weight) lbs")
                                    Image(systemName: "chevron.up.chevron.down")
                                        .resizable(resizingMode: .stretch)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 12, height: 12)
                                }
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                        
                        HStack {
                            Text("Gender")
                            Spacer()
                            Button {
                                viewModel.activeSheet = .genderSelector
                            } label: {
                                HStack(spacing: 3) {
                                    Text(viewModel.gender.isEmpty ? "Select" : viewModel.gender)
                                    Image(systemName: "chevron.up.chevron.down")
                                        .resizable(resizingMode: .stretch)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 12, height: 12)
                                }
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                        
                        HStack {
                            Text("Birthday")
                            Spacer()
                            Button {
                                viewModel.activeSheet = .birthdaySelector
                            } label: {
                                HStack(spacing: 3) {
                                    Text(viewModel.birthday.formatted(date: .numeric, time: .omitted))
                                    Image(systemName: "chevron.up.chevron.down")
                                        .resizable(resizingMode: .stretch)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 12, height: 12)
                                }
                            }
                            .buttonStyle(BorderlessButtonStyle())
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
                        ZStack {
                            RoundedRectangle(cornerSize: .zero)
                                .foregroundStyle(.clear)
                            Button("Start Journey") {
                                viewModel.createUser()
                            }
                        }
                    } header: {
                        Text("Welcome")
                            .font(.callout)
                    } footer: {
                        HStack(alignment: .firstTextBaseline) {
                            Image(systemName: "questionmark.circle")
                            Text("This information is for calculations across the application. Any misinformation may cause false calculations.")
                        }
                    }
                }
            }
            .formKeyboardStyle(focusedInput: $focusedInput)
            .sheet(item: $viewModel.activeSheet) { sheet in
                switch sheet {
                case .heightSelector:
                    HeightSelectorView(height: viewModel.height, setHeight: viewModel.setHeight).presentationDetents([.fraction(0.4)])
                    
                case .weightSelector:
                    WeightSelectorView(weight: viewModel.weight, setWeight: viewModel.setWeight).presentationDetents([.fraction(0.4)])
                    
                case .genderSelector:
                    GenderSelectorView(gender: viewModel.gender, setGender: viewModel.setGender).presentationDetents([.fraction(0.4)])
                case .birthdaySelector:
                    BirthdaySelectorView(birthday: viewModel.birthday, setBirthday: viewModel.setBirthday).presentationDetents([.fraction(0.4)])
                }
            }
        }
    }
}

#Preview {
    RegisterView()
}
