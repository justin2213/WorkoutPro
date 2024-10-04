//
//  BirthdaySelectorView.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 7/27/24.
//

import SwiftUI

struct BirthdaySelectorView: View {
    @Environment(\.presentationMode) var isPresented
    @State var birthday: Date
    var setBirthday: (Date) -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                DatePicker("Birthday", selection: $birthday, in: ...Date(), displayedComponents: .date)
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                
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
                        setBirthday(birthday)
                        isPresented.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle("Birthday")
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
    BirthdaySelectorView(birthday: Date(), setBirthday: { _ in })
}
