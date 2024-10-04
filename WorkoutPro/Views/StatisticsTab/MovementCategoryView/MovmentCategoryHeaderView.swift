//
//  MovmentCategoryHeaderView.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 9/17/24.
//

import SwiftUI

struct MovementCategoryHeaderView: View {
    let selectedChartStyle: MovementCategoryView.ChartStyle
    @ObservedObject var viewModel = MovementCategoryViewViewModel()
    
    var body: some View {
        switch selectedChartStyle {
            case .pie:
                if let bestCategory = viewModel.mostSetsCategory() {
                    Text("Your most exercised body part is ") +
                    Text("\(bestCategory.0)").bold().foregroundColor(.blue) +
                    Text(" with ") +
                    Text("\(viewModel.mostSetsCategoryPercentage ?? "0%")").bold() +
                    Text(" of all sets.")
                }
                
            case .bar:
                if let bestCategory = viewModel.mostSetsCategory() {
                    Text("Your most exercised body part is ") +
                    Text("\(bestCategory.0)").bold().foregroundColor(.blue) +
                    Text(" with ") +
                    Text("\(bestCategory.1) total sets ").bold() +
                    Text("completed.")
                }
        }
    }
}

#Preview {
    MovementCategoryHeaderView(selectedChartStyle: .pie)
}
