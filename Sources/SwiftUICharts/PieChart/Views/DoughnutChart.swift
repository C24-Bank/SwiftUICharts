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
    
    @ObservedObject private var chartData: ChartData
    
    @State private var startAnimation: Bool
//    @State private var lastNumberOfDataPoints = 0
    @State private var lastAmounts: [UUID: Double] = [:]
    
    /// Initialises a bar chart view.
    /// - Parameter chartData: Must be DoughnutChartData.
    public init(chartData: ChartData) {
        self.chartData = chartData
        self._startAnimation = State<Bool>(initialValue: chartData.shouldAnimate ? false : true)
    }
    
    public var body: some View {
        DispatchQueue.main.async {
            for dp in chartData.dataSets.dataPoints {
                lastAmounts[dp.id] = dp.amount
            }
//            lastNumberOfDataPoints = chartData.dataSets.dataPoints.count
        }
        
        return GeometryReader { geo in
            ZStack {
                ForEach(chartData.dataSets.dataPoints.indices, id: \.self) { data in
                    let animationDuration = animationDuration(for: chartData.dataSets.dataPoints[data], index: data)
                    let animationDelay = animationDelay(for: chartData.dataSets.dataPoints[data], index: data)
                    
                    DoughnutSegmentShape(id: chartData.dataSets.dataPoints[data].id,
                                         startAngle: chartData.dataSets.dataPoints[data].startAngle,
                                         amount: lastAmounts.keys.contains(chartData.dataSets.dataPoints[data].id) ? chartData.dataSets.dataPoints[data].amount : 0)
                        .stroke(chartData.dataSets.dataPoints[data].colour,
                                lineWidth: chartData.chartStyle.strokeWidth)
                        .overlay(dataPoint: chartData.dataSets.dataPoints[data],
                                 chartData: chartData,
                                 rect: geo.frame(in: .local))
//                        .scaleEffect(startAnimation ? 1 : 0)
//                        .opacity(startAnimation ? 1 : 0)
                        .id(chartData.dataSets.dataPoints[data].id)
//                        .animation(Animation.spring().delay(Double(data) * 0.06))
                        .animation(.linear(duration: animationDuration).delay(animationDelay))
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
        .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
            self.startAnimation = true
        }
        .onDisappear {
            self.startAnimation = false
        }
    }
    
    private let circleAnimationDuration: Double = 0.8
    
    // TODO: Issue is that isNewSegment does not work, because on the second reload isNewSegment is always false I suppose
    // We would need to figure out if we're transitioning, but how?
    
    private func animationDuration(for dp: PieChartDataPoint, index: Int) -> Double {
//        let isNewSegment = index >= lastNumberOfDataPoints
        var isNewSegment = true
        if lastAmounts.keys.contains(dp.id) {
            isNewSegment = false
        }
        let amount = isNewSegment ? 0 : dp.amount
        let percentage = (amount * 15.91549430919)/100
        
        if isNewSegment {
            return circleAnimationDuration * percentage
        } else {
            return 0.33
        }
    }
    
    private func animationDelay(for dp: PieChartDataPoint, index: Int) -> Double {
//        let isNewSegment = index >= lastNumberOfDataPoints
        var isNewSegment = true
        if lastAmounts.keys.contains(dp.id) {
            isNewSegment = false
        }
        let startAngle = dp.startAngle + Double.pi/2
        let percentage = (startAngle * 15.91549430919)/100
        let baseDelay = circleAnimationDuration * percentage
        
        if isNewSegment {
            return baseDelay
        } else {
            return 0
//            return baseDelay - Double(index) * 0.05
        }
    }
}
