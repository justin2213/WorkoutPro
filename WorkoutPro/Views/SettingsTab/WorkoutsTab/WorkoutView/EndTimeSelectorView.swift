//
//  StartTimeSelectorView.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 8/28/24.
//

import SwiftUI

struct EndTimeSelectorView: View {
    @Environment(\.presentationMode) var isPresented
    @State var endTime: Date
    @State var startTime: Date
    var setTime: (Date) -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                DatePicker("", selection: $endTime, in: startTime...)
                    .datePickerStyle(.wheel)
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
                        setTime(endTime)
                        isPresented.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle("End Time")
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
    EndTimeSelectorView(endTime: Date(), startTime: Date(), setTime: {_ in } )
}
