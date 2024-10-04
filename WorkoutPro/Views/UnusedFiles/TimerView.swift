//
//  TimerTesingView.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 7/7/24.
//

/*
import SwiftUI
import Foundation

struct TimerView: View {
    @ObservedObject var viewModel: ActiveWorkoutViewViewModel

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.state == .cancelled {
                    timePickerControl
                } else {
                    progressView
                }
                
                timerControls
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Set Timer")
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
    
    var timerControls: some View {
        HStack {
            Button("Cancel") {
                viewModel.state = .cancelled
            }
            .buttonStyle(CancelButtonStyle())

            Spacer()

            switch viewModel.state {
            case .cancelled:
                Button("Start") {
                    viewModel.state = .active
                }
                .buttonStyle(StartButtonStyle())
            case .paused:
                Button("Resume") {
                    viewModel.state = .resumed
                }
                .buttonStyle(PauseButtonStyle())
            case .active, .resumed:
                Button("Pause") {
                    viewModel.state = .paused
                }
                .buttonStyle(PauseButtonStyle())
            }
        }
        .padding(.horizontal, 32)
    }
    
    var timePickerControl: some View {
        ZStack {
            HStack(spacing: 0) {
                TimePickerView(title: "min", range: viewModel.minutesRange, binding: $viewModel.timerSelectedMinutesAmount, offset: 9)
                TimePickerView(title: "sec", range: viewModel.secondsRange, binding: $viewModel.timerSelectedSecondsAmount, offset: -9)
            }
            .frame(width: 360, height: 255)
            .padding(.all, 32)
            Rectangle()
                .frame(width:10, height: 32)
                .foregroundStyle(.regularMaterial)
                .opacity(0.9)
                .contrast(1.02)
                
        }
    }

    var progressView: some View {
        ZStack {
            withAnimation {
                CircularProgressView(progress: $viewModel.workoutTimerProgress)
            }

            VStack {
                Text(viewModel.workoutTimerSecondsToCompletion.asTimestamp)
                    .font(.largeTitle)
                
                Text(viewModel.workoutTimerCompletionDate, format: .dateTime.hour().minute())
            }
        }
        .frame(width: 360, height: 255)
        .padding(.all, 32)
    }
}


struct TimePickerView: View {
    // This is used to tighten up the spacing between the Picker and its
    // respective label
    //
    // This allows us to avoid having to use custom
    private let pickerViewTitlePadding: CGFloat = 4.0

    let title: String
    let range: ClosedRange<Int>
    let binding: Binding<Int>
    let offset: CGFloat

    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                Picker(title, selection: binding) {
                    ForEach(range, id: \.self) { timeIncrement in
                            // Forces the text in the Picker to be
                            // right-aligned
                            Text("\(timeIncrement)")
                                .foregroundColor(.white)
                    }
                }
                .pickerStyle(InlinePickerStyle())
                .labelsHidden()
                .clipped()
                HStack {
                    Text(title)
                        .fontWeight(.bold)
                        .padding(.leading, 60)
                }
            }
            .offset(x: offset)
        }
        
    }
}

struct CircularProgressView: View {
    @Binding var progress: Float

    var body: some View {
        ZStack {
            // Gray circle
            Circle()
                .stroke(lineWidth: 8.0)
                .opacity(0.3)
                .foregroundColor(.gray)

            // Orange circle
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 8.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(.blue.opacity(0.5))
                // Ensures the animation starts from 12 o'clock
                .rotationEffect(Angle(degrees: 270))
                .scaleEffect(x: -1, y: 1, anchor: .center)
        }
        // The progress animation will animate over 1 second which
        // allows for a continuous smooth update of the ProgressView
        .animation(.linear(duration: 1.0), value: progress)
    }
}




// Button Styles

struct PauseButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 80, height: 80)
            .foregroundColor(.orange)
            .background(.orange.opacity(configuration.isPressed ? 0.5 : 0.3))
            .clipShape(Circle())
            .padding(.all, 3)
            
    }
}

struct StartButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 80, height: 80)
            .foregroundColor(.blue)
            .background(.blue.opacity(configuration.isPressed ? 0.5 : 0.3))
            .clipShape(Circle())
            .padding(.all, 3)
            
    }
}

struct CancelButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 80, height: 80)
            .foregroundColor(.red)
            .background(.red.opacity(configuration.isPressed ? 0.5 : 0.3))
            .clipShape(Circle())
            .padding(.all, 3)
            
    }
}

#Preview {
    TimerView(viewModel: ActiveWorkoutViewViewModel(isSelectingExercise: false, workout: Workout()))
}

*/
