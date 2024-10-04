//
//  SettingsView.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 6/5/24.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled: Bool = true
    @ObservedObject var user = User.shared
    @State var savedPresented = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Group {
                        HStack{
                            Spacer()
                            VStack(spacing: 15) {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .frame(width:100, height: 100, alignment: .center)
                                    .foregroundStyle(Color.blue)
                                VStack(spacing: 5) {
                                    Text(user.name)
                                    .font(.largeTitle)
                                }
                            }
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.clear)
                    Section(header: Text("Profile Information"), content: {
                        HStack{
                            NavigationLink(destination:
                                EditProfileView()
                            ) {
                                Text("Profile")
                            }

                        }
                    })
                    
                    Section(header: Text("Progress"), content: {
                        HStack{
                            NavigationLink {
                               BadgesView()
                            } label: {
                                Text("Badges")
                            }

                        }
                        
                        HStack{
                            NavigationLink {
                               OneRepMaxCalculatorView()
                            } label: {
                                Text("One-Rep Max Calculator")
                            }

                        }
                    })

                    
                    Section(header: Text("Workouts"), content: {
                        HStack{
                            NavigationLink {
                                SavedExercisesView()
                            } label: {
                                Text("Movements")
                            }
                        }

                        HStack{
                            NavigationLink {
                               SavedWorkoutRoutinesView()
                            } label: {
                                Text("Routines")
                            }
                        }

                    })

                    Section(header: Text("PREFRENCES"), content: {
                        HStack{
                            Toggle(isOn: $isDarkModeEnabled) {
                                Text("Dark Mode")
                            }
                        }
                    })
                }
                .navigationBarTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
            }
            }
            
        
    }
}
#Preview {
    SettingsView()
}
