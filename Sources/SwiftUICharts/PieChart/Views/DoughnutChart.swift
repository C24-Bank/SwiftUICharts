//
//  DoughnutChart.swift
//  
//
//  Created by Will Dale on 01/02/2021.
//

import SwiftUI

/**
 View for creating a doughnut chart.
 
 Uses `DoughnutChartData` data model.
 
 # Declaration
 ```
 DoughnutChart(chartData: data)
 ```
 
 # View Modifiers
 The order of the view modifiers is some what important
 as the modifiers are various types for stacks that wrap
 around the previous views.
 ```
 .touchOverlay(chartData: data)
 .infoBox(chartData: data)
 .floatingInfoBox(chartData: data)
 .headerBox(chartData: data)
 .legends(chartData: data)
 ```
 */
@available(iOS 14.0, *)
public struct DoughnutChart<ChartData>: View where ChartData: DoughnutChartData {
    
    private let percentPerRadian: Double = 15.91549430919
    private let circleAnimationDuration: Double = 0.66
    
    @ObservedObject private var chartData: ChartData
    
    // last amounts displayed for each datapoint. Contains a tuple where the first entry is the startAngle and the
    // second entry is the amount
    @State private var lastAmounts: [UUID: (startAngle: Double, amount: Double)] = [:]
    
    /// Initialises a bar chart view.
    /// - Parameter chartData: Must be DoughnutChartData.
    public init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    public var body: some View {
        DispatchQueue.main.async {
            for dp in chartData.dataSets.dataPoints {
                if lastAmounts.keys.contains(dp.id) {
                    lastAmounts[dp.id] = (dp.startAngle, dp.amount)
                } else {
                    lastAmounts[dp.id] = (dp.startAngle, 0)
                }
            }
        }
        
        return GeometryReader { geo in
            ZStack {
                ForEach(chartData.dataSets.dataPoints.indices, id: \.self) { data in
                    let animationDuration = animationDuration(for: chartData.dataSets.dataPoints[data])
                    let animationDelay = animationDelay(for: chartData.dataSets.dataPoints[data])
                    
                    DoughnutSegmentShape(id: chartData.dataSets.dataPoints[data].id,
                                         startAngle: chartData.dataSets.dataPoints[data].startAngle,
                                         amount: chartData.shouldAnimate == false || lastAmounts.keys.contains(chartData.dataSets.dataPoints[data].id) ? chartData.dataSets.dataPoints[data].amount : 0)
                        .stroke(chartData.dataSets.dataPoints[data].colour,
                                lineWidth: chartData.chartStyle.strokeWidth)
                        .overlay(dataPoint: chartData.dataSets.dataPoints[data],
                                 chartData: chartData,
                                 rect: geo.frame(in: .local))
                        .id(chartData.dataSets.dataPoints[data].id)
                        .animation(chartData.shouldAnimate ? .linear(duration: animationDuration).delay(animationDelay) : nil)
                        .if(chartData.touchPointData == [chartData.dataSets.dataPoints[data]]) {
                            $0
                                .scaleEffect(1.1)
                                .zIndex(1)
                                .shadow(color: Color.primary, radius: 10)
                        }
                        .accessibilityLabel(chartData.accessibilityTitle)
                        .accessibilityValue(chartData.dataSets.dataPoints[data].getCellAccessibilityValue(specifier: chartData.infoView.touchSpecifier))
                }
            }
        }
    }
    
    private func animationDuration(for dp: PieChartDataPoint) -> Double {
        guard chartData.shouldAnimate else {
            return 0
        }
        
        let transitionDuration = transitionDuration()
        if transitionDuration > 0 && lastAmounts.keys.contains(dp.id) {
            return transitionDuration
        } else {
            let percentage = (dp.amount * percentPerRadian)/100
            return circleAnimationDuration * percentage
        }
    }
    
    private func animationDelay(for dp: PieChartDataPoint) -> Double {
        guard chartData.shouldAnimate else {
            return 0
        }
        
        var isNewSegment = true
        if lastAmounts.keys.contains(dp.id), let lastAmount = lastAmounts[dp.id], lastAmount.1 > 0 {
            isNewSegment = false
        }
        
        // old segments do all transition at the same time, so do not have a delay
        if isNewSegment == false {
            return 0
        }
        
        let startAngle = dp.startAngle + Double.pi/2 // +pi/2 because in iOS top of the circle (0 degrees) is -pi/2 radians
        let percentage = (startAngle * percentPerRadian)/100
        
        let transitionDuration = transitionDuration()
        return max(transitionDuration + 0.16, (circleAnimationDuration * percentage))
    }
    
    /// Returns the duration required for transitioning existing segments to their new amounts
    private func transitionDuration() -> Double {
        // Find the largest amount we need to transition
        var amount = Double(0)
        for lastAmount in lastAmounts {
            let id = lastAmount.key
            let entry = lastAmount.value
            if entry.amount > 0 {
                if let newDP = chartData.dataSets.dataPoints.first(where: { $0.id == id }) {
                    amount = max(amount, max(newDP.amount, entry.amount))
                }
            }
        }
        
        let percentage = (amount * percentPerRadian)/100
        return circleAnimationDuration * percentage
    }
}
