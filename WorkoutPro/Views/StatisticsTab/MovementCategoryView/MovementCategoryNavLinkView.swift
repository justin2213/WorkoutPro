//
//  MovementCategoryNavLinkView.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 9/17/24.
//

import SwiftUI
import Charts

import SwiftUI
import Charts

struct MovementCategoryNavLinkView: View {
    @ObservedObject var viewModel = MovementCategoryViewViewModel()
    
    var body: some View {
        HStack(spacing: 30) {
            // Ensure MovementCategoryHeaderView is initialized correctly
            MovementCategoryHeaderView(selectedChartStyle: .pie, viewModel: viewModel)
            
            // Ensure the Chart is properly configured and has valid data
                Chart(Array(viewModel.movementCategoryData.keys), id: \.self) { category in
                    let sets = viewModel.movementCategoryData[category] ?? 0
                    SectorMark(
                        angle: .value("Sets", sets),  // Use 'sets' for the angle
                        innerRadius: .ratio(0.618),
                        angularInset: 1.5
                    )
                    .cornerRadius(5.0)
                    .opacity(category == viewModel.movementCategoryData.max(by: { $0.value < $1.value })?.key ? 1 : 0.3)  // Highlight the category with the most sets
                }
                .aspectRatio(1, contentMode: .fit)
                .frame(height: 75)  // Set a height that fits well with aspect ratio
        }
        .padding(.vertical)
    }
}

#Preview {
    MovementCategoryNavLinkView()
}


#Preview {
    MovementCategoryNavLinkView()
}
