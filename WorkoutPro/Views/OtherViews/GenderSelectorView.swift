//
//  GenderSelectorView.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 7/27/24.
//

import SwiftUI

struct GenderSelectorView: View {
    @Environment(\.presentationMode) var isPresented
    @State var gender: String
    var setGender: (String) -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Picker("Gender", selection: $gender) {
                    Text("Select")
                    Text("Male")
                        .tag("Male")
                    Text("Female")
                        .tag("Female")
                }
                .pickerStyle(WheelPickerStyle())
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        isPresented.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        setGender(gender)
                        isPresented.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle("Gender")
            .navigationBarTitleDisplayMode(.inline)
            .overlay(
                VStack {
                    Divider()
                        .background(Color.gray)
                        .frame(height: 1)
                    Spacer()
                }
            )
        }
    }
}


#Preview {
    GenderSelectorView(gender: "", setGender: { _ in })
}
