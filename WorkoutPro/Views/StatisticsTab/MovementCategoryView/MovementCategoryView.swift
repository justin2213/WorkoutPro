//
//  MovementCategoryPieChartView.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 9/17/24.
//

import SwiftUI
import Charts

struct MovementCategoryView: View {
    @ObservedObject var viewModel = MovementCategoryViewViewModel()
    enum ChartStyle: String, CaseIterable, Identifiable {
        case pie = "Pie Chart"
        case bar = "Bar Chart"
        var id: Self { self }
    }
    
    @State private var selectedChartStyle: ChartStyle = .pie
    
    @ViewBuilder
    var barChart: some View {
        Chart(Array(viewModel.movementCategoryData.keys), id: \.self) { category in
            let sets = viewModel.movementCategoryData[category] ?? 0
            BarMark(
                x: .value("Sets", sets),         // Use 'Sets' for the x-axis to represent the length of the bars
                y: .value("Category", category)  // Use 'Category' for the y-axis to represent the different categories
            )
            .annotation(position: .trailing, alignment: .leading) {
                Text(String(sets))
                    .opacity(category == viewModel.movementCategoryData.max(by: { $0.value < $1.value })?.key ? 1 : 0.3)
            }
            .foregroundStyle(by: .value("Category", category))
            .opacity(category == viewModel.movementCategoryData.max(by: { $0.value < $1.value })?.key ? 1 : 0.3)
        }
        .chartLegend(.hidden)
        .frame(maxHeight: 400)


    }

    var pieChart: some View {
            // Pie Chart View
            Chart(Array(viewModel.movementCategoryData.keys), id: \.self) { category in
                let sets = viewModel.movementCategoryData[category] ?? 0
                SectorMark(
                    angle: .value("Sets", sets),  // Use 'sets' for the angle
                    innerRadius: .ratio(0.618),
                    angularInset: 1.5
                )
                .cornerRadius(5.0)
                .foregroundStyle(by: .value("Category", category))  // Use 'category' for the foreground style
                .opacity(category == viewModel.movementCategoryData.max(by: { $0.value < $1.value })?.key ? 1 : 0.3)  // Highlight the category with the most sets
            }
            .chartLegend(alignment: .center, spacing: 18)
            .aspectRatio(1, contentMode: .fit)
            .chartBackground { chartProxy in
                GeometryReader { geometry in
                    let frame = geometry[chartProxy.plotFrame!]
                    
                    if let bestCategory = viewModel.movementCategoryData.max(by: { $0.value < $1.value }) {
                        VStack {
                            Text("Most Sets Category")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                            Text(bestCategory.key)
                                .font(.title2.bold())
                                .foregroundColor(.primary)
                            Text("\(bestCategory.value) sets")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                        .position(x: frame.midX, y: frame.midY)
                    }
                }
            }
    }
        
        
        
    var body: some View {
        VStack {
            Picker("Chart Type", selection: $selectedChartStyle) {
                ForEach(ChartStyle.allCases) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(.segmented)
            
    
            MovementCategoryHeaderView(selectedChartStyle: selectedChartStyle, viewModel: viewModel)
            .font(.title3).padding(.vertical)
            
            switch selectedChartStyle {
                case .bar:
                    barChart
                case .pie:
                    pieChart
            }
            
            
            
            Spacer()
            //  SalesPerBookCategoryListView(salesViewModel: salesViewModel)
        } .padding()
            .navigationTitle("Movement Set Totals")
    }
}

#Preview {
    MovementCategoryView()
}
