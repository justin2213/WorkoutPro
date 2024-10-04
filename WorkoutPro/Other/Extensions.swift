//
//  Extensions.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 6/12/24.
//

import Foundation
import SwiftUI

extension Int {
    var asTimestamp: String {
        let minute = self / 60 % 60
        let second = self % 60

        return String(format: "%02i:%02i",minute, second)
    }
}

extension View {
    func formKeyboardStyle<T: RawRepresentable & CaseIterable & Hashable>(focusedInput: FocusState<T?>.Binding) -> some View where T.RawValue == Int {
        func allCasesForType(_ type: T.Type) -> [T] {
            return Array(T.allCases)
        }

        func getFirstValue(for type: T.Type) -> T? {
            return allCasesForType(type).first
        }

        func getLastValue(for type: T.Type) -> T? {
            return allCasesForType(type).last
        }

        return self
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button {
                        guard let currentInput = focusedInput.wrappedValue,
                              let firstValue = getFirstValue(for: T.self)?.rawValue else { return }

                        let index = max(currentInput.rawValue - 1, firstValue)
                        focusedInput.wrappedValue = T(rawValue: index)
                    } label: {
                        Image(systemName: "chevron.up")
                    }
                    .disabled(focusedInput.wrappedValue?.rawValue == getFirstValue(for: T.self)?.rawValue)

                    Button {
                        guard let currentInput = focusedInput.wrappedValue,
                              let lastValue = getLastValue(for: T.self)?.rawValue else { return }

                        let index = min(currentInput.rawValue + 1, lastValue)
                        focusedInput.wrappedValue = T(rawValue: index)
                    } label: {
                        Image(systemName: "chevron.down")
                    }
                    .disabled(focusedInput.wrappedValue?.rawValue == getLastValue(for: T.self)?.rawValue)

                    Spacer()

                    Button {
                        focusedInput.wrappedValue = nil
                    } label: {
                        Text("Done")
                    }
                }
            }
    }
}




import SwiftUI

extension View {
    func workoutKeyboardStyle(focusedInput: FocusState<FieldFocus?>.Binding, values: [FieldFocus]) -> some View {
        func getFirstValue() -> FieldFocus? {
            return values.first
        }

        func getLastValue() -> FieldFocus? {
            return values.last
        }

        func getNextValue(for current: FieldFocus?) -> FieldFocus? {
            guard let current = current,
                  let currentIndex = values.firstIndex(where: { $0.rawValue == current.rawValue }) else {
                return nil
            }
            let nextIndex = currentIndex + 1
            guard nextIndex < values.count else {
                return nil
            }
            return values[nextIndex]
        }

        func getPreviousValue(for current: FieldFocus?) -> FieldFocus? {
            guard let current = current,
                  let currentIndex = values.firstIndex(where: { $0.rawValue == current.rawValue }) else {
                return nil
            }
            let previousIndex = currentIndex - 1
            guard previousIndex >= 0 else {
                return nil
            }
            return values[previousIndex]
        }

        return self
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button {
                        if let currentInput = focusedInput.wrappedValue {
                            if let previousInput = getPreviousValue(for: currentInput) {
                                if focusedInput.wrappedValue != previousInput {
                                    focusedInput.wrappedValue = previousInput
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "chevron.up")
                    }
                    .disabled(focusedInput.wrappedValue == getFirstValue())

                    Button {
                        if let currentInput = focusedInput.wrappedValue {
                            if let nextInput = getNextValue(for: currentInput) {
                                if focusedInput.wrappedValue != nextInput {
                                    focusedInput.wrappedValue = nextInput
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "chevron.down")
                    }
                    .disabled(focusedInput.wrappedValue == getLastValue())

                    Spacer()

                    Button {
                        focusedInput.wrappedValue = nil
                    } label: {
                        Text("Done")
                    }
                }
            }
    }
}


extension Date {
    func formattedMonthDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: self)
    }
}

extension Int {
    func formatAsHeight() -> String {
        let feet = self / 12
        let inches = self % 12
        return "\(feet)'\(inches)\""
    }
}

extension String {
    func convertHeightToInches() -> Int {
        let components = self.split(separator: "'")
        if components.count == 2 {
            let feet = Int(components[0]) ?? 0
            let inches = Int(components[1].replacingOccurrences(of: "\"", with: "")) ?? 0
            return (feet * 12) + inches
        }
        return 0
    }
}


