//
//  StartTimeSelectorView.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 8/28/24.
//

import SwiftUI

struct StartTimeSelectorView: View {
    @Environment(\.presentationMode) var isPresented
    @State var endTime: Date
    @State var startTime: Date
    var setTime: (Date) -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                DatePicker("", selection: $startTime, in: ...endTime)
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
                        setTime(startTime)
                        isPresented.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle("Start Time")
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
    StartTimeSelectorView(endTime: Date(), startTime: Date(), setTime: {_ in } )
}
