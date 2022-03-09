//
//  FilledLineChart.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import SwiftUI

// MARK: - Chart
/**
 View for creating a filled line chart.
 
 Uses `LineChartData` data model.
 
 # Declaration
 ```
 FilledLineChart(chartData: data)
 ```
 
 # View Modifiers
 The order of the view modifiers is some what important
 as the modifiers are various types for stacks that wrap
 around the previous views.
 */
@available(iOS 14.0, *)
public struct FilledLineChart<ChartData>: View where ChartData: FilledLineChartData {
    
    @ObservedObject private var chartData: ChartData
    
    private let minValue: Double
    private let range: Double
    
    @State private var startAnimation: Bool
    
    /// Initialises a filled line chart
    /// - Parameter chartData: Must be LineChartData model.
    public init(chartData: ChartData) {
        self.chartData = chartData
        self.minValue = chartData.minValue
        self.range = chartData.range
        self._startAnimation = State<Bool>(initialValue: chartData.shouldAnimate ? false : true)
    }
    
    public var body: some View {
        GeometryReader { geo in
            if chartData.isGreaterThanTwo() {
                ZStack {
                    chartData.getAccessibility()
                    TopLineSubView(chartData: chartData,
                                   colour: chartData.dataSets.style.lineColour)
                    FilledLineSubView(chartData: chartData,
                                      colour: chartData.dataSets.style.fillColour)
                }
                .onAppear { // Needed for axes label frames
                    self.chartData.viewData.chartSize = geo.frame(in: .local)
                }
            } else { CustomNoDataView(chartData: chartData) }
        }
    }
}

 // MARK: - Top Line
@available(iOS 14.0, *)
internal struct TopLineSubView<ChartData>: View where ChartData: FilledLineChartData {
    @ObservedObject private var chartData: ChartData
    private let colour: ChartColour
    
    @State private var startAnimation: Bool = false
    
    internal init(
        chartData: ChartData,
        colour: ChartColour
    ) {
        self.chartData = chartData
        self.colour = colour
        
        self._startAnimation = State<Bool>(initialValue: chartData.shouldAnimate ? false : true)
    }
    
    internal var body: some View {
        LineShape(dataPoints: chartData.dataSets.dataPoints,
                  lineType: chartData.dataSets.style.lineType,
                  minValue: chartData.minValue,
                  range: chartData.range)
            .scale(y: startAnimation ? 1 : 0, anchor: .bottom)
            .stroke(colour, strokeStyle: chartData.dataSets.style.strokeStyle)
        
            .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                self.startAnimation = true
            }
            .background(Color(.gray).opacity(0.000000001))
            .onDisappear {
                self.startAnimation = false
            }
    }
}

// MARK: - Fill
@available(iOS 14.0, *)
internal struct FilledLineSubView<ChartData>: View where ChartData: FilledLineChartData {
    
    @ObservedObject private var chartData: ChartData
    private let colour: ChartColour
    
    @State private var startAnimation: Bool = false
    
    internal init(
        chartData: ChartData,
        colour: ChartColour
    ) {
        self.chartData = chartData
        self.colour = colour
        
        self._startAnimation = State<Bool>(initialValue: chartData.shouldAnimate ? false : true)
    }
    
    internal var body: some View {
        FilledLine(dataPoints: chartData.dataSets.dataPoints,
                   lineType: chartData.dataSets.style.lineType,
                   minValue: chartData.minValue,
                   range: chartData.range)
            .scale(y: startAnimation ? 1 : 0, anchor: .bottom)
            .fill(colour)
        
            .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                self.startAnimation = true
            }
            .background(Color(.gray).opacity(0.000000001))
            .onDisappear {
                self.startAnimation = false
            }
    }
}
