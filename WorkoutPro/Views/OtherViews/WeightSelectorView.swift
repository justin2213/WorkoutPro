import SwiftUI

struct WeightSelectorView: View {
    @Environment(\.presentationMode) var isPresented
    @State var weight: String
    var setWeight: (String) -> Void
    
    @State private var initialWeightIndex: Int = 149
    
    let weights: [String] = {
        var weights = [String]()
        for pounds in 1...500 {
            weights.append("\(pounds)")
        }
        return weights
    }()
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                ZStack {
                    Text("lbs")
                    .padding(.leading,75)
                    .bold()
                    Picker("Weight", selection: $initialWeightIndex) {
                        ForEach(0..<weights.count, id: \.self) { index in
                            Text(self.weights[index])
                                .tag(index)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }
                
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
                        setWeight(weights[initialWeightIndex])
                        isPresented.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle("Weight")
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
                if let index = weights.firstIndex(of: weight) {
                    initialWeightIndex = index
                }
            }
        }
    }
}

#Preview {
    WeightSelectorView(weight: "150", setWeight: {_ in })
}
