//
//  HeightSelectorView.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 7/26/24.
//

import SwiftUI

import SwiftUI

struct HeightSelectorView: View {
    @Environment(\.presentationMode) var isPresented
    @State var height: String
    var setHeight: (String) -> Void
    
    @State private var initialHeightIndex: Int = 20
    
    let heights: [String] = {
        var heights = [String]()
        for feet in 4...7 {
            for inches in 0...11 {
                heights.append("\(feet)'\(inches)\"")
            }
        }
        return heights
    }()
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Picker("Height", selection: $initialHeightIndex) {
                    ForEach(0..<heights.count, id: \.self) { index in
                        Text(self.heights[index])
                            .tag(index)
                    }
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
                        setHeight(heights[initialHeightIndex])
                        isPresented.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle("Height")
            .navigationBarTitleDisplayMode(.inline)
            .overlay(
                VStack {
                    Divider()
                        .background(Color.gray)
                        .frame(height: 1)
                    Spacer()
                }
            )
            .onAppear {
                if let index = heights.firstIndex(of: height) {
                    initialHeightIndex = index
                }
            }
        }
    }
}

#Preview {
    HeightSelectorView(height: "5'8", setHeight: {_ in })
}
